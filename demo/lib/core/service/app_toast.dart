import 'package:demo/core/ui/color.dart';
import 'package:flutter/material.dart';

final class AppToast {
  static _messageSnack(String msg) => SnackBar(
        content:
            Text(msg, style: const TextStyle(color: AppColors.white, fontSize: 14)),
        behavior: SnackBarBehavior.fixed,
        backgroundColor: AppColors.green,
      );
  static _errorSnack(String msg) => SnackBar(
        content:
            Text(msg, style: const TextStyle(color: AppColors.white, fontSize: 14)),
        behavior: SnackBarBehavior.fixed,
        backgroundColor: AppColors.red,
      );

  static showMessage(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(_messageSnack(message));
  }
  static showError(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(_errorSnack(message));
  }
}
