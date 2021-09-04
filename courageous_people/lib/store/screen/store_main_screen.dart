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
//
//
//
//
//





import 'package:courageous_people/model/review_data.dart';
import 'package:courageous_people/model/store_data.dart';
import 'package:courageous_people/review/cubit/review_cubit.dart';
import 'package:courageous_people/review/cubit/review_state.dart';
import 'package:courageous_people/review/widget/review_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../common/constants.dart';
import '../../widget/transparent_app_bar.dart';
import 'package:provider/provider.dart';

class StoreMainScreen extends StatefulWidget {
  late int id;
  late String name;
  late String intro;
  bool isFavorite = false;  // todo: 즐겨찾기이면 반영

  StoreMainScreen({Key? key, required Store store}) : super(key: key) {
    this.id = store.id;
    this.name = store.name;
    this.intro = store.intro;
  }

  @override
  _StoreMainScreenState createState() => _StoreMainScreenState();
}

class _StoreMainScreenState extends State<StoreMainScreen> {
  late List<Review> _reviewList;

  @override
  void initState() {
    super.initState();

    _reviewList = [];
  }

  @override
  Widget build(BuildContext context) {
    final reviewCubit = context.read<ReviewCubit>();
    reviewCubit.init();

    return Scaffold(
      backgroundColor: THEME_COLOR,
      appBar: TransparentAppBar(
        title: widget.name,
        actions: [
          IconButton(
            onPressed: () {
              // todo: 즐찾 추가 해제 로직 작성
              // todo: 츨찾 추가 시에 db 서버에 수정 put 요청

              setState(() {
                widget.isFavorite = !(widget.isFavorite);
              });
            },
            icon: Icon(
              Icons.favorite,
              color: widget.isFavorite ? Colors.red : Colors.grey,
            ),
          )
        ],
      ),
      body: Container(
          child: Stack(
            children: [
              Container(
                child: Column(
                  children: [
                    Flexible(child: Container(color: Colors.transparent), flex: 2),
                    Flexible(child: Container(color: Colors.white), flex: 1),
                    Flexible(child: Container(color: Colors.white), flex: 3),
                  ],
                ),
              ),
              BlocConsumer(
                bloc: reviewCubit,
                listener: (context, state) async {
                  if(state is ReviewInitialState) await reviewCubit.getReviews(widget.id);
                  if(state is ReviewLoadedState) {
                    _reviewList = state.reviewList;
                    print(state.reviewList.length);
                  }
                },
                builder: (_, state) => Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: MediaQuery.of(context).size.height/3,
                  margin: EdgeInsets.fromLTRB(10, MediaQuery.of(context).size.height/9 - kToolbarHeight, 10, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Center(
                    child: ElevatedButton(
                        child: Text('리뷰보기'),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            enableDrag: true,
                            builder: (_) => _reviewSheet(_reviewList),
                          );
                        }
                    ),
                  ),
                ),
              )
            ],
          )
      ),
    );
  }

  Widget _reviewSheet(List<Review> reviewList)  => ListView.builder(
    itemBuilder: (context, index) => ReviewTile(
      data: reviewList[index],
    ),
    itemCount: reviewList.length,
  );
}

//
// class StoreIntrodectionWidget extends StatelessWidget {
//   const StoreIntrodectionWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }

class StoreTabWidget extends StatelessWidget {
  const StoreTabWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}