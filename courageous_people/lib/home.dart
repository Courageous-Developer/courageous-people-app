import 'package:courageous_people/log_out/cubit/log_out_cubit.dart';
import 'package:courageous_people/store/screen/store_add_screen.dart';
import 'package:courageous_people/store/cubit/store_cubit.dart';
import 'package:courageous_people/store/cubit/store_state.dart';
import 'package:courageous_people/utils/show_alert_dialog.dart';
import 'package:courageous_people/utils/user_verification.dart';
import 'package:courageous_people/widget/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

import 'log_in/log_In_screen.dart';
import 'model/store_data.dart';
import 'store/screen/store_search_screen.dart';
import 'store/screen/store_main_screen.dart';

class Home extends HookWidget {
  Home({Key? key}) : super(key: key);

  String myCurrentLocation = '';  // 내 현재 위치

  NaverMapController? _mapController;

  Future<void> loadMap() async {

  }

  void clearAllSelectedElement() {

  }

  @override
  Widget build(BuildContext context) {
    final storeCubit = StoreCubit.of(context);
    final logOutCubit = LogOutCubit.of(context);

    final storeNotifier = useState<StoreData?>(null);  // 클릭해서 선택한 가게
    final markerNotifier = useState<List<Marker>>([]);
    final crawledMarkerNotifier = useState<List<Marker>>([]);
    final mergedMarkerListNotifier = useState<List<Marker>>([]);

    final crawledStoreNotifier = useState<List<dynamic>>([]);
    final searchStoreSectionNotifier = useState(true);

    final locationController = TextEditingController();
    final storeNameController = TextEditingController();

    return Scaffold(
      body: FutureBuilder(
          future: verifyUser(),
          builder: (context, snapshot) {
            final loginSucceed = snapshot.data as bool?;

            return BlocListener(
              bloc: storeCubit,
              listener: (context, state) async {
                if (state is StoreLoadedState) {
                  final image = await OverlayImage.fromAssetImage(
                    assetName: 'assets/images/container.png',
                  );

                  markerNotifier.value = state.storeList.map(
                          (store) {
                        return Marker(
                          markerId: 'store${store.id}',
                          position: LatLng(store.latitude, store.longitude),
                          icon: image,
                          onMarkerTab: (a, b) {
                            storeNotifier.value = store;
                          },
                        );
                      }
                  ).toList();

                  mergedMarkerListNotifier.value = markerNotifier.value;
                }
                if (state is StoreCrawlSuccessState) {
                  crawledStoreNotifier.value = state.result;
                  crawledMarkerNotifier.value = [];

                  for (dynamic store in crawledStoreNotifier.value) {
                    final index = crawledStoreNotifier.value.indexOf(store);
                    if (store['duplicated']) continue;

                    crawledMarkerNotifier.value.add(
                      Marker(
                        markerId: '${store['title']}-$index',
                        position: LatLng(store['latitude'], store['longitude']),
                      ),
                    );
                  }

                  mergedMarkerListNotifier.value = [
                    ...markerNotifier.value,
                    ...crawledMarkerNotifier.value,
                  ];

                  if(_mapController == null);

                  final newPosition = CameraUpdate.toCameraPosition(
                    CameraPosition(
                      target: LatLng(
                        crawledStoreNotifier.value[0]['latitude'],
                        crawledStoreNotifier.value[0]['longitude'],
                      ),
                    ),
                  );

                  _mapController!.moveCamera(newPosition);
                }
              },
              child: Stack(
                children: [
                  NaverMap(
                    initLocationTrackingMode: LocationTrackingMode.Follow,
                    locationButtonEnable: true,
                    onMapCreated: (controller) {
                      _mapController = controller;

                      storeCubit.getStores();
                    },
                    onMapTap: (latLng) {
                      storeNotifier.value = null;
                    },
                    rotationGestureEnable: false,
                    markers: mergedMarkerListNotifier.value,
                  ),
                  Positioned(
                    left: 30,
                    top: 30,
                    child: _MainMenu(
                      succeedLogIn: loginSucceed ?? false,
                      onMainPressed: () {},
                      onLogInPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) => LogInScreen(),
                        ));
                      },
                      onLogOutPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                title: const Text('로그아웃합니다'),
                                content: null,
                                actions: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      Navigator.pop(context);

                                      await logOutCubit.logOut();

                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => Home(),
                                        ),
                                            (route) => false,
                                      );
                                    },
                                    child: Text('확인'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('취소'),
                                  ),
                                ],
                              ),
                        );
                      },
                      onAddingStorePressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) => StoreSearchScreen(),
                        ));
                      },
                      onNearStoreListPressed: () {},
                      onFavoriteListPressed: () {},
                    ),
                  ),
                  _StoreBox(store: storeNotifier.value),
                  // if(searchStoreSectionNotifier.value)
                  //   Positioned(
                  //     left: 0,
                  //     top: 90,
                  //     child: Column(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         _StoreSearchWidget(
                  //           locationController: locationController,
                  //           storeNameController: storeNameController,
                  //           onSearchPressed: () async {
                  //             FocusScope.of(context).unfocus();
                  //
                  //             if (locationController.text == '') {
                  //               showAlertDialog(
                  //                 context: context,
                  //                 title: '가게가 있는 지역을 압력해주세요',
                  //               );
                  //
                  //               return;
                  //             }
                  //
                  //             if (storeNameController.text == '') {
                  //               showAlertDialog(
                  //                 context: context,
                  //                 title: '가게의 이름을 압력해주세요',
                  //               );
                  //
                  //               return;
                  //             }
                  //
                  //             await storeCubit.crawlStore(
                  //               locationController.text,
                  //               storeNameController.text,
                  //             );
                  //           },
                  //           onCloseButtonPressed: () {
                  //             searchStoreSectionNotifier.value = false;
                  //           },
                  //         ),
                  //         SizedBox(height: MediaQuery
                  //             .of(context)
                  //             .size
                  //             .height * 0.8 - 370),
                  //         crawledStoreNotifier.value.length > 0
                  //             ?
                  //         _CrawledStoreBox(
                  //           crawledData: crawledStoreNotifier.value,
                  //           movePosition: (latitude, longitude) {
                  //             print('_mapController ==null${_mapController ==
                  //                 null}');
                  //             if (_mapController == null) return;
                  //
                  //             final newPosition = CameraUpdate.toCameraPosition(
                  //               CameraPosition(
                  //                 target: LatLng(
                  //                   latitude,
                  //                   longitude,
                  //                 ),
                  //               ),
                  //             );
                  //
                  //             _mapController!.moveCamera(newPosition);
                  //           },
                  //         )
                  //             : Container(
                  //           color: Colors.white,
                  //           child: Center(child: Text('검색 결과가 없습니다')),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                ],
              ),
            );
          }
      ),
    );
  }

  Widget _userSection() {
    return Container(
      width: 150,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.teal.shade100,
        borderRadius: BorderRadius.circular(
          22.5,
          // getWidgetSizeByKey(_menuIconKey).
        ),
        border: Border.all(
          width: 2.5,
          color: Colors.white,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.png'),
            radius: 22.5,
          ),

          Column(
            children: [

            ],
          )
        ],
      ),
    );
  }
}

