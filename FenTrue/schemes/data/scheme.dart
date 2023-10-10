import 'package:jlogical_utils/jlogical_utils.dart';

class Scheme extends ValueObject {
  static const String nameField = 'name';
  static const String groupField = 'group';
  static const String fileField = 'file';
  static const String organizationField = 'organizationId';
  static const String imageField = 'image';

  late final nameProperty = FieldProperty<String>(name: nameField).required();
  late final groupProperty = FieldProperty<String>(name: groupField).required();
  late final organizationProperty =
      FieldProperty<String>(name: organizationField)
          .withFallback(() => 'default');
  late final fileProperty = AssetFieldProperty(name: fileField);
  late final imageProperty = FieldProperty<String?>(name: imageField);

  @override
  List<Property> get properties =>
      super.properties +
      [
        nameProperty,
        fileProperty,
        groupProperty,
        organizationProperty,
        imageProperty,
      ];

  @override
  Map<String, Property> get propertiesByKey {
    super.propertiesByKey;

    Map<String, Property> resultMap = {};

    resultMap.addAll(super.propertiesByKey);
    resultMap.addAll({
      nameField: nameProperty,
      fileField: fileProperty,
      groupField: groupProperty,
      organizationField: organizationProperty,
      imageField: imageProperty,
    });

    return resultMap;
  }

  void createFile() {}
}
