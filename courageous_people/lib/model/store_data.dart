import 'package:naver_map_plugin/naver_map_plugin.dart';

class Store {
  final int id;
  final String name;
  final String businessNumber;
  final String intro;
  final double latitude;
  final double longitude;

  const Store(
      this.id,
      this.name,
      this.businessNumber,
      this.intro,
      this.latitude,
      this.longitude
      );
}