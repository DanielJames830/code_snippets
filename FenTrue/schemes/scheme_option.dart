import 'package:fentrue23/features/schemes/scheme_object.dart';

class SchemeOption extends SchemeObject {
  final String name;

  final String inputType;

  final List<Map<dynamic, SchemeOption?>>? values;

  SchemeOption({
    required this.name,
    required this.inputType,
    this.values,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'field',
      'name': name,
      'inputType': inputType,
      'values': values
          ?.map((value) =>
              {value.keys.toList()[0]: value.values.toList()[0]?.toJson()})
          .toList()
    };
  }
}
