import 'package:fentrue23/features/auth/data/user_factory.dart';
import 'package:fentrue23/features/auth/presentation/signupflow/organization_flow_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import '../../../constants/spacers.dart';
import 'login_screen.dart';

class SignupScreen extends HookWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // controller for our form
    final smartFormController = useMemoized(() => SmartFormController());

    return StyledPage(
      body: Center(
        child: SmartForm(
          controller: smartFormController,
          child: ScrollColumn.withScrollbar(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 300.0,
                height: 250.0,
                child: Image.asset(
                  'assets/images/fentrue_colored.png',
                ),
              ),
              Spacers.h15,
              StyledSmartTextField(
                name: 'email',
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validators: [
                  Validation.required(),
                  Validation.isEmail(),
                ],
              ),
              StyledSmartTextField(
                name: 'password',
                labelText: 'Password',
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                validators: [
                  Validation.required(),
                  Validation.isPassword(),
                ],
              ),
              StyledSmartTextField(
                name: 'passwordCheck',
                labelText: 'Re-enter password',
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                validators: [
                  Validation.required(),
                  Validation.isPassword(),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: StyledSmartTextField(
                      name: 'firstName',
                      labelText: 'First Name',
                      validators: [Validation.required()],
                    ),
                  ),
                  Expanded(
                    child: StyledSmartTextField(
                      name: 'lastName',
                      labelText: 'Last Name',
                      validators: [Validation.required()],
                    ),
                  ),
                ],
              ),
              Row(
                children: const [
                  StyledSmartBoolField(
                    name: 'savePassword',
                    label: StyledBodyText(
                      'Save Password?',
                    ),
                  ),
                ],
              ),
              Spacers.h15,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: StyledButton.high(
                    text: 'Sign Up',
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    onTapped: () async {
                      final result = await smartFormController.validate();

                      if (!result.isValid) return;

                      final data = result.valueByName!;

                      try {
                        await UserFactory().createNewEntity(data: data);
                        if (data['savePassword']) {
                          await promptPasswordSave(data, context);
                        }

                        context.style().navigateReplacement(
                              context: context,
                              newPage: (_) => OrganizationSetUpScreen(),
                            );
                      } on SignupFailure catch (error) {
                        final emailError = getEmailError(error);
                        smartFormController.setError(
                            name: 'email', error: emailError);

                        final passwordError = getPasswordError(error);
                        smartFormController.setError(
                            name: 'password', error: passwordError);

                        if (error == const SignupFailure.other()) {
                          smartFormController.setError(
                              name: 'passwordCheck', error: passwordError);
                        }

                        return;
                      }
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const StyledBodyText("Already a member?"),
                  StyledContainer(
                    onTapped: () {
                      context.style().navigateReplacement(
                          context: context,
                          newPage: (_) => const LoginScreen());
                    },
                    child: const StyledBodyText(
                      'Sign In!',
                      textOverrides: StyledTextOverrides(),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

String? getEmailError(SignupFailure signupFailure) {
  return signupFailure.when(
    invalidEmail: () => 'Invalid email!',
    emailAlreadyUsed: () => 'This email is already associated with an account!',
    weakPassword: () => null,
    other: () => 'Unknown error. Try again later.',
  );
}

String? getPasswordError(SignupFailure signupFailure) {
  return signupFailure.maybeWhen(
    weakPassword: () => 'Weak password!',
    other: () => 'Passwords do not match!',
    orElse: () => null,
  );
}

Future<void> promptPasswordSave(
    Map<String, dynamic> data, BuildContext context) async {
  const storage = FlutterSecureStorage();

  if (data['savePassword']) {
    final confirm = await StyledDialog.yesNo(
      context: context,
      confirmText: 'Save Password',
      cancelText: 'Not now',
      titleText: 'Save Password?',
      children: [
        Column(
          children: [
            StyledBodyText(
              'Would you like to save the password for ${data['email']} to your device?',
              textOverrides:
                  const StyledTextOverrides(textAlign: TextAlign.center),
            ),
            const StyledBodyText(
              'You can view saved password in your device settings',
              textOverrides: StyledTextOverrides(textAlign: TextAlign.center),
            ),
          ],
        ),
      ],
    ).show(context);

    if (confirm!) {
      await storage.write(key: data['email'], value: data['password']);
    }
  }
}
