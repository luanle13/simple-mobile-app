import 'package:demo/core/ui/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppBackButton extends ConsumerWidget {
  const AppBackButton({super.key, this.label = 'Back', this.color = AppColors.text});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context,ref) {

    if (!GoRouter.of(context).canPop()) return const SizedBox.shrink();
    return TextButton.icon(
        onPressed: () {
          context.pop();
          // notifier.init();
        },
        icon: Icon(
          Icons.arrow_back_outlined,
          color: color,
        ),
        label: Text(
          label,
          style:  TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ));
  }
}
