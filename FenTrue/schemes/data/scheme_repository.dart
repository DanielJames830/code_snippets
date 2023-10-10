import 'package:fentrue23/features/schemes/data/scheme.dart';
import 'package:fentrue23/features/schemes/data/scheme_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class SchemeRepository extends DefaultAdaptingRepository<SchemeEntity, Scheme> {
  @override
  String get dataPath => 'schemes';

  @override
  SchemeEntity createEntity() {
    return SchemeEntity();
  }

  @override
  Scheme createValueObject() {
    return Scheme();
  }
}
