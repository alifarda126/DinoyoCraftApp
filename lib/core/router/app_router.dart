import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app_settings.dart';
import '../services/auth_session.dart';
import '../services/fcm_service.dart';
import '../../features/auth/app_launch_splash_screen.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/new_password_screen.dart';
import '../../features/auth/onboarding_screen.dart';
import '../../features/auth/otp_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/chat/chat_list_screen.dart';
import '../../features/chat/chat_room_screen.dart';
import '../../features/chat/models/chat_context_preview.dart';
import '../../features/chatbot/chatbot_screen.dart';
import '../../features/checkout/checkout_screen.dart';

import '../../features/cart/cart_screen.dart';
import '../../features/help/help_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/products/products_screen.dart';
import '../../features/product/product_detail_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/account_settings_screen.dart';
import '../../features/profile/delete_account_screen.dart';
import '../../features/review/reviews_screen.dart';
import '../../features/review/write_review_screen.dart';
import '../../features/shell/main_shell.dart';
import '../../features/stores/stores_screen.dart';
import '../../features/stores/store_detail_screen.dart';
import '../../features/notification/notifications_screen.dart';
import '../../features/workshop/workshop_screen.dart';

final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>();

/// Rute yang butuh sesi login. Tanpa sesi (logout / di-kick / token mati)
/// akses ke rute ini dialihkan ke /login.
const Set<String> _protectedRoutes = {
  '/profile',
  '/profile/edit',
  '/addresses',
  '/settings',
  '/hapus-akun',
  '/cart',
  '/checkout',
  '/checkout/payment',
  '/payment',
  '/notifications',
  '/messages',
  '/chat-room',
  '/review/write',
};

/// Membungkus setiap layar dengan pendengar [AppSettings]: saat tema/bahasa
/// diganti, layar dibangun ulang dengan instance BARU sehingga seluruh token
/// warna (AppColors) ikut terbaca ulang — tanpa hot reload dan tanpa kehilangan
/// state navigasi (cabang shell bertahan lewat GlobalKey go_router).
///
/// Setiap re-render diberi animasi fade-in singkat agar perpindahan tema
/// terasa halus, bukan "melompat".
Widget _live(Widget Function() build) => _LiveScreen(build: build);

class _LiveScreen extends StatefulWidget {
  const _LiveScreen({required this.build});

  final Widget Function() build;

