import 'package:fentrue23/features/schemes/scheme_object.dart';
import 'package:fentrue23/features/schemes/scheme_option.dart';

class SchemeSection extends SchemeObject {
  final String name;
  final bool isHorizontal;
  final List<SchemeOption> options;

  SchemeSection({
    required this.name,
    this.isHorizontal = true,
    required this.options,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'set',
      'name': name,
      'isHorizontal': isHorizontal,
      'options': [...options.map((option) => option.toJson())]
    };
  }
}
