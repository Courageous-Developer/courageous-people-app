import 'package:courageous_people/common/constants.dart';
import 'package:courageous_people/log_out/cubit/log_out_cubit.dart';
import 'package:courageous_people/store/cubit/store_cubit.dart';
import 'package:courageous_people/store/cubit/store_state.dart';
import 'package:courageous_people/utils/show_alert_dialog.dart';
import 'package:courageous_people/utils/user_verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

import '../../log_in/log_In_screen.dart';
import '../../model/store_data.dart';
import '../widget/main_menu.dart';
import '../widget/store_box.dart';
import '../widget/store_searching_section.dart';

class Home extends HookWidget {
  Home({Key? key}) : super(key: key);

  String myCurrentLocation = '';  // 내 현재 위치

  @override
  Widget build(BuildContext context) {
    final storeCubit = StoreCubit.of(context);
    final logOutCubit = LogOutCubit.of(context);

    final mapControllerNotifier = useState<NaverMapController?>(null);
    final storeNotifier = useState<StoreData?>(null);  // 클릭해서 선택한 가게
    final markerNotifier = useState<List<Marker>>([]);
    final crawledMarkerNotifier = useState<List<Marker>>([]);
    final duplicatedListNotifier = useState<List<StoreData?>>([]);
    final mergedMarkerListNotifier = useState<List<Marker>>([]);

    final crawledStoreNotifier = useState<List<dynamic>?>(null);
    final searchStoreSectionNotifier = useState(false);
    final menuExpandedNotifier = useState(false);

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: verifyUser(),
          builder: (context, snapshot) {
            final logInSucceed = snapshot.data as bool?;

            if(logInSucceed == null)  return Container();

            return BlocConsumer<StoreCubit, StoreState>(
              bloc: storeCubit,
              listener: (context, state) async {
                if (state is StoreLoadedState) {
                  final image = await OverlayImage.fromAssetImage(
                    assetName: 'assets/images/store.png',
                  );

                  markerNotifier.value = state.storeList.map(
                          (store) {
                        return Marker(
                          markerId: 'store${store.id}',
                          position: LatLng(store.latitude, store.longitude),
                          icon: image,
                          width: 35,
                          height: 35,
                          onMarkerTab: (a, b) {
                            storeNotifier.value = store;
                          },
                        );
                      }
                  ).toList();

                  mergedMarkerListNotifier.value = markerNotifier.value;
                }

                if (state is StoreErrorState) {
                  showAlertDialog(
                    context: context,
                    title: state.message,
                  );
                }

                if (state is StoreCrawlSuccessState) {
                  if(state.crawledList.length == 0) {
                    showAlertDialog(
                      context: context,
                      title: '검색 결과가 없습니다',
                    );
                  }

                  crawledStoreNotifier.value = state.crawledList;
                  duplicatedListNotifier.value = state.duplicatedList;
                  if(state.crawledList.isEmpty)  return;

                  crawledMarkerNotifier.value = [];

                  for (dynamic store in crawledStoreNotifier.value!) {
                    final index = crawledStoreNotifier.value!.indexOf(store);

                    if(duplicatedListNotifier.value[index] != null) continue;

                    crawledMarkerNotifier.value.add(
                      Marker(
                        markerId: 'crawl$index',
                        position: LatLng(store['latitude'], store['longitude']),
                      ),
                    );
                  }

                  mergedMarkerListNotifier.value = [
                    ...markerNotifier.value,
                    ...crawledMarkerNotifier.value,
                  ];

                  _moveMapCamera(
                    mapControllerNotifier.value,
                    crawledStoreNotifier.value![0]['latitude'],
                    crawledStoreNotifier.value![0]['longitude'],
                  );
                }

                if (state is StoreCrawlErrorState) {
                  showAlertDialog(
                    context: context,
                    title: state.message,
                  );
                }
              },
              builder: (context, state) => Stack(
                children: [
                  NaverMap(
                    initLocationTrackingMode: LocationTrackingMode.Follow,
                    locationButtonEnable: true,
                    onMapCreated: (controller) {
                      mapControllerNotifier.value = controller;

                      storeCubit.getStores();
                    },
                    onMapTap: (latLng) {
                      storeNotifier.value = null;
                    },
                    rotationGestureEnable: false,
                    markers: mergedMarkerListNotifier.value,
                  ),
                  StoreBox(store: storeNotifier.value),
                  if(searchStoreSectionNotifier.value)
                    Positioned(
                      top: 60,
                      child: StoreSearchSection(
                          crawledData: crawledStoreNotifier.value,
                          duplicatedStoreList: duplicatedListNotifier.value,
                          onSearchPressed: (location, storeName) async {
                            FocusScope.of(context).unfocus();

                            await storeCubit.crawlStore(location, storeName);
                          },
                          onCloseButtonPressed: () {
                            searchStoreSectionNotifier.value = false;
                            crawledStoreNotifier.value = [];
                            duplicatedListNotifier.value = [];
                            mergedMarkerListNotifier.value = markerNotifier.value;
                          },
                          onStoreTap: (latitude, longitude) {
                            _moveMapCamera(
                              mapControllerNotifier.value,
                              latitude,
                              longitude,
                            );
                          }
                      ),
                    ),
                  if(state is StoreCrawlingState)
                    const Center(
                      child: CircularProgressIndicator(
                        color: THEME_COLOR,
                        strokeWidth: 7,
                      ),
                    ),
                  Positioned(
                    left: 30,
                    top: 30,
                    child: MainMenu(
                      succeedLogIn: logInSucceed,
                      isMenuExpanded: menuExpandedNotifier.value,
                      onMainMenuPressed: () {
                        menuExpandedNotifier.value = !(menuExpandedNotifier.value);
                      },
                      onLogInPressed: () {
                        menuExpandedNotifier.value = false;

                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (_) => LogInScreen(),
                          ),
                        );
                      },
                      onLogOutPressed: () {
                        menuExpandedNotifier.value = false;

                        showAlertDialog(
                          context: context,
                          title: '로그아웃합니다',
                          onSubmit: () async {
                            await logOutCubit.logOut();

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Home(),
                              ),
                                  (route) => false,
                            );
                          },
                        );
                      },
                      onAddingStorePressed: () {
                        menuExpandedNotifier.value = false;
                        searchStoreSectionNotifier.value = true;
                      },
                      onNearStoreListPressed: () {},
                      onFavoriteListPressed: () {},
                    ),
                  ),
                ],
              ),
            );
          },
        ),
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

  void _moveMapCamera(
      NaverMapController? mapController,
      double latitude,
      double longitude,
      ) {
    if (mapController == null) return;

    final newPosition = CameraUpdate.toCameraPosition(
      CameraPosition(
        target: LatLng(
          latitude,
          longitude,
        ),
      ),
    );

    mapController.moveCamera(newPosition);
  }
}