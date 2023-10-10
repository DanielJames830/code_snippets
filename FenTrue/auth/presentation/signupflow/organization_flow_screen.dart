import 'package:fentrue23/constants/spacers.dart';
import 'package:fentrue23/features/organizations/presentation/organization_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../../../../style.dart';
import '../../../organizations/presentation/organization_join_screen.dart';

class OrganizationSetUpScreen extends HookWidget {
  const OrganizationSetUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final smartFormController = SmartFormController();
    final selectedCategory =
        useState<OrganizationChoice>(OrganizationChoice.join);

    return StyledPage(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ScrollColumn.withScrollbar(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StyledIcon.high(
                size: 60,
                Icons.account_circle_outlined,
              ),
              Spacers.h15,
              StyledBodyText(
                "Choose your account type",
                textOverrides: StyledTextOverrides(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Spacers.h15,
              StyledBodyText(
                "This will help us create a workspace\nthat works for you.",
                textOverrides: StyledTextOverrides(),
              ),
              Spacers.h35,
              StyledDivider(),
              Spacers.h35,
              SmartForm(
                controller: smartFormController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CategorySelection(
                      icon: Icons.business_center,
                      titleText: "Join Organization",
                      descriptionText: "Join an organization via code",
                      onTap: () {
                        selectedCategory.value = OrganizationChoice.join;
                      },
                      value: selectedCategory.value == OrganizationChoice.join,
                    ),
                    CategorySelection(
                      icon: Icons.build,
                      titleText: "Create Organization",
                      descriptionText: "Create an organization",
                      onTap: () {
                        selectedCategory.value = OrganizationChoice.create;
                      },
                      value:
                          selectedCategory.value == OrganizationChoice.create,
                    ),
                    Spacers.h20,
                    StyledButton.high(
                      onTapped: () {
                        selectedCategory.value == OrganizationChoice.create
                            ? context.style().navigateTo(
                                context: context,
                                page: (_) => OrganizationEditScreen())
                            : context.style().navigateTo(
                                context: context,
                                page: (_) => OrganizationJoinScreen());
                      },
                      text: "Next Step",
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum OrganizationChoice { join, create }

class CategorySelection extends StatelessWidget {
  final Function() onTap;
  final bool value;

  final String? titleText;
  final String? descriptionText;
  final IconData? icon;

  const CategorySelection({
    super.key,
    required this.onTap,
    this.value = false,
    this.descriptionText,
    this.icon,
    this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [],
        ),
        child: StyledContainer.high(
          onTapped: () {
            onTap();
          },
          color: value
              ? lightenColor(AppStyle.primaryColor, 30)
              : context.style().initialStyleContext.backgroundColorSoft,
          border: Border.all(
            width: 3,
            color: value ? AppStyle.primaryColor : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 10,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StyledContainer(
                    border: Border.all(
                      width: 3,
                      color:
                          !value ? AppStyle.primaryColor : Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: value
                        ? AppStyle.primaryColor
                        : context
                            .style()
                            .initialStyleContext
                            .backgroundColorSoft,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: StyledIcon.high(
                        size: 35,
                        icon ?? Icons.abc,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (titleText != null)
                      StyledContentHeaderText(
                        titleText!,
                      ),
                    if (descriptionText != null)
                      StyledContentSubtitleText(
                        descriptionText!,
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Color lightenColor(Color color, int amount) {
    if (color == Colors.white) {
      return color.darken(amount);
    }

    final isAlmostWhite = color.computeLuminance() > 0.85;
    if (isAlmostWhite) {
      return Colors.white;
    }

    return color.computeLuminance() < 0.5
        ? color.lighten(amount)
        : color.darken(amount);
  }
}
