import 'package:fentrue23/features/schemes/data/scheme.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class SchemeEntity extends Entity<Scheme> {
  static Query<SchemeEntity> getSchemeByOrganization(String organization) =>
      Query.from<SchemeEntity>()
          .where(Scheme.organizationField, isEqualTo: organization);
}
