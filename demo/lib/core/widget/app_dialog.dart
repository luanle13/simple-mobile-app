import 'package:demo/core/ui/color.dart';
import 'package:demo/core/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract interface class _IAppDialog<T> {
  Future<T?> show();
}

sealed class _AppDialog {
  final BuildContext context;

  const _AppDialog(this.context);
}

final class MessageDialog<T> extends _AppDialog implements _IAppDialog<T> {
  final String title;
  final String content;

  const MessageDialog(super.context, {this.title = '', this.content = ''});

  @override
  Future<T?> show() async {
    final result = await showAdaptiveDialog<T>(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.text,
                  fontWeight: FontWeight.w600)),
          content: Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.text,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      },
    );
    return result;
  }
}

final class SingleFieldDialog extends _AppDialog
    implements _IAppDialog<String> {
  final String title;
  final String hint;
  final bool multiline;
  final String? initialText;
  final TextInputType inputType;

  const SingleFieldDialog(super.context,
      {required this.title,
      this.initialText,
      this.hint = '',
      this.inputType = TextInputType.text,
      this.multiline = false});

  @override
  Future<String?> show() async {
    final controller = TextEditingController(text: initialText);
    final result = await showAdaptiveDialog<String>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.all(20),
          titleTextStyle: const TextStyle(
            fontSize: 18,
            color: AppColors.text,
            fontWeight: FontWeight.w600,
          ),
          alignment: Alignment.center,
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          content: TextField(
            controller: controller,
            onSubmitted: (value) => context.pop(value),
            decoration: InputDecoration(
              hintText: hint,
            ),
            keyboardType: inputType,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.text,
              fontWeight: FontWeight.w400,
            ),
            minLines: multiline ? 5 : 1,
            maxLines: multiline ? 5 : 1,
          ),
          actionsOverflowButtonSpacing: 10,
          actions: [
            AppButton(
              onTap: () {
                context.pop(controller.text);
              },
              color: AppColors.green,
              label: 'OK',
            ),
            AppButton(
              onTap: () {
                context.pop(null);
              },
              label: 'Cancel',
            ),
          ],
        );
      },
    );

    return result;
  }
}
final class ChangePasswordFieldDialog extends _AppDialog
    implements _IAppDialog<(String, String)> {
  final String title;
  final String hint;
  final bool multiline;
  final String? initialText;
  final TextInputType inputType;

  const ChangePasswordFieldDialog(super.context,
      {required this.title,
        this.initialText,
        this.hint = '',
        this.inputType = TextInputType.text,
        this.multiline = false});

  @override
  Future<(String, String)?> show() async {
    final curPasswordController = TextEditingController(text: initialText);
    final newPasswordController = TextEditingController(text: initialText);
    final isCurObscure = ValueNotifier<bool>(true);
    final isNewObscure = ValueNotifier<bool>(true);
    final result = await showAdaptiveDialog<(String, String)>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.all(20),
          titleTextStyle: const TextStyle(
            fontSize: 18,
            color: AppColors.text,
            fontWeight: FontWeight.w600,
          ),
          alignment: Alignment.center,
          title: const Text(
            'Change Password',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: isCurObscure,
                builder: (context, value, child) => TextField(
                  obscureText: value,
                  controller: curPasswordController,
                  // onSubmitted: (value) => context.pop(value),
                  decoration: InputDecoration(
                    hintText: 'Current Password',
                    suffixIcon: IconButton(
                      icon: Icon(isCurObscure.value? Icons.visibility_off : Icons.visibility),
                      onPressed: () => isCurObscure.value = !value,
                    )
                  ),
                  keyboardType: inputType,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.text,
                    fontWeight: FontWeight.w400,
                  ),
                  minLines: multiline ? 5 : 1,
                  maxLines: multiline ? 5 : 1,
                ),
              ),
              SizedBox(height: 10,),
              ValueListenableBuilder<bool>(
                valueListenable: isNewObscure,
                builder: (context, value, child) => TextField(
                  controller: newPasswordController,
                  obscureText: value,
                  // onSubmitted: (value) => context.pop(value),
                  decoration: InputDecoration(
                    hintText: 'New Password',
                    suffixIcon: IconButton(
                      icon: Icon(isNewObscure.value? Icons.visibility_off : Icons.visibility),
                      onPressed: () => isNewObscure.value = !value,
                    )
                  ),
                  keyboardType: inputType,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.text,
                    fontWeight: FontWeight.w400,
                  ),
                  minLines: multiline ? 5 : 1,
                  maxLines: multiline ? 5 : 1,
                ),
              ),
            ],
          ),
          actionsOverflowButtonSpacing: 10,
          actions: [
            AppButton(
              onTap: () {
                context.pop((curPasswordController.text, newPasswordController.text));
              },
              color: AppColors.green,
              label: 'OK',
            ),
            AppButton(
              onTap: () {
                context.pop(null);
              },
              label: 'Cancel',
            ),
          ],
        );
      },
    );

    return result;
  }
}
final class DropdownSheet<T> extends _AppDialog implements _IAppDialog<T> {
  DropdownSheet(
    super.context, {
    this.titleBuilder,
    this.excludedItem,
    required this.items,
    this.initial,
  });

  final List<T> items;
  final T? initial;

  ///Exclude item in items
  final T? excludedItem;
  final Widget Function(T value)? titleBuilder;

  @override
  Future<T?> show() async {
    final items = this
        .items
        .toList()
        .where((element) => element != excludedItem)
        .toList();
    final result = await showModalBottomSheet<T>(
      context: context,
      enableDrag: true,
      backgroundColor: AppColors.white,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(),
      builder: (ctx) {
        return Wrap(
          children: [Column(
            children: [
              for (final item in items)
                ListTile(
                  onTap: () => ctx.pop(item),
                  selected: initial == item,
                  selectedTileColor: AppColors.green,
                  title: titleBuilder?.call(item) ?? Text(item.toString()),
                ),
              const SizedBox(height: 40,)
            ],
          ),]
        );
      },
    );
    return result;
  }
}
