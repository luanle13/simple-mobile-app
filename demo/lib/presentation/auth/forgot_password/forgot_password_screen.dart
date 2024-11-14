import 'package:demo/core/service/app_toast.dart';
import 'package:demo/core/widget/app_back_button.dart';
import 'package:demo/presentation/auth/forgot_password/forgot_password_provider.dart';
import 'package:demo/presentation/auth/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../core/service/utils.dart';
import '../../../core/ui/color.dart';
import '../../../core/widget/app_button.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  static const String routeName= 'forgot-password';
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formGroup = FormGroup({
    'email': FormControl<String>(validators: [
      Validators.email,
      Validators.required,
    ]),
    'username': FormControl<String>(validators: [
      Validators.required,
    ]),
    'fullName': FormControl<String>(validators: [
      Validators.required,
    ]),
  });

  @override
  Widget build(BuildContext context) {
    final curPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final isCurObscure = ValueNotifier<bool>(true);
    final isNewObscure = ValueNotifier<bool>(true);
    final state = ref.watch(forgotPasswordProvider);
    final notifier = ref.read(forgotPasswordProvider.notifier);
    ref.listen(forgotPasswordProvider, (previous, next) async {
      if (next.error != null) {
        AppToast.showError(context, message: next.error!);
        return;
      }

      if (next.success == true) {
        AppToast.showMessage(context, message: 'Create success! you can login now');
        context.pop();
      }
    });
    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: const AppBackButton(color: AppColors.white),
          leadingWidth: 100,
        ),
        backgroundColor: AppColors.green,
        body: ReactiveForm(
          formGroup: _formGroup,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 100, bottom: 50),
                alignment: Alignment.center,
                child: const Text(
                  'DEMO APP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height - 150,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 37),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox.square(dimension: 83),
                        const Text(
                          'Create a new account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        ReactiveTextField<String>(
                          formControlName: 'fullName',
                          decoration: const InputDecoration(hintText: 'Full Name'),
                        ),
                        const SizedBox(height: 22),
                        ReactiveTextField<String>(
                          formControlName: 'username',
                          decoration: const InputDecoration(hintText: 'User Name'),
                        ),
                        const SizedBox(height: 22),
                        ReactiveTextField<String>(
                          formControlName: 'email',
                          decoration: const InputDecoration(hintText: 'Email Address'),
                        ),
                        const SizedBox(height: 22),
                        ValueListenableBuilder<bool>(
                          valueListenable: isCurObscure,
                          builder: (context, value, child) => TextField(
                            obscureText: value,
                            controller: curPasswordController,
                            // onSubmitted: (value) => context.pop(value),
                            decoration: InputDecoration(
                                hintText: 'Enter Password',
                                suffixIcon: IconButton(
                                  icon: Icon(isCurObscure.value? Icons.visibility_off : Icons.visibility),
                                  onPressed: () => isCurObscure.value = !value,
                                )
                            ),
                            // keyboardType: inputType,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.text,
                              fontWeight: FontWeight.w400,
                            ),
                            minLines: 1,
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(height: 22,),
                        ValueListenableBuilder<bool>(
                          valueListenable: isNewObscure,
                          builder: (context, value, child) => TextField(
                            controller: newPasswordController,
                            obscureText: value,
                            // onSubmitted: (value) => context.pop(value),
                            decoration: InputDecoration(
                                hintText: 'Confirm Password',
                                suffixIcon: IconButton(
                                  icon: Icon(isNewObscure.value? Icons.visibility_off : Icons.visibility),
                                  onPressed: () => isNewObscure.value = !value,
                                )
                            ),
                            // keyboardType: inputType,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.text,
                              fontWeight: FontWeight.w400,
                            ),
                            minLines: 1,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 22),
                        AppButton(
                          loading: state.submitting,
                          label: 'Send',
                          onTap: () {
                            notifier.forgotPassword(email: _formGroup.rawValue['email'] as String,
                                fullName: _formGroup.rawValue['fullName'] as String,
                                userName: _formGroup.rawValue['username'] as String,
                                password: newPasswordController.text);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
