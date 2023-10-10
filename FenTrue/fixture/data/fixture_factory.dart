import 'package:fentrue23/abstracts/entity_factory.dart';

import 'fixture.dart';
import 'fixture_entity.dart';

class FixtureFactory extends EntityFactory<FixtureEntity, Fixture> {
  @override
  Future<FixtureEntity> updateEntity({
    required FixtureEntity entity,
    required Map<String, dynamic> data,
  }) async {
    final object = entity.value;

    for (var field in data.keys) {
      if (object.propertiesByKey[field] == null) {
        dynamic value = data[field];

        if ((value.runtimeType == List) && value.length == 1) {
          value = data[field][0];
        }
        object.propertiesByKey[Fixture.detailsField]!.value[field] = value;
      } else {
        object.propertiesByKey[field]!.value = data[field];
      }
    }

    List<MapEntry> details = [...object.detailsProperty.value!.entries];
    for (MapEntry entry in details) {
      if (entry.value == null || entry.value == '') {
        object.detailsProperty.value!.remove(entry.key);
      }
    }

    entity.value = object;
    await entity.save();
    return entity;
  }
}
