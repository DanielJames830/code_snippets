import 'package:fentrue23/constants/spacers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class ForgotPasswordScreen extends HookWidget {
  final String? initialEmail;

  const ForgotPasswordScreen({super.key, this.initialEmail});

  @override
  Widget build(BuildContext context) {
    final smartFormController = useMemoized(() => SmartFormController());

    return StyledPage(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SmartForm(
          controller: smartFormController,
          child: ScrollColumn.withScrollbar(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StyledSubtitleText(
                'Reset Password',
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: StyledBodyText(
                    "Enter the email associated with your account\nand we'll send an email with instructions to\nreset your password."),
              ),
              Spacers.h25,
              StyledSmartTextField(
                name: 'email',
                initialValue: initialEmail,
                labelText: 'Recovery Email',
                keyboardType: TextInputType.emailAddress,
                validators: [
                  Validation.required(),
                  Validation.isEmail(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: StyledButton.high(
                    text: "Send Instructions",
                    onTapped: () async {
                      final reset = await smartFormController.validate();

                      if (!reset.isValid) {
                        return;
                      }

                      final data = reset.valueByName!;

                      final email = data['email'];
                      final passwordResettable =
                          locate<AuthService>() as PasswordResettable;
                      await guardAsync(
                          () => passwordResettable.onResetPassword(email));

                      // ignore: use_build_context_synchronously
                      context.style().navigateReplacement(
                          context: context,
                          newPage: (_) => PasswordEmailSentScreen());
                    },
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

class PasswordEmailSentScreen extends HookWidget {
  const PasswordEmailSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black,
            Color(0xff231f20),
            Color(0xff231f20),
          ],
        ),
      ),
      child: StyledPage(
        backgroundColor: Colors.transparent,
        body: Center(
          child: ScrollColumn.withScrollbar(
            children: [
              const StyledBodyText(
                  "We sent a password recovery email\nto your inbox."),
              Spacers.h50,
              StyledButton.high(
                text: 'Return to Sign In screen',
                onTapped: () {
                  context.style().navigateBack(context: context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
