import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socials/domain/model/user.dart';
import 'package:socials/domain/repository/user_repository.dart';
import 'package:socials/presentation/manager/auth/auth.dart';

part 'current_user_provider.g.dart';

@riverpod
class CurrentUserNotifier extends _$CurrentUserNotifier {

  UserRepository _userRepository = UserRepository();
  @override
  Future<User> build() async {
    return await _userRepository.fetchUser(Auth().currentUserId());
  }

}