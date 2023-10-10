class User extends ValueObject with WithPortGenerator<User> {
  static const String firstNameField = 'firstName';
  static const String lastNameField = 'lastName';
  static const String colorField = 'color';
  static const String phoneField = 'phone';
  static const String emailField = 'email';
  static const String alertField = "alert";
  static const String lastLocationField = 'lastLocation';
  static const String deviceTokensField = 'deviceTokens';

  late final firstNameProperty = FieldProperty<String>(name: firstNameField).required();
  late final lastNameProperty = FieldProperty<String>(name: lastNameField).required();
  late final phoneProperty = FieldProperty<String>(name: phoneField).required();
  late final emailProperty = FieldProperty<String>(name: emailField).required();
  late final alertProperty = FieldProperty<bool>(name: alertField).withFallbackReplacement(() => false);
  late final colorProperty = FieldProperty<int>(name: colorField).withFallbackReplacement(() {
    var rng = Random();
    return rng.nextInt(SafeColors.userColors.length - 1);
  });
  late final lastLocationProperty = FieldProperty<Location>(name: lastLocationField);
  late final deviceTokensProperty =
      ListFieldProperty<String>(name: deviceTokensField).withFallbackReplacement(() => []);

  User copy() {
    return User()..copyFrom(this);
  }

  String getFullNameAsString() {
    return "${this.firstNameProperty.value} ${this.lastNameProperty.value}";
  }

  String getUserInitialsAsString() {
    return "${this.firstNameProperty.value![0]}${this.lastNameProperty.value![0]}";
  }

  @override
  List<PortField> get portFields => [
        firstNameProperty.toPortField().required(),
        lastNameProperty.toPortField().required(),
        phoneProperty.toPortField().isPhoneNumber().required(),
        emailProperty.toPortField().isEmail().required(),
      ];

  @override
  List<Property> get properties =>
      super.properties +
      [
        firstNameProperty,
        lastNameProperty,
        phoneProperty,
        emailProperty,
        colorProperty,
        alertProperty,
        lastLocationProperty,
        deviceTokensProperty,
      ];
}
