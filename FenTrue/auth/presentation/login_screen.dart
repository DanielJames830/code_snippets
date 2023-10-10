import 'package:fentrue23/features/auth/presentation/forgot_password_screen.dart';

import 'package:fentrue23/features/auth/presentation/signup_screen.dart';
import 'package:fentrue23/features/auth/presentation/signupflow/organization_flow_screen.dart';
import 'package:fentrue23/features/organizations/data/organization_entity.dart';
import 'package:fentrue23/features/organizations/presentation/organizations_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../constants/spacers.dart';
import '../../organizations/data/organization_controller.dart';
import '../data/user_entity.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final smartFormController = useMemoized(() => SmartFormController());

    return StyledPage(
      body: Center(
        child: SmartForm(
          controller: smartFormController,
          child: ScrollColumn.withScrollbar(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 500.0,
                height: 250.0,
                child: Image.asset(
                  'assets/images/fentrue_colored.png',
                ),
              ),
              Spacers.h25,
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
              Row(
                children: [
                  const StyledSmartBoolField(
                      name: 'savePassword',
                      label: StyledBodyText(
                        'Save Password?',
                      )),
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StyledContainer(
                      onTapped: () {
                        context.style().navigateTo(
                            context: context,
                            page: (_) => const ForgotPasswordScreen());
                      },
                      child: const StyledBodyText(
                        'Forgot Password?',
                        textOverrides: StyledTextOverrides(),
                      ),
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
                    text: 'Sign In',
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    onTapped: () async {
                      final result = await smartFormController.validate();

                      if (!result.isValid) {
                        return;
                      }

                      final data = result.valueByName!;

                      String email = data['email'];
                      String password = data['password'];

                      if (data['savePassword']) {
                        await promptPasswordSave(data, context);
                      }

                      try {
                        await AppContext.global
                            .locate<AuthService>()
                            .login(email: email, password: password);

                        final loggedInUserId = await locate<AuthService>()
                            .getCurrentlyLoggedInUserId();

                        OrganizationController.loggedInUserEntity =
                            await Query.getById<UserEntity>(
                                    loggedInUserId ?? "")
                                .get();

                        final userOrganizations =
                            await OrganizationEntity.getOrganizationsByUserId(
                                    loggedInUserId!)
                                .all()
                                .get();

                        final newPage = userOrganizations.isEmpty
                            ? OrganizationSetUpScreen()
                            : OrganizationsScreen();

                        context.style().navigateReplacement(
                              context: context,
                              newPage: (_) => newPage,
                            );
                      } on LoginFailure catch (error) {
                        final emailError = getEmailError(error);
                        smartFormController.setError(
                            name: 'email', error: emailError);

                        final passwordError = getPasswordError(error);
                        smartFormController.setError(
                            name: 'password', error: passwordError);
                        return;
                      }
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const StyledBodyText(
                    "Don't have an account?",
                  ),
                  StyledContainer(
                    onTapped: () {
                      context.style().navigateReplacement(
                          context: context,
                          newPage: (_) => const SignupScreen());
                    },
                    child: const StyledBodyText(
                      'Sign Up!',
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

  String? getEmailError(LoginFailure loginFailure) {
    return loginFailure.when(
      invalidEmail: () => 'Invalid Email!',
      userDisabled: () =>
          'This account has been disabled. Reach out to support if you believe this was a mistake.',
      userNotFound: () =>
          'Cannot find account with this email and password. Double-check you didn\'t add a typo.',
      wrongPassword: () =>
          'Cannot find account with this email and password. Double-check you didn\'t add a typo.',
    );
  }

  String? getPasswordError(LoginFailure loginFailure) {
    return null;
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
}
