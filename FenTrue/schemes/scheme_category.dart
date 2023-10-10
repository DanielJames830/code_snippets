import 'package:fentrue23/features/schemes/scheme_object.dart';

class SchemeCategory extends SchemeObject {
  final String name;

  final List<SchemeObject> objects;

  SchemeCategory({
    required this.name,
    required this.objects,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'group',
      'name': name,
      'objects': [...objects.map((object) => object.toJson())]
    };
  }
}
