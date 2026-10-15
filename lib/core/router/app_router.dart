import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/login_screen.dart';
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

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/verify-otp',
      builder: (context, state) {
        final from = state.uri.queryParameters['from'] ?? 'register';
        return OtpScreen(from: from);
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
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
                return ProductsScreen(initialCategory: category);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/stores',
              builder: (context, state) => const StoresScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/workshop',
              builder: (context, state) => const WorkshopScreen(),
            ),
          ],
        ),
        // ← Tab ke-5: Profil (sebelumnya Bantuan)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/help',
      builder: (context, state) => const HelpScreen(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) =>
          ProductDetailScreen(productId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/store/:index',
      builder: (context, state) => StoreDetailScreen(
        storeIndex: int.tryParse(state.pathParameters['index'] ?? '') ?? 0,
      ),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) =>
          const AccountSettingsScreen(type: AccountScreenType.profile),
    ),
    GoRoute(
      path: '/addresses',
      builder: (context, state) =>
          const AccountSettingsScreen(type: AccountScreenType.address),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) =>
          const AccountSettingsScreen(type: AccountScreenType.settings),
    ),
    GoRoute(
      path: '/chatbot',
      builder: (context, state) => const ChatbotScreen(),
    ),
    GoRoute(
      path: '/messages',
      builder: (context, state) => const ChatListScreen(),
    ),
    GoRoute(
      path: '/chat-room',
      builder: (context, state) => ChatRoomScreen(
        storeName: state.uri.queryParameters['store'] ?? 'Dinoyo Ceramic Studio',
      ),
    ),
    GoRoute(
      path: '/reviews',
      builder: (context, state) => ReviewsScreen(
        storeName: state.uri.queryParameters['store'] ?? 'Dinoyo Ceramic Studio',
      ),
    ),
    GoRoute(
      path: '/review/write',
      builder: (context, state) => const WriteReviewScreen(),
    ),
    GoRoute(
      path: '/hapus-akun',
      builder: (context, state) => const DeleteAccountScreen(),
    ),
  ],
);
