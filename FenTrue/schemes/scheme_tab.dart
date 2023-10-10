import 'package:fentrue23/features/schemes/scheme_category.dart';

class SchemeTab {
  final String name;
  final int icon;
  final List<SchemeCategory> categories;

  Map<String, dynamic> toJson() {
    return {
      'type': 'tab',
      'icon': icon,
      'name': name,
      'categories': [...categories.map((category) => category.toJson())]
    };
  }

  SchemeTab({required this.name, required this.categories, required this.icon});
}
