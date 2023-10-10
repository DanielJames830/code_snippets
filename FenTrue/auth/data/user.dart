import 'package:jlogical_utils/jlogical_utils.dart';

// This is the formal we will need to use to define objects that we want
// to store on Firebase.
class User extends ValueObject {
  static String emailField = 'email';
  static String firstNameField = 'firstName';
  static String lastNameField = 'lastName';

  // Define your fields like this
  late final emailProperty = FieldProperty<String>(name: emailField).required();
  late final firstNameProperty = FieldProperty<String>(name: firstNameField);
  late final lastNameProperty = FieldProperty<String>(name: lastNameField);

  // Then add your fields to this array so that The UserEntity class can
  // manage them.
  @override
  List<Property> get properties =>
      super.properties +
      [
        emailProperty,
        firstNameProperty,
        lastNameProperty,
      ];

  @override
  Map<String, Property> get propertiesByKey {
    super.propertiesByKey;

    Map<String, Property> resultMap = {};

    resultMap.addAll(super.propertiesByKey);
    resultMap.addAll({
      firstNameField: firstNameProperty,
      lastNameField: lastNameProperty,
      emailField: emailProperty,
    });

    return resultMap;
  }
}
