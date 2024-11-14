import 'dart:async';
import 'dart:io';

import 'package:demo/core/di/dependency_injections.dart';
import 'package:demo/core/service/app_log.dart';
import 'package:demo/core/service/local_service.dart';
import 'package:demo/core/ui/strings.dart';
import 'package:demo/core/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'core/navigation/routes.dart';

void main() {
  runZonedGuarded(
        () async {
      WidgetsFlutterBinding.ensureInitialized();
      await setupLocator();

      runApp(const ProviderScope(child: MyApp()));
    },
        (error, stack) {
      AppLog.error(error);
      AppLog.error(stack);
    },
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ReactiveFormConfig(
      validationMessages: {
        ValidationMessage.required: (error) => 'This field must not be empty',
        ValidationMessage.email: (error) => 'Must enter a valid email',
        ValidationMessage.minLength: (error) =>
        'Must enter at least ${(error as Map)['requiredLength']} character long'
      },
      child: MaterialApp.router(
        routerConfig: routes,
        debugShowCheckedModeBanner: false,
        title: AppString.app_title,
        theme: AppTheme.main,
      ),
    );
  }
}
