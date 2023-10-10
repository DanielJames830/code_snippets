class UserRepository extends DefaultAdaptingRepository<UserEntity, User> {
  String get dataPath => 'users';

  @override
  UserEntity createEntity() {
    return UserEntity();
  }

  @override
  User createValueObject() {
    return User();
  }
}
