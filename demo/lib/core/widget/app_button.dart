import 'package:demo/core/ui/color.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final void Function() onTap;
  final String label;
  final Color color;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final Widget? prefix;
  final Widget? suffix;
  final Size? size;
  final bool loading;
  final bool disabled;

  const AppButton(
      {super.key,
      required this.onTap,
      required this.label,
      this.size,
      this.loading = false,
      this.disabled = false,
      this.prefix,
      this.suffix,
      this.margin,
      this.padding = const EdgeInsets.symmetric(vertical: 12),
      this.color = AppColors.defaultButtonColor});

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      padding: padding,
      fixedSize: size,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: loading || disabled ? AppColors.grey : color,
    );

    Widget child = Row(
      children: [
        SizedBox(width: 40, child: prefix),
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          width: 40,
          child: suffix,
        ),
      ],
    );
    if (loading) {
      child = const Center(child: CircularProgressIndicator.adaptive());
    }
    return Container(
      margin: margin,
      child: ElevatedButton(
          style: style,
          onPressed: loading || disabled ? null : onTap,
          child: child),
    );
  }
}
