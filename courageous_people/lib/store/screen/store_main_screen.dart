import 'package:courageous_people/model/review_data.dart';
import 'package:courageous_people/model/store_data.dart';
import 'package:courageous_people/review/widget/review_tile.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../widget/transparent_app_bar.dart';

class StoreMainScreen extends StatefulWidget {
  late String name;
  late String businessNumber;
  late String intro;
  bool isFavorite = false;

  StoreMainScreen({Key? key, required Store store}) : super(key: key) {
    this.name = store.name;
    this.businessNumber = store.businessNumber;
    this.intro = store.intro;
  }

  @override
  _StoreMainScreenState createState() => _StoreMainScreenState();
}

class _StoreMainScreenState extends State<StoreMainScreen> {
  late List<Review> _reviewData;

  @override
  void initState() {
    super.initState();

    // todo: review repository에서 데이터 받기
    _reviewData = [
      Review('보현짱짱123', 5.0, '스파게티 너무 맛있네요 ㅎㅎ', null, null),
      Review('영훈짱짱123', 3.0, '다신 안가요', 'assets/images/pukka.png', null),
      Review('성호짱짱123', 4.5, '강추', 'assets/images/pukka.png', null),
      Review('우현짱짱123', 2.5, '뻐큐머겅', null, null),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: THEME_COLOR,
      appBar: TransparentAppBar(
        title: widget.name,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        actions: [
          IconButton(
            onPressed: () {
              // todo: 즐찾 추가 해제 로직 작성
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
              Container(
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
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      enableDrag: true,
                      builder: (_) => _bottomSheet(),
                    ),
                  ),
                ),
              )
            ],
          )
      ),
    );
  }

  Widget _bottomSheet()  => ListView.builder(
    itemBuilder: (context, index) => ReviewTile(
      data: _reviewData[index],
    ),
    itemCount: _reviewData.length,
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
    // return Center(
    //   child: ReviewTile('우현짱짱123', 4.5, '2021.08.21'),
    // );
    return Container();
  }
}




