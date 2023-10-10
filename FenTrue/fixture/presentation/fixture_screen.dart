import 'package:fentrue23/features/fixture/data/fixture.dart';
import 'package:fentrue23/features/fixture/data/fixture_entity.dart';
import 'package:fentrue23/features/fixture/presentation/edit_flow/category_screen.dart';
import 'package:fentrue23/features/project/data/project/project_entity.dart';
import 'package:fentrue23/features/schemes/data/scheme_entity.dart';
import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import '../data/fixture_form_controller.dart';
import 'fixture_edit_screen.dart';

class FixtureScreen extends HookWidget {
  final FixtureEntity? fixtureEntity;
  final ProjectEntity projectEntity;
  const FixtureScreen(
      {super.key, required this.projectEntity, required this.fixtureEntity});
  const FixtureScreen.initialize(
      {super.key, required this.projectEntity, this.fixtureEntity});

  @override
  Widget build(BuildContext context) {
    SmartFormController controller = useMemoized(
      () => FixtureFormController(),
    );

    if (fixtureEntity == null) {
      controller.registerFormField(
        name: Fixture.projectIdField,
        initialValue: projectEntity.id,
        enabled: true,
        validators: [],
      );
    }

    final scheme = useQuery(Query.getById<SchemeEntity>(
        fixtureEntity?.value.schemeIdProperty.value ?? 'unknown'));
    return fixtureEntity == null
        ? CategoryScreen(
            controller: controller,
            projectEntity: projectEntity,
          )
        : ModelBuilder(
            model: scheme.model,
            builder: (scheme) {
              return EditFixtureScreen(
                fixtureEntity: fixtureEntity!,
                controller: (controller as FixtureFormController),
                projectEntity: projectEntity,
                formId: scheme?.value.fileProperty.value ?? '',
              );
            },
          );
  }
}