  @override
  State<_LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<_LiveScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
    value: 1,
  );

  AppThemeMode? _lastThemeMode;
  String? _lastLocale;

  @override
  void initState() {
    super.initState();
    _lastThemeMode = AppSettings.instance.themeMode;
    _lastLocale = AppSettings.instance.locale;
    AppSettings.instance.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    AppSettings.instance.removeListener(_onSettingsChanged);
    _fade.dispose();
    super.dispose();
  }

  void _onSettingsChanged() {
    final currentTheme = AppSettings.instance.themeMode;
    final currentLocale = AppSettings.instance.locale;
    // Hanya picu animasi re-render fade jika tema atau bahasa benar-benar berubah.
    // Hal ini mencegah visual glitch/flicker saat background task (seperti sinkronisasi cache/device) berjalan.
    if (_lastThemeMode != currentTheme || _lastLocale != currentLocale) {
      _lastThemeMode = currentTheme;
      _lastLocale = currentLocale;
      if (mounted) {
        setState(() {});
        // Fade-in dari 25% agar teks tidak menghilang total saat transisi.
        _fade.forward(from: 0.25);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _fade, curve: Curves.easeOut),
      child: widget.build(),
    );
  }
}

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: '/',
  refreshListenable: AuthSession.instance,
  redirect: (context, state) {
    final loggedIn = AuthSession.isLoggedIn;
    final loc = state.matchedLocation;

    // Sudah login → saat pertama kali membuka aplikasi (cold-start), tampilkan
    // layar logo statis singkat seperti Instagram sebelum masuk ke Beranda.
    if (loggedIn && loc == '/') {
      if (!AppLaunchSplashScreen.hasShownInitialSplash &&
          !FcmService.instance.hasPendingInitialRoute) {
        return '/launch';
      }
      AppLaunchSplashScreen.hasShownInitialSplash = true;
      return '/home';
    }
    if (loggedIn && loc == '/login') {
      return '/home';
    }
    if (!loggedIn && loc == '/launch') {
      return '/';
    }
    // Sesi hilang (logout / di-kick / token kedaluwarsa) → rute privat
    // dialihkan ke login; rute publik (katalog) tetap bisa dijelajahi tamu.
    if (!loggedIn && _protectedRoutes.contains(loc)) {
      return '/login';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => _live(OnboardingScreen.new),
    ),
    GoRoute(
      path: '/launch',
      builder: (context, state) => const AppLaunchSplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return _live(
          () => LoginScreen(
            initialEmail: extra?['initialEmail'] as String?,
          ),
        );
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return _live(
          () => RegisterScreen(
            initialEmail: extra?['googleEmail'] as String?,
            initialName: extra?['googleName'] as String?,
            initialGoogleId: extra?['googleId'] as String?,
            initialAvatarUrl: extra?['avatarUrl'] as String?,
            initialIdToken: extra?['idToken'] as String?,
            isGoogleAuth: extra?['isGoogleAuth'] as bool? ?? false,
          ),
        );
      },
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => _live(ForgotPasswordScreen.new),
    ),
    GoRoute(
      path: '/new-password',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final email = state.uri.queryParameters['email'] ?? extra?['email'] as String?;
        final otp = state.uri.queryParameters['otp'] ?? extra?['otp'] as String?;
        return _live(() => NewPasswordScreen(email: email, otp: otp));
      },
    ),
    GoRoute(
      path: '/verify-otp',
      builder: (context, state) {
        final from = state.uri.queryParameters['from'] ?? 'register';
        final email = state.uri.queryParameters['email'];
        final code = state.uri.queryParameters['code'];
        final extra = state.extra as Map<String, dynamic>?;
        return _live(
          () => OtpScreen(
            from: from,
            email: email ?? extra?['email'] as String?,
            expectedCode: code ?? extra?['expectedCode'] as String?,
            registrationData: extra?['registrationData'] as Map<String, dynamic>?,
          ),
        );
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _live(() => MainShell(navigationShell: navigationShell));
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => _live(HomeScreen.new),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/products',
              builder: (context, state) {
                final category =
                    state.uri.queryParameters['category'] ?? 'Semua';
                return _live(() => ProductsScreen(initialCategory: category));
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/stores',
              builder: (context, state) => _live(StoresScreen.new),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/workshop',
              builder: (context, state) => _live(WorkshopScreen.new),
            ),
          ],
        ),
        // ← Tab ke-5: Profil (sebelumnya Bantuan)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => _live(
                () => ProfileScreen(
                  initialTab: state.uri.queryParameters['tab'],
                  initialTrackOrderId:
                      state.uri.queryParameters['trackOrderId'] ??
                      state.uri.queryParameters['orderId'],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/help',
      builder: (context, state) => _live(HelpScreen.new),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) {
        final items = state.extra is List<CartItem>
            ? state.extra as List<CartItem>
            : (state.extra is CartItem ? [state.extra as CartItem] : null);
        return _live(() => CheckoutScreen(directBuyItems: items));
      },
    ),
    GoRoute(
      path: '/checkout/payment',
      builder: (context, state) {
        final args = state.extra is PaymentArgs
            ? state.extra as PaymentArgs
            : null;
        return _live(() => PaymentScreen(args: args));
      },
    ),
    GoRoute(
      path: '/payment',
      builder: (context, state) {
        final args = state.extra is PaymentArgs
            ? state.extra as PaymentArgs
            : null;
        return _live(() => PaymentScreen(args: args));
      },
    ),

    GoRoute(path: '/cart', builder: (context, state) => _live(CartScreen.new)),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return _live(() => ProductDetailScreen(productId: id));
      },
    ),
    GoRoute(
      path: '/produk/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return _live(() => ProductDetailScreen(productId: id));
      },
    ),
    GoRoute(
      path: '/store/:index',
      builder: (context, state) {
        final raw = state.pathParameters['index'] ?? '0';
        final index = int.tryParse(raw) ?? 0;
        return _live(
          () => StoreDetailScreen(storeIndex: index, storeKey: raw),
        );
      },
    ),
    GoRoute(
      path: '/toko/:index',
      builder: (context, state) {
        final raw = state.pathParameters['index'] ?? '0';
        final index = int.tryParse(raw) ?? 0;
        return _live(
          () => StoreDetailScreen(storeIndex: index, storeKey: raw),
        );
      },
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => _live(NotificationsScreen.new),
    ),
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => _live(
        () => AccountSettingsScreen(type: AccountScreenType.profile),
      ),
    ),
    GoRoute(
      path: '/addresses',
      builder: (context, state) => _live(
        () => AccountSettingsScreen(type: AccountScreenType.address),
      ),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => _live(
        () => AccountSettingsScreen(
          type: AccountScreenType.settings,
          initialOpenSection: state.uri.queryParameters['open'],
        ),
      ),
    ),
    GoRoute(
      path: '/chatbot',
      builder: (context, state) => _live(ChatbotScreen.new),
    ),
    GoRoute(
      path: '/messages',
      builder: (context, state) => _live(ChatListScreen.new),
    ),
    GoRoute(
      path: '/chat-room',
      builder: (context, state) {
        final storeName = state.uri.queryParameters['store'] ??
            'Dinoyo Ceramic Studio';
        final productId = state.uri.queryParameters['productId'];
        final targetUserId = state.uri.queryParameters['userId'];
        final isCs = state.uri.queryParameters['isCs'] == '1';
        final directConnect = state.uri.queryParameters['direct'] == '1';
        OrderChatPreview? orderPreview;
        final extra = state.extra;
        if (extra is OrderChatPreview) {
          orderPreview = extra;
        } else if (extra is Map) {
          final raw = extra['orderPreview'];
          if (raw is OrderChatPreview) {
            orderPreview = raw;
          } else if (raw is Map<String, dynamic>) {
            orderPreview = OrderChatPreview.fromJson(raw);
          }
        }
        return _live(() => ChatRoomScreen(
              storeName: storeName,
              productId: productId,
              targetUserId: targetUserId,
              initialOrderPreview: orderPreview,
              isCustomerService: isCs,
              initialDirectConnect: directConnect,
            ));
      },
    ),
    GoRoute(
      path: '/reviews',
      builder: (context, state) {
        final storeName = state.uri.queryParameters['store'] ??
            'Dinoyo Ceramic Studio';
        final productId = state.uri.queryParameters['productId'];
        final mitraId =
            int.tryParse(state.uri.queryParameters['mitraId'] ?? '');
        return _live(() => ReviewsScreen(
              storeName: storeName,
              productId: productId,
              mitraId: mitraId,
            ));
      },
    ),
    GoRoute(
      path: '/review/write',
      builder: (context, state) {
        final extra = state.extra is Map
            ? Map<String, dynamic>.from(state.extra as Map)
            : const <String, dynamic>{};
        return _live(() => WriteReviewScreen(
              orderId: extra['orderId']?.toString() ?? '#DNC-001',
              productId: extra['productId'] is int
                  ? extra['productId'] as int
                  : int.tryParse('${extra['productId'] ?? ''}'),
              orderItemId: extra['orderItemId'] is int
                  ? extra['orderItemId'] as int
                  : int.tryParse('${extra['orderItemId'] ?? ''}'),
              productName:
                  extra['productName']?.toString() ?? 'Vas Keramik Minimalis',
              variant: extra['variant']?.toString() ?? 'Varian Standar',
              studioName: extra['studioName']?.toString() ??
                  'Dinoyo Ceramic Studio',
              productImage: extra['productImage']?.toString() ??
                  'assets/images/product_vas.png',
              receivedDate:
                  extra['receivedDate']?.toString() ?? 'Pesanan Selesai',
            ));
      },
    ),
    GoRoute(
      path: '/hapus-akun',
      builder: (context, state) => _live(DeleteAccountScreen.new),
    ),
  ],
);
