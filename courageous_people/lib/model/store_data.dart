import 'package:naver_map_plugin/naver_map_plugin.dart';

class Store {
  final String name;
  final String businessNumber;
  final String intro;
  final double latitude;
  final double longitude;

  const Store(
      this.name,
      this.businessNumber,
      this.intro,
      this.latitude,
      this.longitude
      );

  @override
  String toString() {
    // TODO: implement toString
    return '$name $businessNumber $intro $latitude $longitude';
  }
}