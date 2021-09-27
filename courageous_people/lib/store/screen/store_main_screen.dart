import 'dart:convert';

import 'package:courageous_people/common/constants.dart';
import 'package:courageous_people/common/hive/token_hive.dart';
import 'package:courageous_people/model/review_data.dart';
import 'package:courageous_people/model/store_data.dart';
import 'package:courageous_people/model/menu_data.dart';
import 'package:courageous_people/review/cubit/review_cubit.dart';
import 'package:courageous_people/review/cubit/review_state.dart';
import 'package:courageous_people/review/screen/add_review_screen.dart';
import 'package:courageous_people/store/section/review_section.dart';
import 'package:courageous_people/widget/my_input_form.dart';
import 'package:courageous_people/widget/review_tile.dart';
import 'package:courageous_people/widget/menu_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import '../../widget/transparent_app_bar.dart';
import 'package:provider/provider.dart';

class StoreMainScreen extends HookWidget {
  final Stores store;
  bool isFavorite = false; // todo: 즐겨찾기이면 반영 (hive)

  StoreMainScreen({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _reviewCubit = context.read<ReviewCubit>();

    final reviewController = TextEditingController();
    final containerController = TextEditingController();
    final tagController = TextEditingController();

    _reviewCubit.getReviews(store.id);

    return Scaffold(
      // appBar: TransparentAppBar(
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         // todo: 즐찾 추가 해제 로직 작성
      //         // todo: 츨찾 추가 시에 db 서버에 수정 put 요청
      //       },
      //       icon: Icon(
      //         Icons.favorite,
      //         color: isFavorite ? Colors.red : Colors.grey,
      //       ),
      //     )
      //   ],
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            // title: Text(store.name),
            expandedHeight: 250.0,
            backgroundColor: Colors.red,
            // backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                store.name,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(25.0),
                    bottomLeft: Radius.circular(25.0),
                  ),
                ),
                child: NaverMap(
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

                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  // todo: 즐찾 추가 해제 로직 작성
                  // todo: 츨찾 추가 시에 db 서버에 수정 put 요청
                },
                icon: Icon(
                  Icons.favorite,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
          SliverFillRemaining(
            child: _body(),
          ),
        ],
      ),
    );
  }

  Widget _body() => Container(
    alignment: Alignment.topCenter,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // flex: 1,
          child: Center(
            child: Text(
              store.name,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          // flex: 1,
          child: Center(
            child: Text(
              store.intro ?? '한 줄 소개가 없습니다',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal[300],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
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
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    '대표 메뉴',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.address,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    '대표 메뉴 정보가 없습니다',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: null,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(width: 1),
                      color: Colors.teal.shade50,
                    ),
                    margin: EdgeInsets.only(left: 10, right: 5),
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.center,
                    width: Size.infinite.width,
                    child: Text(
                      '가게 정보',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black
                      ),
                    ),
                  ),
                ),
                flex: 1,
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () async {
// await _reviewCubit.getReviews(4);

//   showModalBottomSheet(
//     context: context,
//     builder: (_) => _addReview(
//       reviewController, containerController, tagController,
//     ),
//   );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(width: 1),
                      color: Colors.teal.shade50,
                    ),
                    margin: EdgeInsets.only(left: 5, right: 10),
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.center,
                    width: Size.infinite.width,
                    child: Text(
                      '리뷰 남기기',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                flex: 1,
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Divider(thickness: 4),
        SizedBox(height: 20),
// Flexible(
// // child: BlocConsumer(
// //   bloc: _reviewCubit,
// //   listener: (_, state) {
// //     if (state is ReviewLoadedState) print('aaa');
// //     // _reviewListNotifier.value = state.reviewList;
// //   },
// child: BlocBuilder<ReviewCubit, ReviewState>(
// bloc: _reviewCubit,
// builder: (context, state) => _reviews(state),
// ),
// flex: 8,
// ),
      ],
    ),
  );


  BoxDecoration _selected() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(7)),
    );
  }

  Widget _menus() =>
      ListView.builder(
        itemBuilder: (context, index) => MenuTile(),
        itemCount: 10,
      );

  Widget _reviews(ReviewState state) {
    if (state is ReviewLoadingState) return CircularProgressIndicator();
    if (state is ReviewLoadedState) {
      final reviews = state.reviewList;

      return Container(
        // child: Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Container(
        //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        //       child: Text(
        //         '리뷰 ${reviews.length}개',
        //         style: TextStyle(
        //           fontSize: 20,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //     Container(
        child: ListView.builder(
          itemBuilder: (context, index) => ReviewTile(review: reviews[index]),
          itemCount: reviews.length,
        ),
      );
      //     ],
      //   ),
      // );
    }

    return Container();
  }

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
}

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
//   // todo: review repository에서 데이터 받기
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
//                 flexibleSpace: StoreProfile(),//ToDo:가게 이름,주소,별점 평균 인자로 넘기기
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
//                   children: [//ToDo:MenuTile에 인자(사진,메뉴이름,메뉴설명) 추가하고 리뷰처럼 자동으로 배열
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
//                       )//ToDo:연필모양 아이콘으로 수정
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
//   //ToDo:위에서 인자 전달 받아서 정보 표시
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
//                       MyRatingBar(4.5),//ToDo:별점 표기&사이즈 조절
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
//   //ToDo:가게 정보 받아와서 표시
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