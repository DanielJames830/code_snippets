import 'package:fentrue23/features/fixture/presentation/edit_flow/subcategory_selection_screen.dart';
import 'package:fentrue23/features/project/data/project/project_entity.dart';
import 'package:fentrue23/features/widgets/category_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import '../../data/fixture.dart';

class CategoryScreen extends HookWidget {
  final SmartFormController controller;
  final ProjectEntity projectEntity;

  const CategoryScreen({
    super.key,
    required this.controller,
    required this.projectEntity,
  });

  @override
  Widget build(BuildContext context) {
    controller.registerFormField(
        enabled: true,
        name: Fixture.categoryField,
        initialValue: null,
        validators: []);
    void setValue(String value) {
      controller.setData(name: Fixture.categoryField, value: value);
    }

    return StyledPage(
      titleText: 'Fixture Category',
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SmartForm(
          controller: controller,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CategoryListCard(
                aspectRatio: 1.58,
                labelText: 'Windows',
                onPressed: (value) {
                  setValue('window');
                  context.style().navigateReplacement(
                        context: context,
                        newPage: (_) => SubcategorySelectionScreen(
                          projectEntity: projectEntity,
                          controller: controller,
                        ),
                      );
                },
                backgroundImage:
                    AssetImage('assets/images/standard/2PanelGlider-W.png'),
              ),
              CategoryListCard(
                backgroundImage:
                    AssetImage('assets/images/standard/FixedCasement-W.png'),
                aspectRatio: 1.58,
                labelText: 'Doors',
                onPressed: (value) async {
                  setValue('door');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
