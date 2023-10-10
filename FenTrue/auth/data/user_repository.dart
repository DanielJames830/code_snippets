import 'package:fentrue23/features/auth/data/user.dart';
import 'package:fentrue23/features/auth/data/user_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

/// This class defines the way Users will be stored on Firebase
///
/// IMPORTANT: Make sure you add the line '.register(UserRepository())' to
/// _initPond() in main.dart
class UserRepository extends DefaultAdaptingRepository<UserEntity, User> {
  // Defines the folder to save this object in
  @override
  String get dataPath => "users";

  @override
  UserEntity createEntity() {
    return UserEntity();
  }

  @override
  User createValueObject() {
    return User();
  }
}