class _MainMenu extends StatelessWidget {
  const _MainMenu({
    Key? key,
    required this.succeedLogIn,
    required this.onMainPressed,
    required this.onLogInPressed,
    required this.onLogOutPressed,
    required this.onAddingStorePressed,
    required this.onFavoriteListPressed,
    required this.onNearStoreListPressed,
  }) : super(key: key);

  final bool succeedLogIn;
  final void Function() onMainPressed;
  final void Function() onLogInPressed;
  final void Function() onLogOutPressed;
  final void Function() onAddingStorePressed;
  final void Function() onFavoriteListPressed;
  final void Function() onNearStoreListPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MenuButton(
          size: 40,
          borderRadiusValue: 8,
          iconData: Icons.menu,
          backgroundColor: Colors.black,
          onPressed: onMainPressed,
        ),
        const SizedBox(height: 12),
        succeedLogIn
            ? Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _addStoreMenuButton(onPressed: onAddingStorePressed),
            const SizedBox(height: 10),
            _favoriteMenuButton(onPressed: onFavoriteListPressed),
            const SizedBox(height: 10),
            _nearStoreMenuButton(onPressed: onNearStoreListPressed),
            const SizedBox(height: 10),
            _logOutButton(onPressed: onLogOutPressed),
          ],
        )
            : _logInButton(onPressed: onLogInPressed),
      ],
    );
  }

  Widget _logInButton({required void Function()? onPressed}) {
    return MenuButton(
      margin: EdgeInsets.only(left: 3),
      size: 32,
      borderRadiusValue: 16,
      iconData: Icons.login,
      menuTitle: '로그인',
      backgroundColor: Colors.grey.shade500,
      heroTag: "registerStore",
      onPressed: onPressed,
    );
  }

  Widget _logOutButton({required void Function()? onPressed}) {
    return MenuButton(
      margin: EdgeInsets.only(left: 3),
      size: 32,
      borderRadiusValue: 16,
      iconData: Icons.sensor_door,
      menuTitle: "로그아웃",
      backgroundColor: Colors.grey.shade500,
      heroTag: "logout",
      onPressed: onPressed,
    );
  }

  Widget _addStoreMenuButton({required void Function()? onPressed}) {
    return MenuButton(
      margin: EdgeInsets.only(left: 3),
      size: 32,
      borderRadiusValue: 16,
      iconData: Icons.add,
      menuTitle: '가게 추가',
      backgroundColor: Colors.blue.shade300,
      heroTag: "registerStore",
      onPressed: onPressed,
    );
  }

  Widget _favoriteMenuButton({required void Function()? onPressed}) {
    return MenuButton(
      margin: EdgeInsets.only(left: 3),
      size: 32,
      borderRadiusValue: 16,
      iconData: Icons.favorite,
      menuTitle: "찜한 가게",
      backgroundColor: Colors.pink.shade300,
      heroTag: "favorite",
      onPressed: onPressed,
    );
  }

  Widget _nearStoreMenuButton({required void Function()? onPressed}) {
    return MenuButton(
      margin: EdgeInsets.only(left: 3),
      size: 32,
      borderRadiusValue: 16,
      iconData: Icons.store,
      menuTitle: "가까운 가게",
      backgroundColor: Colors.teal.shade300,
      heroTag: "near",
      onPressed: onPressed,
    );
  }
}

