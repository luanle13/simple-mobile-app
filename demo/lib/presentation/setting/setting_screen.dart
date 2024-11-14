import 'package:demo/core/ui/color.dart';
import 'package:demo/core/widget/app_back_button.dart';
import 'package:demo/presentation/setting/my_account/my_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

import '../../core/di/dependency_injections.dart';
import '../../core/service/local_service.dart';
import '../auth/sign_in/sign_in_screen.dart';

class SettingScreen extends ConsumerStatefulWidget {
  static const String routeName = 'settings';

  const SettingScreen({super.key});

  @override
  ConsumerState createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 120,
        leading: const AppBackButton(
          label: 'Settings',
        ),
      ),
      body: Column(
        children: ListTile.divideTiles(
            context: context,
            color: AppColors.grey,
            tiles: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 38),
                onTap: () {
                  context.pushNamed(MyAccountScreen.routeName);
                },
                leading: const Text(
                  'My Account',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 16,
                  color: AppColors.text,
                ),
              ),
              ListTile(
                onTap: () async {
                    context.goNamed(SignInScreen.routeName);
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 38),
                leading: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 16,
                  color: AppColors.text,
                ),
              ),
            ]).toList(),
      ),
    );
  }
}
