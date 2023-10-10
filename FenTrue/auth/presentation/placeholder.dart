import 'package:fentrue23/constants/spacers.dart';
import 'package:fentrue23/features/auth/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class PlaceholderScreen extends HookWidget {
  final String userId;

  const PlaceholderScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StyledPage(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StyledBodyText(
            "You are currently logged in as:\n$userId",
            textOverrides: const StyledTextOverrides(
              textAlign: TextAlign.center,
            ),
          ),
          Spacers.h15,
          StyledButton.high(
              text: "Log Out",
              onTapped: () async {
                await locate<AuthService>().logout();
                context.style().navigateReplacement(
                    context: context, newPage: (_) => const LoginScreen());
              }),
        ],
      )),
    );
  }
}
