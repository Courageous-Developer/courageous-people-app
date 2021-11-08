import 'package:courageous_people/model/menu_data.dart';
import 'package:courageous_people/model/store_data.dart';
import 'package:courageous_people/review/screen/show_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class StoreMainScreen extends HookWidget {
  final StoreData store;
  bool isFavorite = false; // todo: 즐겨찾기이면 반영 (hive)

  StoreMainScreen({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            expandedHeight: 230.0,
            elevation: 1,
            backgroundColor: Colors.grey.shade100,
            flexibleSpace: FlexibleSpaceBar(
              background: _flexibleSpaceSection(),
            ),
            titleTextStyle: TextStyle(color: Colors.black),
            centerTitle: true,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back,
                color: Colors.grey,
              ),
            ),
            actions: [
              _favoriteIcon(
                onPressed: () {
                  // todo: 즐찾 추가 해제 로직 작성
                  // todo: 츨찾 추가 시에 db 서버에 수정 put 요청
                },
              ),
            ],
          ),
          SliverFillRemaining(child: _body(context)),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _storeIntroduceSection(
            sectionMaxWidth: MediaQuery.of(context).size.width * 3 / 4,
          ),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowReviewScreen(
                  storeId: store.id,
                  menuList: store.menuList,
                ),
              ),
            ),
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                '리뷰 보기 〉',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _simpleCommentSection(),
          _menuListSection(),
        ],
      ),
    );
  }

  Widget _flexibleSpaceSection() {
    return NaverMap(
      initLocationTrackingMode: LocationTrackingMode.None,
      scrollGestureEnable: false,
      initialCameraPosition: CameraPosition(
        target: LatLng(store.latitude, store.longitude),
      ),
      markers: [
        Marker(
          markerId: "current",
          position: LatLng(store.latitude, store.longitude),
        ),
      ],
    );
  }

  Widget _storeIntroduceSection({required double sectionMaxWidth}) => Stack(
    children: [
      _storeSubInformationBox(),
      _storeNameSection(
          maxWidth: sectionMaxWidth
      ),
    ],
  );

  Widget _storeSubInformationBox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: Colors.grey.shade700, width: 2),
      ),
      margin: EdgeInsets.only(top: 18, bottom: 2),
      child: Container(
        padding: EdgeInsets.only(top: 27, bottom: 20, left: 20, right: 20),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '주소',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  '대표 메뉴',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store.address,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 15),
                Text('대표 메뉴가 없습니다'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _storeNameSection({required double maxWidth}) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(left: 20),
      child: Text(
        ' ${store.name} ',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _simpleCommentSection() {
    final introduction = store.introduction ?? '';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              Icons.lightbulb,
              color: Colors.yellow.shade900,
              size: 13,
            ),
            Text(
              ' 사장님의 한 줄 소개!',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        SizedBox(height: 3),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          width: Size.infinite.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Colors.yellow.shade300,
          ),
          child: Text(
            introduction == '' ? '한 줄 소개가 없습니다' : introduction,
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _favoriteIcon({required void Function()? onPressed}) => IconButton(
    onPressed: onPressed,
    icon: Icon(
      Icons.favorite,
      color: isFavorite ? Colors.red : Colors.grey,
    ),
  );

  Widget _menuListSection() {
    if (store.menuList.length == 0) {
      return Expanded(
        child: Center(
          child: Text('메뉴가 아직 등록되지 않았습니다'),
        ),
      );
    }

    final List<Widget> menuTileList = store.menuList.map(
          (menu) => _MenuTile(menu: menu),
    ).toList();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ' 메뉴 ',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 15),
            // margin: EdgeInsets.symmetric(horizontal: 5, vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: menuTileList,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final MenuData menu;

  const _MenuTile({Key? key, required this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 7),
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                menu.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${menu.price.toString()}원',
                style: TextStyle(fontSize: 17),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              menu.imageUrl ?? 'assets/images/picture.png',
              width: 70,
              height: 70,
            ),
            // child: Image.network(
            //   menu.imageUrl,
            //   width: 70,
            //   height: 70,
            // ),
          ),
        ],
      ),
    );
  }
}