class _StoreBox extends StatelessWidget {
  final StoreData? store;

  const _StoreBox({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(store == null) return SizedBox(width: 0);

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => StoreMainScreen(store: store!),
        ));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(
          30,
          MediaQuery.of(context).size.height * 0.68 + 80,
          30,
          MediaQuery.of(context).size.height * 0.07,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          border: Border.all(
            width: 2,
            color: Colors.teal.shade200,
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                store!.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                store!.address,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            color: Colors.black,
                            width: 80,
                          ),
                        ],
                      ),
                    ),
                    Divider(thickness: 0.5, color: Colors.grey.shade900),
                    Icon(Icons.favorite, color: Colors.red, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoreSearchWidget extends StatelessWidget {
  final void Function()? onSearchPressed;
  final void Function()? onCloseButtonPressed;
  final TextEditingController locationController;
  final TextEditingController storeNameController;

  const _StoreSearchWidget({
    Key? key,
    required this.onSearchPressed,
    required this.onCloseButtonPressed,
    required this.locationController,
    required this.storeNameController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _closeButton(onPressed: () => Navigator.pop(context)),
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: '지역을 입력해주세요',
                          hintStyle: TextStyle(fontSize: 13),
                        ),
                        controller: locationController,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: screenWidth - 130,
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: '가게 이름을 입력해주세요',
                          hintStyle: TextStyle(fontSize: 13),
                        ),
                        controller: storeNameController,
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
      ),
    );
  }

  Widget _closeButton({required void Function()? onPressed}) {
    return Container(
      width: 30,
      height: 30,
      padding: EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(Icons.close, color: Colors.white, size: 20),
    );
  }
}

class _CrawledStoreBox extends HookWidget {
  final List<dynamic> crawledData;
  final void Function(double, double) movePosition;

  const _CrawledStoreBox({
    Key? key,
    required this.crawledData,
    required this.movePosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final indexNotifier = useState(0);

    return Container(
      margin: EdgeInsets.all(30),
      width: MediaQuery.of(context).size.width - 60,
      height: MediaQuery.of(context).size.height / 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 30,
            alignment: Alignment.bottomCenter,
            child: _numberHeader(
              indexChanged: (index) {
                indexNotifier.value = index;

                movePosition(
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => StoreMainScreen(store: ),
              //   ),
              // );
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

    final String storeName = _pureTitle(store['title']);
    final String category = store['category'];
    final String address = store['address'];
    final double latitude = store['latitude'];
    final double longitude = store['longitude'];
    final bool isDuplicated = store['duplicated'];

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
            child: isDuplicated
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
            padding: EdgeInsets.symmetric(horizontal: 30),
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
                ),
                SizedBox(height: 10),
                Text(
                  address,
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 10),
                isDuplicated
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

  Future<Marker> toMarker(Map<String, dynamic> data) async {
    return Marker(
      markerId: data['title'],
      position: LatLng(data['latitude'], data['longitude']),
    );
  }
}




class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 400),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, 1.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.ease,
  ));

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: FlutterLogo(size: 150.0),
      ),
    );
  }
}