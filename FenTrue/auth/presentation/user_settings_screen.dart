import 'package:fentrue23/features/auth/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import '../../../constants/spacers.dart';
import '../../../style.dart';
import '../../organizations/data/organization_controller.dart';

class UserSettings extends HookWidget {
  const UserSettings({super.key});

  @override
  Widget build(BuildContext context) {
    Future<bool?> confirm(String bodyText) {
      return StyledDialog.yesNo(
        context: context,
        confirmText: 'Yes',
        cancelText: 'Nevermind',
        titleText: 'Are you sure?',
        children: [
          Column(
            children: [
              StyledBodyText(
                bodyText,
                textOverrides:
                    const StyledTextOverrides(textAlign: TextAlign.center),
              ),
            ],
          ),
        ],
      ).show(context);
    }

    return StyledPage(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StyledIcon.high(
                size: 60,
                Icons.account_circle_outlined,
              ),
              Spacers.h15,
              StyledBodyText(
                "Profile",
                textOverrides: StyledTextOverrides(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Spacers.h15,
              StyledBodyText(
                "This is how you will appear when you join an organization.",
                textOverrides: StyledTextOverrides(),
              ),
              Spacers.h35,
              StyledDivider(),
              Spacers.h15,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppStyle.primaryColor,
                          ),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: FittedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Center(
                                  child: StyledSubtitleText(
                                    '${OrganizationController.loggedInUserEntity?.value.firstNameProperty.value?[0]}${OrganizationController.loggedInUserEntity?.value.lastNameProperty.value?[0]}',
                                    textOverrides:
                                        StyledTextOverrides(fontSize: 24),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacers.w15,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StyledContentHeaderText(
                          '${OrganizationController.loggedInUserEntity?.value.firstNameProperty.value} ${OrganizationController.loggedInUserEntity?.value.lastNameProperty.value}',
                          textOverrides: StyledTextOverrides(
                            fontSize: 20,
                            textAlign: TextAlign.start,
                            fontColor: context
                                .style()
                                .initialStyleContext
                                .foregroundColor,
                          ),
                        ),
                        StyledBodyText(
                          OrganizationController.loggedInUserEntity?.value
                                  .emailProperty.value ??
                              '',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacers.h15,
              StyledDivider(),
              Spacers.h15,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StyledCategory.low(
                  children: [
                    Row(
                      children: [
                        StyledIcon.medium(Icons.edit),
                        StyledBodyText('Edit Profile'),
                        Expanded(child: Container()),
                        StyledIcon.medium(Icons.chevron_right)
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StyledCategory.low(
                  children: [
                    Row(
                      children: [
                        StyledIcon.medium(Icons.settings),
                        StyledBodyText('Account Settings'),
                        Expanded(child: Container()),
                        StyledIcon.medium(Icons.chevron_right)
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: StyledButton.high(
                  text: 'Logout',
                  onTapped: () async {
                    final answer =
                        await confirm('Are you sure you want to log out?');
                    if (answer != true) {
                      return;
                    }

                    await locate<AuthService>().logout();
                    context.style().navigateReplacement(
                        context: context, newPage: (_) => LoginScreen());
                  },
                  borderRadius: BorderRadius.zero,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: StyledButton.medium(
                  onTapped: () async {
                    await confirm(
                        'Are you sure you want to delete your account?');
                    await locate<AuthService>().logout();
                    context.style().navigateReplacement(
                        context: context, newPage: (_) => LoginScreen());
                  },
                  borderRadius: BorderRadius.zero,
                  text: 'Delete Account',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
