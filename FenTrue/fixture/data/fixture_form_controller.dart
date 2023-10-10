import 'package:fentrue23/features/fixture/data/fixture_entity.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import 'fixture_factory.dart';

class FixtureFormController extends SmartFormController {
  late final FixtureEntity? fixtureEntity;

  FixtureFormController();

  void save(BuildContext context) async {
    try {
      if (fixtureEntity == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: StyledBodyText('Unable to save work'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      final result = await validate();
      if (!result.isValid) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: StyledBodyText('Work has been saved'),
          duration: Duration(seconds: 2),
        ),
      );
      Map<String, dynamic> data = result.valueByName!;
      await FixtureFactory().updateEntity(entity: fixtureEntity!, data: data);
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: StyledBodyText('Not connected to the internet'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
  }
}
