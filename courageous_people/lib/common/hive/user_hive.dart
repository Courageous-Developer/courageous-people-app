import 'package:courageous_people/common/constants.dart';
import 'package:courageous_people/model/user_data.dart';
import 'package:hive/hive.dart';

class UserHive {
  // Singleton
  static late Box<dynamic> _box;
  static String userStore = 'USER_HIVE';

  static final UserHive _userHive = UserHive._();
  factory UserHive() => _userHive;

  UserHive._() {
    // 오리지널 생성자
    _box = Hive.box(userStore);
  }

  int get userId {
    int id = _box.get(USER_HIVE_ID_FIELD, defaultValue: -1);
    return id;
  }

  String? get userEmail {
    String email = _box.get(USER_HIVE_EMAIL_FIELD, defaultValue: null);
    return email;
  }

  String? get userNickname {
    String nickname = _box.get(USER_HIVE_NICKNAME_FIELD, defaultValue: null);
    return nickname;
  }

  int get userManagerFlag {
    int manageFlag = _box.get(USER_HIVE_MANAGER_FLAG_FIELD, defaultValue: -1);
    return manageFlag;
  }

  Future<void> setId(int id) async {
    await _box.put(USER_HIVE_ID_FIELD, id);
  }

  Future<void> setNickname(String? nickname) async {
    await _box.put(USER_HIVE_NICKNAME_FIELD, nickname);
  }

  Future<void> setEmail(String? email) async {
    await _box.put(USER_HIVE_EMAIL_FIELD, email);
  }

  Future<void> setManagerFlag(int managerFlag) async {
    await _box.put(USER_HIVE_MANAGER_FLAG_FIELD, managerFlag);
  }

  // Future<void> setUser(
  //     int id,
  //     String nickname,
  //     String email,
  //     // String birthDate,
  //     int manageFlag) async {
  //   await setId(id);
  //   await setNickname(nickname);
  //   await setEmail(email);
  //   // await setBirthDate(birthDate);
  //   await setManageFlag(manageFlag);
  // }

  Future<void> setUser(UserData user) async {
    await setId(user.id);
    await setNickname(user.nickname);
    await setEmail(user.email);
    await setManagerFlag(user.managerFlag);
  }

  Future<void> clearUser() async {
    await setId(-1);
    await setNickname(null);
    await setEmail(null);
    await setManagerFlag(-1);
  }
}