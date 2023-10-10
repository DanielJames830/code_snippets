import 'package:jlogical_utils/jlogical_utils.dart';

import 'fixture.dart';
import 'fixture_entity.dart';

class FixtureRepository
    extends DefaultAdaptingRepository<FixtureEntity, Fixture> {
  @override
  FixtureEntity createEntity() {
    return FixtureEntity();
  }

  @override
  Fixture createValueObject() {
    return Fixture();
  }

  @override
  String get dataPath => "fixtures";
}
