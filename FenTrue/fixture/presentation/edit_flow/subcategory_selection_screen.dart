import 'package:collection/collection.dart';
import 'package:fentrue23/constants/spacers.dart';
import 'package:fentrue23/features/fixture/data/fixture_factory.dart';
import 'package:fentrue23/features/fixture/data/fixture_form_controller.dart';
import 'package:fentrue23/features/project/data/project/project_entity.dart';
import 'package:fentrue23/features/fixture/presentation/fixture_edit_screen.dart';
import 'package:fentrue23/features/schemes/data/scheme_entity.dart';
import 'package:fentrue23/features/widgets/category_list_card.dart';
import 'package:fentrue23/features/widgets/try_catch_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import '../../../project/data/project/project.dart';
import '../../data/fixture.dart';

class SubcategorySelectionScreen extends HookWidget {
  final SmartFormController controller;

  final ProjectEntity projectEntity;
  const SubcategorySelectionScreen({
    required this.controller,
    required this.projectEntity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    controller.registerFormField(
      enabled: true,
      name: Fixture.subcategoryField,
      initialValue: null,
      validators: [],
    );
    controller.registerFormField(
      enabled: true,
      name: Fixture.schemeField,
      initialValue: null,
      validators: [],
    );

    initialize(SchemeEntity schemeEntity) async {
      controller.setData(
          name: Fixture.subcategoryField,
          value: schemeEntity.value.nameProperty.value);
      controller.setData(name: Fixture.schemeField, value: schemeEntity.id);
      final validation = await controller.validate();
      final fixtureEntity =
          await FixtureFactory().createNewEntity(data: validation.valueByName!);
      (controller as FixtureFormController).fixtureEntity = fixtureEntity;
      Project project = projectEntity.value
        ..fixtureIdsProperty.value!.addAll(
          {
            fixtureEntity?.id! ?? 'id':
                schemeEntity.value.nameProperty.value ?? ''
          },
        );

      projectEntity.value = project;
      await projectEntity.save();

      context.style().navigateReplacement(
            context: context,
            newPage: (_) => EditFixtureScreen(
              projectEntity: projectEntity,
              fixtureEntity: fixtureEntity!,
              controller: controller,
              formId: schemeEntity.value.fileProperty.value!,
            ),
          );
    }

    final schemeQuery =
        useQuery(SchemeEntity.getSchemeByOrganization('default').all());

    return StyledPage(
      titleText: 'Subcategory',
      body: ModelBuilder(
        model: schemeQuery.model,
        builder: (schemeEntities) {
          final groupedMap = groupBy(schemeEntities,
              (schemeEntity) => schemeEntity.value.groupProperty.value);
          final groupedLists = groupedMap.values
              .map((groupedItems) => groupedItems.toList())
              .toList();

          return ScrollColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...groupedLists.map(
                (scheme) => Column(
                  children: [
                    Spacers.h35,
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: StyledContentHeaderText(
                        scheme.firstOrNull?.value.groupProperty.value ?? '',
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: scheme.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: TryCatchWidget(
                              replacementWidget: StyledLoadingIndicator(),
                              child: CategoryListCard(
                                backgroundImage:
                                    (scheme[index].value.imageProperty.value !=
                                                null ||
                                            scheme[index]
                                                .value
                                                .imageProperty
                                                .value!
                                                .isEmpty)
                                        ? AssetImage(scheme[index]
                                            .value
                                            .imageProperty
                                            .value!)
                                        : null,
                                formId: scheme[index].value.fileProperty.value,
                                aspectRatio: 1,
                                labelText:
                                    scheme[index].value.nameProperty.value ??
                                        '',
                                onPressed: (value) async {
                                  return await initialize(scheme[index]);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
