import 'package:courageous_people/model/store_data.dart';
import 'package:courageous_people/store/screen/store_main_screen.dart';
import 'package:courageous_people/utils/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

import '../../store/screen/store_add_screen.dart';

class StoreSearchSection extends HookWidget {
  const StoreSearchSection({
    Key? key,
    required this.crawledData,
    required this.duplicatedStoreList,
    required this.onSearchPressed,
    required this.onCloseButtonPressed,
    required this.onStoreTap,
  }) : super(key: key);

  final List<dynamic>? crawledData;
  final List<StoreData?> duplicatedStoreList;
  final Future<void> Function(String, String) onSearchPressed;
  final void Function() onCloseButtonPressed;
  final void Function(double, double) onStoreTap;

  @override
  Widget build(BuildContext context) {
    final locationNotifier = useState('');
    final storeNameNotifier = useState('');

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 94,
      padding: EdgeInsets.symmetric(horizontal: 30).copyWith(bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          _StoreSearchWidget(
            onLocationChanged: (location) => locationNotifier.value = location,
            onStoreNameChanged: (storeName) => storeNameNotifier.value = storeName,
            onCloseButtonPressed: onCloseButtonPressed,
            onSearchPressed: () async {
              if (locationNotifier.value == '') {
                showAlertDialog(
                  context: context,
                  title: '가게가 있는 지역을 압력해주세요',
                );

                return;
              }

              if (storeNameNotifier.value == '') {
                showAlertDialog(
                  context: context,
                  title: '가게의 이름을 압력해주세요',
                );

                return;
              }

              await onSearchPressed(
                locationNotifier.value,
                storeNameNotifier.value,
              );
            },
          ),
          crawledData != null
              ?
          _CrawledStoreBox(
            crawledData: crawledData!,
            duplicatedStoreList: duplicatedStoreList,
            onStoreTap: onStoreTap,
          )
              : SizedBox(height: 0),
        ],
      ),
    );
  }
}

class _StoreSearchWidget extends StatelessWidget {
  final void Function()? onSearchPressed;
  final void Function(String) onLocationChanged;
  final void Function(String) onStoreNameChanged;
  final void Function() onCloseButtonPressed;

  const _StoreSearchWidget({
    Key? key,
    required this.onSearchPressed,
    required this.onLocationChanged,
    required this.onStoreNameChanged,
    required this.onCloseButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _closeButton(onPressed: onCloseButtonPressed),
        SizedBox(height: 10),
        Container(
          width: screenWidth - 60,
          height: 140,
          color: Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: screenWidth - 130,
                    child: TextField(
                      onChanged: (location) => onLocationChanged(location),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '지역을 입력해주세요',
                        hintStyle: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: screenWidth - 130,
                    child: TextFormField(
                      onChanged: (storeName) => onStoreNameChanged(storeName),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '가게 이름을 입력해주세요',
                        hintStyle: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: onSearchPressed,
                child: Container(
                  width: 60,
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green.shade300,
                  ),
                  child: Icon(Icons.search, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _closeButton({required void Function()? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 30,
        height: 30,
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(Icons.close, color: Colors.white, size: 20),
      ),
    );
  }
}

class _CrawledStoreBox extends HookWidget {
  final List<dynamic> crawledData;
  final List<StoreData?> duplicatedStoreList;
  final void Function(double, double) onStoreTap;

  const _CrawledStoreBox({
    Key? key,
    required this.crawledData,
    required this.duplicatedStoreList,
    required this.onStoreTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final indexNotifier = useState(0);

    if(crawledData.isEmpty) return Container(color: Colors.black);

    return Container(
      width: MediaQuery.of(context).size.width - 60,
      child: crawledData.isEmpty
          ? Center(child: Text('검색 결과가 없습니다'))
          :
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 30,
            alignment: Alignment.bottomCenter,
            child: _numberHeader(
              indexChanged: (index) {
                indexNotifier.value = index;

                onStoreTap(
                  crawledData[index]['latitude'],
                  crawledData[index]['longitude'],
                );
              },
            ),
          ),
          _storeSection(
            index: indexNotifier.value,
            onAddPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      StoreAddScreen(
                        storeData: crawledData[indexNotifier.value],
                        managerFlag: 1,
                        // todo: managerFLag 변경
                      ),
                ),
              );
            },
            onDuplicatedPressed: () {
              if(duplicatedStoreList[indexNotifier.value] == null)  return;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoreMainScreen(
                    store: duplicatedStoreList[indexNotifier.value]!,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _storeSection({
    required int index,
    required void Function() onAddPressed,
    required void Function() onDuplicatedPressed,
  }) {
    final store = crawledData[index];
    final duplicatedStore = duplicatedStoreList[index];

    final String storeName = _pureTitle(store['title']);
    final String category = store['category'];
    final String address = store['address'];
    final double latitude = store['latitude'];
    final double longitude = store['longitude'];
    // final bool isDuplicated = store['duplicated'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        ),
        border: Border.all(
          width: 3,
          color: _getColorByIndex(index),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: double.maxFinite,
            height: 30,
            child: duplicatedStore != null
                ?
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.check, color: Colors.green, size: 16),
                SizedBox(width: 3),
                Text(
                  '등록된 가게',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                )
              ],
            )
                :
            SizedBox(width: 0),
          ),
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 30),
            padding: EdgeInsets.all(30).copyWith(top: 0, bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      storeName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.5
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      category,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey
                      ),
                    ),
                  ],
                ),    // 가게 이름, 카테고리 칸
                SizedBox(height: 10),
                Text(
                  address,
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),  // 가게 주소 칸
                SizedBox(height: 10),
                duplicatedStore != null
                    ?
                _submitButton(
                  index: index,
                  title: '가게로 이동',
                  onPressed: onDuplicatedPressed,
                )
                    :
                _submitButton(
                  index: index,
                  title: '등록하기',
                  onPressed: onAddPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _numberHeader({required void Function(int) indexChanged}) {
    final flexNotifier = useState([2, 1, 1, 1, 1]);

    List<Widget> indexBoxList = [];

    for(int index = 0; index < crawledData.length; index++) {
      indexBoxList.add(
        Expanded(
          flex: flexNotifier.value[index],
          child: GestureDetector(
            onTap: () {
              indexChanged(index);

              flexNotifier.value = [1, 1, 1, 1, 1];
              flexNotifier.value[index] = 2;
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: _getColorByIndex(index),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(7.5),
                  topRight: Radius.circular(7.5),
                ),
              ),
              child: Text(
                '${index+1}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: indexBoxList,
    );
  }

  Widget _submitButton({
    required int index,
    required String title,
    required void Function() onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: _getColorByIndex(index),
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _getColorByIndex(int index) {
    switch (index) {
      case 0:
        return Colors.green.shade300;
      case 1:
        return Colors.blue.shade300;
      case 2:
        return Colors.grey.shade500;
      case 3:
        return Colors.indigo.shade300;
      case 4:
        return Colors.teal.shade300;
    }

    return Colors.black;
  }

  String _pureTitle(String title)  {
    String refined = '';

    final bTagSplit = title.split('<b>');
    if (bTagSplit.length == 1) return bTagSplit[0];


    refined = bTagSplit[0];

    for(int index=1; index < bTagSplit.length; index++) {
      final slashBTagSplit = bTagSplit[index].split('</b>');

      refined += (slashBTagSplit[0] + slashBTagSplit[1]);
    }

    return refined;
  }

  Future<Marker> _toMarker(Map<String, dynamic> data) async {
    return Marker(
      markerId: data['title'],
      position: LatLng(data['latitude'], data['longitude']),
    );
  }
}