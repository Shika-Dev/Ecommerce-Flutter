import 'package:ecom_web_flutter/main.dart';
import 'package:ecom_web_flutter/pages/account_page.dart';
import 'package:ecom_web_flutter/pages/cart_page.dart';
import 'package:ecom_web_flutter/pages/detail_shop_page.dart';
import 'package:ecom_web_flutter/pages/shop_page.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final routerConfig = GoRouter(
  routes: [
    GoRoute(
      path: '/detail-product/:id',
      builder: (context, state) => DetailProductPage(
        id: state.pathParameters['id'],
      ),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/account',
      builder: (context, state) => AccountPage(),
    ),
    GoRoute(
      path: '/shop',
      builder: (context, state) => ShopPage(
        category: state.uri.queryParameters['category'] ?? '',
        keyword: state.uri.queryParameters['keyword'],
      ),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => CartPage(),
    ),
  ],
);
