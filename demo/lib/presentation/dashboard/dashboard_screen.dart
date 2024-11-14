import 'package:demo/core/di/dependency_injections.dart';
import 'package:demo/core/ui/color.dart';
import 'package:demo/data/repository/auth_repository.dart';
import 'package:demo/presentation/auth/sign_in/sign_in_screen.dart';
import 'package:demo/presentation/dashboard/widget/custom_header.dart';
import 'package:demo/presentation/setting/my_account/my_account_provider.dart';
import 'package:demo/presentation/setting/my_account/my_account_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  static const String routeName = 'dashboard';

  const DashboardScreen({super.key});

  @override
  ConsumerState createState() => _OnboardScreenState();
}

class _OnboardScreenState extends ConsumerState<DashboardScreen>
    with TickerProviderStateMixin {
  // @override
  // void initState() {
  //   checkToken().then((value) {
  //     if (!value) {
  //       _gotoSignIn();
  //     }
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(myAccountProvider.notifier);
    final state = ref.watch(myAccountProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              pinned: true,
              delegate: DashboardHeader(
                  vsync: this, email: state.user.username)),
          SliverList(
              delegate: SliverChildListDelegate.fixed(
            [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: Text('Hi ${state.user.fullName} - ${state.user.email}', style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),),
              )
            ],
          ))
        ],
      ),
    );
  }

  void _gotoSignIn() async {
    final pref = await SharedPreferences.getInstance();
    final user = await locator<AuthRepository>().getUser();
    await pref.remove(user.email);
    if (mounted) {
      context.goNamed(SignInScreen.routeName);
    }
  }

  // Future<bool> checkToken() async {
  //   final pref = await SharedPreferences.getInstance();
  //   if (pref.containsKey(PrefsConstants.access_token) &&
  //       pref.getString(PrefsConstants.access_token) != null) {
  //     final token = pref.getString(PrefsConstants.access_token)!;
  //     final checked = await locator<AuthRepository>().checkToken(token);
  //     return checked;
  //   }
  //   return false;
  // }
}
