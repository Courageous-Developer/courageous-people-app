import 'package:courageous_people/common/hive/user_hive.dart';
import 'package:courageous_people/model/menu_data.dart';
import 'package:courageous_people/model/store_data.dart';
import 'package:courageous_people/review/screen/show_review_screen.dart';
import 'package:courageous_people/widget/menu_button.dart';
import 'package:flutter/cupertino.dart';
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
            title: Text(store.name),
            titleTextStyle: TextStyle(color: Colors.black),
            centerTitle: true,
            leading: Icon(Icons.arrow_back, color: Colors.grey),
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
          _storeIntroduceSection(),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowReviewScreen(storeId: store.id),
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

  Widget _storeIntroduceSection() => Stack(
    children: [
      _storeSubInformationBox(),
      _storeNameSection(),
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

  Widget _storeNameSection() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(left: 20),
      child: Text(
        ' ${store.name} ',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _simpleCommentSection() {
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
          child: Text(store.introduction ?? '한 줄 소개가 없습니다',
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
                menu.price.toString(),
                style: TextStyle(fontSize: 17),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/picture.png',
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









































// Container(
//   child: Row(
//     children: [
//       Flexible(
//         child: GestureDetector(
//           onTap: null,
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//               // border: Border.all(width: 1),
//               color: Colors.teal.shade100,
//             ),
//             margin: EdgeInsets.only(left: 10, right: 5),
//             padding: EdgeInsets.all(15),
//             alignment: Alignment.center,
//             width: Size.infinite.width,
//             child: Text(
//               '가게 정보',
//               style: TextStyle(
//                   fontSize: 20,
//                   color: Colors.black
//               ),
//             ),
//           ),
//         ),
//         flex: 1,
//       ),
//       Flexible(
//         child: GestureDetector(
//           onTap: () async {
//             final userId = UserHive().userId;
//
//             final addingReviewSucceeded = await Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => AddReviewScreen(
//                   storeId: store.id,
//                   userId: userId,
//                 ),
//               ),
//             );
//
//             if(addingReviewSucceeded != null && addingReviewSucceeded!) {
//               await _reviewCubit.getReviews(store.id);
//             }
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//               // border: Border.all(width: 0),
//               color: Colors.teal.shade100,
//             ),
//             margin: EdgeInsets.only(left: 5, right: 10),
//             padding: EdgeInsets.all(15),
//             alignment: Alignment.center,
//             width: Size.infinite.width,
//             child: Text(
//               '리뷰 남기기',
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ),
//         flex: 1,
//       ),
//     ],
//   ),
// ),
// SizedBox(height: 20),
// // Divider(thickness: 4),
// // SizedBox(height: 20),
// Flexible(
//   child: BlocBuilder<ReviewCubit, ReviewState>(
//     bloc: _reviewCubit,
//     builder: (context, state) => _reviews(state),
//   ),
//   flex: 8,
// ),








// Widget get _subContent => Container(
//   padding: EdgeInsets.symmetric(vertical: 20),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         '메뉴',
//         style: TextStyle(
//           fontSize: 25,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       SizedBox(height: 12),
//       Container(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _menuTile(),
//             _menuTile(),
//             _menuTile(),
//           ],
//         ),
//       ),
//     ],
//   ),
// );














// Widget _addReview(
//     TextEditingController reviewController,
//     TextEditingController containerController,
//     TextEditingController tagController,
//     ) {
//   return SingleChildScrollView(
//     child: Container(
//       padding: EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Container(
//                 padding: EdgeInsets.all(15),
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                   border: Border.all(width: 1),
//                   color: Colors.white,
//                 ),
//                 child: Stack(
//                   children: [
//                     Center(child: Icon(Icons.camera_alt_outlined)),
//                     Container(
//                       alignment: Alignment.bottomCenter,
//                       child: Text(
//                         "No Image",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(width: 20),
//               ElevatedButton(
//                 onPressed: () {},
//                 child: Text('사진 등록'),
//               ),
//             ],
//           ),
//           SizedBox(height: 25),
//           MyInputForm(
//             title: Text('리뷰'),
//             controller: reviewController,
//           ),
//           SizedBox(height: 25),
//           MyInputForm(
//             title: Text('용기 정보'),
//             controller: containerController,
//           ),
//           SizedBox(height: 25),
//           MyInputForm(
//             title: Text('태그'),
//             controller: tagController,
//           ),
//           SizedBox(height: 30),
//           ElevatedButton(
//             onPressed: () async {
//               final http.Response response = await http.post(
//                 Uri.parse('$NON_AUTH_SERVER_URL/review'),
//                 headers: {
//                   "Accept": "application/json",
//                   "Authorization": "Bearer ${TokenHive().accessToken!}"
//                 },
//                 body: jsonEncode({
//                   "content": "${reviewController.text}",
//                   "store": "6",
//                   "user": "5",
//                 }),
//               );
//
//               if(response.statusCode == 201)  print('등록 완료');
//               Navigator.pop(context);
//             },
//             child: Text('리뷰 등록'),
//           ),
//         ],
//       ),
//     ),
//   );
// }
// }

// import 'package:courageous_people/model/review_data.dart';
// import 'package:courageous_people/model/store_data.dart';
// import 'package:courageous_people/my_rating_bar.dart';
// import 'package:courageous_people/review/widget/review_tile.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../../widget/transparent_app_bar.dart';
// import 'package:courageous_people/store/menu/menu_tile.dart';
// import 'package:courageous_people/review/screen/add_review_screen.dart';
//
// class StoreMainScreen extends StatelessWidget {
//   late String name;
//   late String businessNumber;
//   late String intro;
//   bool isFavorite = false;
//
//   StoreMainScreen({Key? key, required Store store}) : super(key: key) {
//     this.name = store.name;
//     this.businessNumber = store.businessNumber;
//     this.intro = store.intro;
//   }
//   // late List<Review> _reviewData= [
//   //   Review('보현짱짱123', 5.0, '스파게티 너무 맛있네요 ㅎㅎ', null, null),
//   //   Review('영훈짱짱123', 3.0, '다신 안가요', 'assets/images/pukka.png', null),
//   //   Review('성호짱짱123', 4.5, '강추', 'assets/images/pukka.png', null),
//   //   Review('우현짱짱123', 2.5, '뻐큐머겅', null, null),
//   // ];
//
//   @override
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0.0,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back_ios,
//               color: Colors.black,
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           )
//       ),
//       body: DefaultTabController(
//         length: 3,
//         child: NestedScrollView(
//           physics: NeverScrollableScrollPhysics(),
//           headerSliverBuilder: (context,isScolled){
//             return [
//               SliverAppBar(
//                 backgroundColor: Color.fromRGBO(250,250,250,1),
//                 collapsedHeight: 200,
//                 expandedHeight: 200,
//                 flexibleSpace: StoreProfile(),
//               ),
//               SliverPersistentHeader(
//                 delegate: MyDelegate(
//                     TabBar(
//                       tabs: [
//                         Tab(child:Text('메뉴'),),
//                         Tab(child:Text('정보'),),
//                         Tab(child:Text('리뷰'),),
//                       ],
//                       indicatorColor: Colors.blue,
//                       unselectedLabelColor: Colors.grey,
//                       labelColor: Colors.black,
//                     )
//                 ),
//                 floating: true,
//                 pinned: true,
//               )
//             ];
//           },
//           body: TabBarView(
//               children: [
//                 ListView(
//                   children: [
//                     MenuTile(),
//                     MenuTile(),
//                     MenuTile(),
//                     MenuTile(),
//                     MenuTile(),
//                     MenuTile(),
//                     MenuTile(),
//                     MenuTile(),
//                     MenuTile(),
//                     MenuTile(),
//                     MenuTile(),
//                   ],
//                 ),
//                 StoreInfo(),
//                 Stack(
//                     children: [ListView.builder(
//                       itemBuilder: (context, index) => Container(
//                         // data: _reviewData[index],
//                       ),
//                       // itemCount: _reviewData.length,
//                     ),
//                       Container(
//                         alignment: Alignment.bottomRight,
//                         child: Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: FloatingActionButton(
//                             onPressed: (){Navigator.push(context, MaterialPageRoute(
//                                 builder: (_) => ReviewBox()));},
//                             child: Icon(Icons.add),
//                           ),
//                         ),
//                       )
//                     ]
//                 ),
//               ]
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class MyDelegate extends SliverPersistentHeaderDelegate{
//   MyDelegate(this.tabBar);
//   final TabBar tabBar;
//
//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: Colors.white,
//       child: tabBar,
//     );
//   }
//
//   @override
//   double get maxExtent => tabBar.preferredSize.height;
//
//   @override
//   double get minExtent => tabBar.preferredSize.height;
//
//   @override
//   bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
//     return false;
//   }
//
// }
//
//
// class StoreProfile extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(20,0,20,0),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(8.0),
//             child: Container(
//               height: 130.0,
//               width: MediaQuery.of(context).size.width*0.95,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(height: 10,),
//                   Text('옛날 통닭',style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 36,
//                   ),
//                   ),
//                   SizedBox(height: 5,),
//                   Text('경기도 성남시 중원구 도촌로8번길 30 놀부빌딩',style: TextStyle(fontSize: 14),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       MyRatingBar(4.5),
//                     ],
//                   ),
//                 ],
//               ),
//               margin: const EdgeInsets.only(bottom: 6.0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5.0),
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey,
//                     offset: Offset(0.0, 1.0),
//                     blurRadius: 6.0,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         SizedBox(height: 5,),
//         ToggleButtons(
//           isSelected: [false,false,false],
//           onPressed:(index){},//ToDo:버튼 별 기능 할당(좋아요,전화,신고 창 띄우기)
//           children: [
//             Container(
//               color: Colors.white,
//               width: MediaQuery.of(context).size.width*0.3,
//               height: 50,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.favorite_border),
//                   Text('좋아요'),
//                 ],
//               ),
//             ),
//             Container(
//               color: Colors.white,
//               width: MediaQuery.of(context).size.width*0.3,
//               height: 50,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.call),
//                   Text('전화'),
//                 ],
//               ),
//             ),
//             Container(
//               color: Colors.white,
//               width: MediaQuery.of(context).size.width*0.3,
//               height: 50,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('신고'),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//
//   }
// }
//
//
//
//
//
// class StoreInfo extends StatelessWidget {
//   const StoreInfo({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width,
//           color: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Text('가게 분류>치킨'),
//           ),
//         ),
//         SizedBox(height: 5,),
//
//         Container(
//           width: MediaQuery.of(context).size.width,
//           color: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Text('사장님이 직접 작성한 소개글'),
//           ),
//         ),
//         SizedBox(height: 5,),
//         Container(
//           width: MediaQuery.of(context).size.width,
//           color: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Text('가게 정보>\n연락처\n사업주명\n사업자등록번호\n주소 등'),
//           ),
//         ),
//         SizedBox(height: 5,),
//       ],
//     );
//   }
// }