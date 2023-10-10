import 'package:fentrue23/features/schemes/scheme_tab.dart';

class FixtureScheme {
  final String name;

  final List<SchemeTab> tabs;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tabs': [...tabs.map((tab) => tab.toJson())],
    };
  }

  FixtureScheme({required this.name, required this.tabs});
}
