import 'package:courageous_people/common/hive/token_hive.dart';

class User {
  final int id;
  final String nickname;
  final String email;
  final int managerFlag;
  // final String birthDate;
  // final List<int> favorites;
  // todo: 즐겨찾기 목록 -> user hive에 넣음 (db 저장 x)

  const User(
      this.id,
      this.nickname,
      this.email,
      // this.birthDate,
      this.managerFlag,
      // this.favorites,
      );
}