class UserEntity extends Entity<User> {
  static Query<UserEntity> getUserFromNumber(String phoneNumber) => Query.from<UserEntity>().where(User.phoneField,
      isEqualTo:
          PhoneNumber.parse(phoneNumber, callerCountry: IsoCode.US, destinationCountry: IsoCode.US).international);
}
