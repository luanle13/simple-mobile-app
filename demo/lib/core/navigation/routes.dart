import 'package:demo/core/constants/app_constants.dart';
import 'package:demo/presentation/auth/forgot_password/forgot_password_screen.dart';
import 'package:demo/presentation/auth/sign_in/sign_in_screen.dart';
import 'package:demo/presentation/dashboard/dashboard_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/setting/my_account/my_account_screen.dart';
import '../../presentation/setting/setting_screen.dart';

final _appKey = GlobalKey<NavigatorState>();
final _mainKey = GlobalKey<NavigatorState>();
final routes = GoRouter(
    navigatorKey: _appKey,
    initialLocation: '/signin',
    redirect: (context, state) async {
    },
    routes: [
      GoRoute(
        path: '/signin',
        name: SignInScreen.routeName,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: ForgotPasswordScreen.routeName,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: DashboardScreen.routeName,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
          path: '/settings',
          name: SettingScreen.routeName,
          builder: (context, state) => const SettingScreen(),
          routes: [
            GoRoute(
              path: 'my_account',
              name: MyAccountScreen.routeName,
              builder: (context, state) => const MyAccountScreen(),
            ),
          ]),

    ]);
