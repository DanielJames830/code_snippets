import 'dart:async';

import 'package:fentrue23/features/fixture/data/fixture.dart';
import 'package:fentrue23/features/fixture/data/fixture_entity.dart';
import 'package:fentrue23/features/fixture/data/fixture_form_controller.dart';

import 'package:fentrue23/features/project/data/project/project_entity.dart';

import 'package:fentrue23/features/schemes/data/scheme_factory.dart';

import 'package:fentrue23/features/schemes/presets/presets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EditFixtureScreen extends HookWidget {
  final FixtureEntity fixtureEntity;
  final ProjectEntity projectEntity;
  final String formId;

  final SmartFormController controller;

  const EditFixtureScreen({
    super.key,
    required this.fixtureEntity,
    required this.controller,
    required this.projectEntity,
    required this.formId,
  });

  @override
  Widget build(BuildContext context) {
    final fixture = useState<Fixture>(fixtureEntity.value);
    final savedFixture = useState<Fixture>(fixture.value);

    try {
      (controller as FixtureFormController).fixtureEntity = fixtureEntity;
    } catch (e) {
      print(e);
    }

    // autosave
    useEffect(() {
      Timer timer;

      timer = Timer.periodic(
        Duration(seconds: 5),
        (timer) async {
          if (savedFixture.value != fixture.value) {
            savedFixture.value = fixture.value;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: StyledBodyText('Work has been saved'),
                duration: Duration(seconds: 2),
              ),
            );

            fixtureEntity.value = savedFixture.value;
            await fixtureEntity.createOrSave();
          }
        },
      );
      return () {
        timer.cancel();
      };
    }, []);

    return FutureBuilder(
      future: SchemeFactory.getJsonString(formId),
      builder: (context, future) {
        if (future.connectionState == ConnectionState.waiting) {
          return StyledPage(
            body: Center(
              child: StyledLoadingIndicator(),
            ),
          );
        } else if (future.hasError) {
          return StyledPage(
            body: Center(
              child: StyledBodyText("Unable to read form file"),
            ),
          );
        } else {
          return SmartForm(
            controller: controller,
            child: SchemeFactory.buildForm(
              context: context,
              scheme: SchemeFactory.jsonToScheme(
                future.data ?? Presets.defaultScheme.toJson(),
              )!,
              controller: controller,
              fixture: fixtureEntity.value,
            ),
          );
        }
      },
    );
  }
}
