import 'package:demo/core/service/app_log.dart';
import 'package:demo/core/service/app_toast.dart';
import 'package:demo/core/ui/color.dart';
import 'package:demo/core/widget/app_back_button.dart';
import 'package:demo/core/widget/app_button.dart';
import 'package:demo/core/widget/app_dialog.dart';
import 'package:demo/presentation/setting/my_account/my_account_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

class MyAccountScreen extends ConsumerStatefulWidget {
  static const String routeName = 'my_account';

  const MyAccountScreen({super.key});

  @override
  ConsumerState createState() => _MyAccountScreenState();
}
final _formGroup = FormGroup({
  'email': FormControl<String>(validators: [
    Validators.email,
    Validators.required,
  ]),
  'fullName': FormControl<String>(validators: [
    Validators.required,
  ]),
});
class _MyAccountScreenState extends ConsumerState<MyAccountScreen> {
  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(myAccountProvider.notifier);
    final state = ref.watch(myAccountProvider);
    final isCurObscure = ValueNotifier<bool>(true);
    final curPasswordController = TextEditingController();
    ref.listen(myAccountProvider, (previous, next) {
      AppLog.print(next.isUpdating);
      if (next.err != null) {
        AppToast.showError(context, message: next.err!);
        return;
      }

      if (next.success == true) {
        AppToast.showMessage(context,
            message: 'You\'re account is updated successfully');
      }
    });
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 120,
        leading: const AppBackButton(),
      ),
      body: state.loading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: ReactiveForm(
                  formGroup: _formGroup,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'My Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 74),
                      const Text(
                        'Email Address',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 7),
                      ReactiveTextField<String>(
                        formControlName: 'email',
                        decoration: InputDecoration(hintText: state.user.email),
                      ),
                      const SizedBox(height: 35),
                      const Text(
                        'Full Name',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 7),
                      ReactiveTextField<String>(
                        formControlName: 'fullName',
                        decoration: InputDecoration(hintText: state.user.fullName),
                      ),
                      const SizedBox(height: 35),
                      const Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 7),
                      ValueListenableBuilder<bool>(
                        valueListenable: isCurObscure,
                        builder: (context, value, child) => TextField(
                          obscureText: value,
                          controller: curPasswordController,
                          decoration: InputDecoration(
                              hintText: '*************',
                              suffixIcon: IconButton(
                                icon: Icon(isCurObscure.value? Icons.visibility_off : Icons.visibility),
                                onPressed: () => isCurObscure.value = !value,
                              )
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.text,
                            fontWeight: FontWeight.w400,
                          ),
                          minLines: 1,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(height: 60),
                      AppButton(
                          loading: state.submitting,
                          color: const Color(0xff60d2ac),
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  (MediaQuery.of(context).size.width) * .45 / 2),
                          onTap: () {
                            notifier.submit(email: _formGroup.rawValue['email'] as String,
                                fullName: _formGroup.rawValue['fullName'] as String,
                                password: curPasswordController.text).then((value) => notifier.init());
                          },
                          label: 'SAVE')
                    ],
                  ),
                ),
              ),
          ),
    );
  }

  // String obfuscateEmail(String email) {
  //   if (email.isEmpty || !email.contains('@')) {
  //     return email; // Return the original email if it's empty or invalid
  //   }
  //
  //   List<String> parts = email.split('@');
  //   String username = parts[0];
  //   String domain = parts[1];
  //
  //   // Obfuscate part of the username
  //   String obfuscatedUsername = domain.replaceRange(0, domain.length, '*' * (username.length + 3));
  //   // Return the obfuscated email
  //   return '$username@$obfuscatedUsername';
  // }
}
