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
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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

final routes = GoRouter(
  navigatorKey: _rootNavigatorKey,
  redirect: (context, state) {
    //TODO MAKE LISTEN FALSE
    final isLoading = Provider.of<UserProvider>(context).isLoading;
    final isLoggedIn = Provider.of<UserProvider>(context).user.token.isNotEmpty;
    if (isLoading) {
      return '/splash';
    } else {
      if (isLoggedIn) {
        if (state.uri.toString() == '/auth' ||
            state.uri.toString() == '/splash') {
          return '/home';
        } else {
          // User is already logged in and not on the auth screen
          return null; // or any other route if needed
        }
      } else {
        // User is not logged in
        return '/auth';
      }
    }
  },
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return BottomBar(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/home',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: '/categories',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (BuildContext context, GoRouterState state) {
            return const CategoryGridScreen();
          },
        ),
        GoRoute(
          path: '/cart',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (BuildContext context, GoRouterState state) {
            return const CartScreen();
          },
        ),
        GoRoute(
          path: '/account',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (BuildContext context, GoRouterState state) {
            return const AccountScreen();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/onboarding',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/splash',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LoadingSplashScreen(),
    ),
    GoRoute(
      path: '/auth',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/wishlist',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const WishListScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => ProductDetailScreen(
        productId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/category/:category',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => CategoryDealsScreen(
        category: state.pathParameters['category']!,
      ),
    ),
    GoRoute(
      path: '/filter',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const FilterScreen(),
    ),
    GoRoute(
      path: '/profile',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/search',
      parentNavigatorKey: _rootNavigatorKey,
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
        parentNavigatorKey: _rootNavigatorKey,
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
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => CheckStatus(
        orderId: state.pathParameters['orderid']!,
      ),
    ),
    GoRoute(
        path: '/orders',
        parentNavigatorKey: _rootNavigatorKey,
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
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          var extras = state.extra! as Return;
          return ReturnDetailsScreen(returns: extras);
        }),
    GoRoute(
        path: '/newreturn',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          var extras = state.extra! as List;
          var order = extras[0];
          var products = extras[1];
          return ReturnProductScreen(order: order, selectedProduct: products);
        }),
    GoRoute(
        path: '/newreturn/select',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          var extras = state.extra! as List;
          var copy = extras[0];
          var order = extras[1];
          return SelectReturnProduct(copy: copy, order: order);
        }),
  ],
);
