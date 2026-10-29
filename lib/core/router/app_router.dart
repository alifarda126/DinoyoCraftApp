import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app_settings.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/new_password_screen.dart';
import '../../features/auth/onboarding_screen.dart';
import '../../features/auth/otp_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/chat/chat_list_screen.dart';
import '../../features/chat/chat_room_screen.dart';
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

  @override
  void initState() {
    super.initState();
    AppSettings.instance.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    AppSettings.instance.removeListener(_onSettingsChanged);
    _fade.dispose();
    super.dispose();
  }

  void _onSettingsChanged() {
    setState(() {});
    // Fade-in dari 25% agar teks tidak menghilang total saat transisi.
    _fade.forward(from: 0.25);
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
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => _live(OnboardingScreen.new),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => _live(LoginScreen.new),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => _live(RegisterScreen.new),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => _live(ForgotPasswordScreen.new),
    ),
    GoRoute(
      path: '/new-password',
      builder: (context, state) => _live(NewPasswordScreen.new),
    ),
    GoRoute(
      path: '/verify-otp',
      builder: (context, state) {
        final from = state.uri.queryParameters['from'] ?? 'register';
        final email = state.uri.queryParameters['email'];
        final code = state.uri.queryParameters['code'];
        return _live(
          () => OtpScreen(from: from, email: email, expectedCode: code),
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
              builder: (context, state) => _live(ProfileScreen.new),
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
    GoRoute(path: '/cart', builder: (context, state) => _live(CartScreen.new)),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return _live(() => ProductDetailScreen(productId: id));
      },
    ),
    GoRoute(
      path: '/store/:index',
      builder: (context, state) {
        final index =
            int.tryParse(state.pathParameters['index'] ?? '') ?? 0;
        return _live(() => StoreDetailScreen(storeIndex: index));
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
        () => AccountSettingsScreen(type: AccountScreenType.settings),
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
        return _live(() => ChatRoomScreen(
              storeName: storeName,
              productId: productId,
            ));
      },
    ),
    GoRoute(
      path: '/reviews',
      builder: (context, state) {
        final storeName = state.uri.queryParameters['store'] ??
            'Dinoyo Ceramic Studio';
        return _live(() => ReviewsScreen(storeName: storeName));
      },
    ),
    GoRoute(
      path: '/review/write',
      builder: (context, state) => _live(WriteReviewScreen.new),
    ),
    GoRoute(
      path: '/hapus-akun',
      builder: (context, state) => _live(DeleteAccountScreen.new),
    ),
  ],
);
