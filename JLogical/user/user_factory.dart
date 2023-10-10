class UserFactory {
  Future<UserEntity> createNewUser({
    required String phoneNumber,
    String firstName = "",
    String lastName = "",
    String email = "",
    bool? isAlert = false,
    Location? location,
  }) async {
    final user = new User()
      ..firstNameProperty.value = firstName
      ..lastNameProperty.value = lastName
      ..phoneProperty.value = phoneNumber
      ..emailProperty.value = email
      ..alertProperty.value = isAlert
      ..lastLocationProperty.value = location;

    final userEntity = new UserEntity()..value = user;
    await userEntity.create();

    return userEntity;
  }

  Future<UserEntity?> updateAlertStatus({required UserEntity? userEntity, required bool isOnAlert}) async {
    if (userEntity == null) return userEntity;
    final updatedUser = userEntity.value.copy();
    if (isOnAlert == updatedUser.alertProperty.value) return userEntity;

    updatedUser.alertProperty.value = isOnAlert;
    userEntity.value = updatedUser;
    await userEntity.save();
    return userEntity;
  }

  Future<UserEntity?> updateDeviceTokens(
      {required UserEntity? userEntity, required String? token, bool replaceAll = true}) async {
    if (userEntity == null) return userEntity;
    final updatedUser = userEntity.value.copy();

    if (replaceAll) {
      updatedUser.deviceTokensProperty.value = (token != null ? [token] : []);
    } else if (!replaceAll && token != null) {
      updatedUser.deviceTokensProperty.value!.add(token);
    }

    userEntity.value = updatedUser;
    await userEntity.save();
    return userEntity;
  }
}
