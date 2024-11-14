import 'package:demo/core/di/dependency_injections.dart';
import 'package:demo/core/service/app_toast.dart';
import 'package:demo/core/service/local_service.dart';
import 'package:demo/core/service/utils.dart';
import 'package:demo/core/ui/color.dart';
import 'package:demo/core/widget/app_button.dart';
import 'package:demo/domain/model/user.dart';
import 'package:demo/presentation/auth/forgot_password/forgot_password_screen.dart';
import 'package:demo/presentation/auth/sign_in/sign_in_provider.dart';
import 'package:demo/presentation/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SignInScreen extends ConsumerStatefulWidget {
  static const String routeName = 'signin';

  const SignInScreen({super.key});

  @override
  ConsumerState createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final FormGroup _formGroup = FormGroup({
    'email': FormControl<String>(value: '', validators: [
      Validators.required,
    ]),
    'password': FormControl<String>(value: '', validators: [
      Validators.minLength(8),
      Validators.required,
    ])
  });

  @override
  void didChangeDependencies() {
    checkAuth();
    super.didChangeDependencies();
  }

  bool canMove = true;

  void checkAuth() async {
    final user = await User.fromLocal();
    final hasPin = locator<LocalService>().hasPin(user.email);
  }
  final isObscure = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(signInProvider.notifier);
    final state = ref.watch(signInProvider);
    ref.listen(signInProvider, (previous, next) async {
      if (next.error != null) {
        AppToast.showError(context, message: next.error!);
        return;
      }

      if (next.success == true) {
        context.goNamed(DashboardScreen.routeName);
      }
    });
    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
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
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 37),
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Sign In',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Use the registered username and password ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 64,
                        ),
                        ReactiveTextField<String>(
                          formControlName: 'email',
                          decoration: const InputDecoration(hintText: 'User Name'),
                        ),
                        const SizedBox(height: 26),
                        ValueListenableBuilder(
                          valueListenable: isObscure,
                          builder: (context, value, child) => ReactiveTextField<String>(
                            obscureText: value,
                            formControlName: 'password',
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(hintText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(isObscure.value? Icons.visibility_off : Icons.visibility),
                                onPressed: () => isObscure.value = !value,
                              ) ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        AppButton(
                          loading: state.submitting,
                          label: 'Login',
                          color: AppColors.green,
                          onTap: () {
                            unFocus(context);
                            if (_formGroup.invalid) {
                              return;
                            }
                            notifier.signIn(
                                email: _formGroup.rawValue['email'] as String,
                                password:
                                    _formGroup.rawValue['password'] as String);
                          },
                        ),
                        TextButton(
                            onPressed: () {
                              context.pushNamed(ForgotPasswordScreen.routeName);
                            },
                            child: const Text(
                              'Sign up',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ))
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
