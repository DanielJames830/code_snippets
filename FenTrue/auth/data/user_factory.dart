import 'package:fentrue23/abstracts/entity_factory.dart';
import 'package:fentrue23/features/auth/data/user.dart';
import 'package:fentrue23/features/auth/data/user_entity.dart';
import 'package:fentrue23/features/organizations/data/organization_controller.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class UserFactory extends EntityFactory<UserEntity, User> {
  @override
  Future<UserEntity?> createNewEntity({
    required Map<String, dynamic> data,
  }) async {
    final entity = UserEntity();
    final object = User();

    if (data['password'] != data['passwordCheck']) {
      throw const SignupFailure.other();
    }
    final userId = await locate<AuthService>()
        .signup(email: data['email'], password: data['password']);

    for (var field in data.keys) {
      object.propertiesByKey[field]?.value = data[field];
    }

    entity.value = object;
    entity.id = userId;
    await entity.createOrSave();
    OrganizationController.loggedInUserEntity = entity;
    return entity;
  }
}
