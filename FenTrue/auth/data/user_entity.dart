import 'package:fentrue23/features/auth/data/user.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

/// This is a necesarry wrapper for the User class.
/// It allows Pond to push put any data object into a format Firebase
/// can understand.

/// You can also define queries here pertaining to the User class
class UserEntity extends Entity<User> {}
