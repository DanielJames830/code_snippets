import 'package:jlogical_utils/jlogical_utils.dart';

class Fixture extends ValueObject {
  static const String timeModifiedField = "timeModified";
  static const String projectIdField = "projectId";
  static const String quantityField = "quantity";
  static const String brandField = "brand";
  static const String categoryField = "category";
  static const String subcategoryField = "subcategory";
  static const String detailsField = "details";
  static const String measurementsField = 'measurements';
  static const String schemeField = 'scheme';
  static const String imagesField = 'images';

// required fields
  late final categoryProperty =
      FieldProperty<String>(name: categoryField).required();
  late final subcategoryProperty =
      FieldProperty<String>(name: subcategoryField).required();
  late final projectIdProperty =
      FieldProperty<String>(name: projectIdField).required();
  late final schemeIdProperty =
      FieldProperty<String>(name: schemeField).required();

// fallback fields
  late final timeModifiedProperty = FieldProperty<int>(name: timeModifiedField)
      .withFallbackReplacement(() => DateTime.now().millisecondsSinceEpoch);
  late final quantityProperty =
      FieldProperty<int>(name: quantityField).withFallbackReplacement(() => 1);

  late final detailsProperty =
      MapFieldProperty<String, dynamic>(name: detailsField)
          .withFallbackReplacement(
    () => <String, dynamic>{},
  );

  late final imagesProperty = ListAssetFieldProperty(
    name: imagesField,
  );

  Fixture copy() {
    return Fixture()..copyFrom(this);
  }

  @override
  List<Property> get properties =>
      super.properties +
      [
        timeCreatedProperty,
        quantityProperty,
        projectIdProperty,
        categoryProperty,
        subcategoryProperty,
        detailsProperty,
        schemeIdProperty,
      ];

  @override
  Map<String, Property> get propertiesByKey {
    Map<String, Property> result = {};

    result.addAll(super.propertiesByKey);
    result.addAll(
      {
        quantityField: quantityProperty,
        projectIdField: projectIdProperty,
        timeModifiedField: timeModifiedProperty,
        categoryField: categoryProperty,
        subcategoryField: subcategoryProperty,
        detailsField: detailsProperty,
        schemeField: schemeIdProperty,
      },
    );

    return result;
  }
}
