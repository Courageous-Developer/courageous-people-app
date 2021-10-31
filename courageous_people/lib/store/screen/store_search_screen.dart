import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import '../../model/store_data.dart';

class StoreSearchScreen extends HookWidget {
  StoreSearchScreen({Key? key}) : super(key: key);

  late List<dynamic> crawledStoreData;
  late List<bool> isSelectedList = [false, false, false, false, false];
  late List<Marker> markerList;
  late List<StoreData> storeList;

  @override
  Widget build(BuildContext context) {
    crawledStoreData = [];
    markerList = [];
    storeList = [];

    return Scaffold(
      // body: Stack(
      //   children: [
      //     // _content(context),
      //     // Positioned(
      //     //   left: 30,
      //     //   top: 40,
      //     //   child: _backButton(onPressed: () => Navigator.pop(context)),
      //     // ),
      //   ],
      // ),
    );
  }

  // Widget _content(BuildContext context) {
  //   return Stack(
  //     children: [
  //       Column(
  //         mainAxisSize: MainAxisSize.min,
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           Container(
  //             child: _mapSection(),
  //             height: MediaQuery.of(context).size.height,
  //           ),
  //           Expanded(child: _storeListSection()),
  //         ],
  //       ),
  //       _searchWidget(),
  //     ],
  //   );
  // }
  //
  // Widget _backButton({
  //   required void Function()? onPressed,
  // }) {
  //   return GestureDetector(
  //     onTap: onPressed,
  //     child: Container(
  //       width: 34,
  //       height: 34,
  //       decoration: BoxDecoration(
  //         color: Colors.black,
  //         borderRadius: BorderRadius.circular(17),
  //       ),
  //       child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
  //     ),
  //   );
  // }

  // Widget _mapSection() => NaverMap(markers: markerList);
  //
  // Widget _searchWidget() {
  //   final storeSearchInputController = TextEditingController();
  //   final locationInputController = TextEditingController();
  //
  //   return Container(
  //     margin: EdgeInsets.only(top: 30),
  //     padding: EdgeInsets.all(10),
  //     width: double.maxFinite,
  //     height: 160,
  //     color: Colors.transparent,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Container(
  //               width: 200,
  //               child: TextField(
  //                 decoration: InputDecoration(
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                   filled: true,
  //                   fillColor: Colors.white,
  //                   hintText: '지역을 입력해주세요',
  //                   hintStyle: TextStyle(fontSize: 13),
  //                 ),
  //                 controller: locationInputController,
  //               ),
  //             ),
  //             SizedBox(height: 5),
  //             Container(
  //               width: 200,
  //               child: TextFormField(
  //                 // text: Text('지역을 입력해주세요'),
  //                 decoration: InputDecoration(
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                   filled: true,
  //                   fillColor: Colors.white,
  //                   hintText: '가게 이름을 입력해주세요',
  //                   hintStyle: TextStyle(fontSize: 13),
  //                 ),
  //                 controller: storeSearchInputController,
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(width: 10),
  //         GestureDetector(
  //           onTap: () async {
  //             // FocusScope.of(context).unfocus();
  //
  //             // if(locationInputController.text == '')  return;
  //             //
  //             // markerList = [];
  //             //
  //             // for(Json data in crawledStoreData) {
  //             //   final index = crawledStoreData.indexOf(data);
  //             //   final latLng = await _addressToLatLng(data['address']);
  //             //
  //             //   data['latitude'] = latLng.latitude;
  //             //   data['longitude'] = latLng.longitude;
  //             //
  //             //   crawledStoreData[index] = data;
  //             //
  //             //   final marker = await toMarker(data);
  //             //   markerList.add(marker);
  //             // }
  //           },
  //           child: Container(
  //             width: 50,
  //             height: double.maxFinite,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(10),
  //               color: Colors.green.shade300,
  //             ),
  //             child: Icon(Icons.search, color: Colors.white),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _storeListSection() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 20),
  //     child: _resultListView(crawledStoreData),
  //   );
  // }


  // Widget _resultTile(
  //     BuildContext context,
  //     Map<String, dynamic> crawledData,
  //     int index,
  //     ) {
  //   crawledData['title'] = _pureTitle(crawledData['title']);
  //
  //   return GestureDetector(
  //     onTap: () {
  //       // setState(() {
  //       //   isSelectedList = [false, false, false, false, false];
  //       //   isSelectedList[index] = true;
  //       // });
  //       //
  //       // showBottomSheet(
  //       //   context: context,
  //       //   builder: (context) => _registerButton(context, crawledData),
  //       // );
  //     },
  //
  //     child: Container(
  //       height: 80,
  //       color: isSelectedList[index] ? Colors.grey[300] : Colors.transparent,
  //       // padding: EdgeInsets.symmetric(horizontal: 15),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Flexible(
  //             child: Container(
  //               alignment: Alignment.centerLeft,
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 children: [
  //                   Text(
  //                     crawledData['title'],
  //                     style: TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 18
  //                     ),
  //                   ),
  //                   SizedBox(width: 10),
  //                   Text(
  //                     crawledData['category'],
  //                     style: TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.grey
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             flex: 1,
  //           ),
  //           Flexible(
  //             child: Container(
  //               alignment: Alignment.topLeft,
  //               child: Text(crawledData['address']),
  //             ),
  //             flex: 1,
  //           ),
  //           SizedBox(height: 30),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _resultListView(List<dynamic> results) {
  //   return  Center(
  //     child: results.length != 0
  //         ? ListView.builder(
  //       itemCount: results.length,
  //       itemBuilder:
  //           (context, index) => _resultTile(
  //         context,
  //         results[index],
  //         index,
  //       ),
  //     )
  //         : Text('검색 결과가 없습니다'),
  //   );
  // }

  // String _pureTitle(String title)  {
  //   final first = title.split('<b>');
  //   if (first.length == 1) return first[0];
  //
  //   final second = first[1].split('</b>');
  //   return '${first[0]}${second[0]}${second[1]}';
  // }
  //
  // Future<Marker> toMarker(Json data) async {
  //   return Marker(
  //     markerId: data['title'],
  //     position: LatLng(data['latitude'], data['longitude']),
  //   );
  // }
}

// Widget _registerButton(BuildContext context, Map<String, dynamic> storeData) {
//   return GestureDetector(
//     onTap: () {
//       Navigator.push(context, MaterialPageRoute(
//         builder: (_) => StoreAddScreen(storeData),
//       ));
//     },
//     child: Container(
//       height: 50,
//       color: Colors.green,
//       child: Center(
//         child:
//         Text(
//           '등록하기',
//           style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 16
//           ),
//         ),
//       ),
//     ),
//   );
// }







// class _Content extends HookWidget {
//   const _Content({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }



// Widget _locationSelectList() {
//   return Column(
//     mainAxisSize: MainAxisSize.min,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     mainAxisAlignment: MainAxisAlignment.start,
//     children: [
//       Text('지역을 설정해주세요'),
//       SizedBox(height: 8),
//       Row(
//         children: [
//           Expanded(
//             child: MyDropDown(
//               title: '시/도',
//               contents: ['aa', 'bb','aa', 'bb','aa', 'bb','aa', 'bb','aa', 'bb'],
//             ),
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: MyDropDown(
//               title: '시/군/구',
//               contents: [
//                 '강동구', '강서구', '강남구', '강북구', '송파구',
//                 '노원구', '성북구', '성동구', '금천구', '동대문구'
//               ],
//             ),
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: MyDropDown(
//               title: '읍/면/동',
//               contents: [
//                 '강동구', '강서구', '강남구', '강북구', '송파구',
//                 '노원구', '성북구', '성동구', '금천구', '동대문구'
//               ],
//             ),
//           ),
//         ],
//       ),
//     ],
//   );
// }
