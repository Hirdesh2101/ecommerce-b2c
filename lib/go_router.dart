import 'package:ecommerce_major_project/app_service.dart';
import 'package:ecommerce_major_project/features/account/screens/account_screen.dart';
import 'package:ecommerce_major_project/features/account/screens/all_orders_screen.dart';
import 'package:ecommerce_major_project/features/cart/screens/cart_screen.dart';
import 'package:ecommerce_major_project/features/category_grid/category_grid_screen.dart';
import 'package:ecommerce_major_project/features/checkout/screens/status_check.dart';
import 'package:ecommerce_major_project/features/home/screens/filters_screen.dart';
import 'package:ecommerce_major_project/features/home/screens/wish_list_screen.dart';
import 'package:ecommerce_major_project/features/order_details/screens/order_details_screen.dart';
import 'package:ecommerce_major_project/features/order_details/screens/return_details_screen.dart';
import 'package:ecommerce_major_project/features/profile/screens/profilescreen.dart';
import 'package:ecommerce_major_project/features/return_product/screens/return_product_screen.dart';
import 'package:ecommerce_major_project/features/return_product/screens/select_return_product.dart';
import 'package:ecommerce_major_project/features/search_delegate/my_search_screen.dart';
import 'package:ecommerce_major_project/features/splash/loading_splash.dart';
import 'package:ecommerce_major_project/features/splash/splash_screen.dart';
import 'package:ecommerce_major_project/models/returns.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_major_project/models/order.dart';
import 'package:ecommerce_major_project/common/widgets/bottom_bar.dart';
import 'package:ecommerce_major_project/features/home/screens/home_screen.dart';
import 'package:ecommerce_major_project/features/auth/screens/auth_screen.dart';
import 'package:ecommerce_major_project/features/search/screens/search_screen.dart';
import 'package:ecommerce_major_project/features/checkout/screens/checkout_screen.dart';
import 'package:ecommerce_major_project/features/home/screens/category_deals_screen.dart';
import 'package:ecommerce_major_project/features/product_details/screens/product_detail_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
class AppRouter {
  late final AppService appService;
  GoRouter get router => _goRouter;

  AppRouter(this.appService);

  late final GoRouter _goRouter = GoRouter(
    navigatorKey: _rootNavigatorKey,
    refreshListenable: appService,
    initialLocation: '/home',
    routes: [
      ShellRoute(
        // navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return BottomBar(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/home',
            // parentNavigatorKey: _shellNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              return const HomeScreen();
            },
          ),
          GoRoute(
            path: '/categories',
            // parentNavigatorKey: _shellNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              return const CategoryGridScreen();
            },
          ),
          GoRoute(
            path: '/cart',
            // parentNavigatorKey: _shellNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              return const CartScreen();
            },
          ),
          GoRoute(
            path: '/account',
            // parentNavigatorKey: _shellNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              return const AccountScreen();
            },
          ),
        ],
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const LoadingSplashScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/wishlist',
        builder: (context, state) => const WishListScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) => ProductDetailScreen(
          productId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/category/:category',
        builder: (context, state) => CategoryDealsScreen(
          category: state.pathParameters['category']!,
        ),
      ),
      GoRoute(
        path: '/filter',
        builder: (context, state) => const FilterScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) {
          final query = state.uri.queryParameters['query'];
          if (query != null) {
            return SearchScreen(searchQuery: query);
          } else {
            return const MySearchScreen();
          }
        },
      ),
      GoRoute(
          path: '/checkout',
          builder: (context, state) {
            var extras = state.extra! as List;
            var totalAmount = extras[0];
            var cart = extras[1];
            var userProviderCart = extras[2];
            return CheckoutScreen(
              totalAmount: totalAmount,
              mycart: cart,
              userProviderCart: userProviderCart,
            );
          }),
      GoRoute(
        path: '/status/:orderid',
        builder: (context, state) => CheckStatus(
          orderId: state.pathParameters['orderid']!,
        ),
      ),
      GoRoute(
          path: '/orders',
          builder: (context, state) {
            var extras = state.extra as Order?;
            if (extras != null) {
              return OrderDetailsScreen(order: extras);
            } else {
              return const AllOrdersScreen();
            }
          }),
      GoRoute(
          path: '/returns',
          builder: (context, state) {
            var extras = state.extra! as Return;
            return ReturnDetailsScreen(returns: extras);
          }),
      GoRoute(
          path: '/newreturn',
          builder: (context, state) {
            var extras = state.extra! as List;
            var order = extras[0];
            var products = extras[1];
            return ReturnProductScreen(order: order, selectedProduct: products);
          }),
      GoRoute(
          path: '/newreturn/select',
          builder: (context, state) {
            var extras = state.extra! as List;
            var copy = extras[0];
            var order = extras[1];
            return SelectReturnProduct(copy: copy, order: order);
          }),
    ],
    //errorBuilder: (context, state) => ErrorPage(error: state.error.toString()),
    redirect: (context, state) {
      
      final isLogedIn = appService.loginState;
      final isInitialized = appService.initialized;
      final isOnboarded = appService.onboarding;

      final isGoingToLogin = state.uri.toString() == '/auth';
      final isGoingToInit = state.uri.toString() == '/splash';
      final isGoingToOnboard = state.uri.toString() == '/onboarding';

      // If not Initialized and not going to Initialized redirect to Splash
      if (!isInitialized && !isGoingToInit) {
        return '/splash';
        // If not onboard and not going to onboard redirect to OnBoarding
      } else if (isInitialized && !isOnboarded && !isGoingToOnboard) {
        return '/onboarding';
        // If not logedin and not going to login redirect to Login
      } else if (isInitialized &&
          isOnboarded &&
          !isLogedIn &&
          !isGoingToLogin) {
        return '/auth';
        // If all the scenarios are cleared but still going to any of that screen redirect to Home
      } else if ((isLogedIn && isGoingToLogin) ||
          (isInitialized && isGoingToInit) ||
          (isOnboarded && isGoingToOnboard)) {
        return '/home';
      } else {
        // Else Don't do anything
        return null;
      }
    },
  );
}
