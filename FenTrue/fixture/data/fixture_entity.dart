import 'package:jlogical_utils/jlogical_utils.dart';

import 'fixture.dart';

class FixtureEntity extends Entity<Fixture> {
  static Query<FixtureEntity> getFixtureByProjectId(String projectId) =>
      Query.from<FixtureEntity>()
          .where(Fixture.projectIdField, isEqualTo: projectId);
}
