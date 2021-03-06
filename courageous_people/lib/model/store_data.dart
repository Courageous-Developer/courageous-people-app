import 'menu_data.dart';

class StoreData {
  final int id;
  final String name;
  final String address;
  final String? introduction;
  final double latitude;
  final double longitude;
  final String? businessNumber;
  final List<String> imageUrl;
  final List<MenuData> menuList;

  const StoreData(
      this.id,
      this.name,
      this.address,
      this.introduction,
      this.latitude,
      this.longitude,
      this.businessNumber,
      this.imageUrl,
      this.menuList,
      );
}