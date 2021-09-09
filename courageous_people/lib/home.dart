import 'dart:convert';

import 'package:courageous_people/store/cubit/store_cubit.dart';
import 'package:courageous_people/store/cubit/store_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'common/constants.dart';
import 'common/hive/token_hive.dart';
import 'log_in/log_In_screen.dart';
import 'model/store_data.dart';
import 'sign_in/sign_in_select_screen.dart';
import 'register/screen/store_search_screen.dart';
import 'store/screen/store_main_screen.dart';
import 'widget/transparent_app_bar.dart';
import 'widget/store_tile.dart';
import 'package:http/http.dart' as http;

class Home extends HookWidget {
  final bool isUserVerified;
  List<Stores> storeList = [];
  String myCurrentLocation = '';
  OverlayImage? image;

  // todo: naver 지도 처음에 안 뜨는 오류 수정
  // todo: marker 하나만 나오는 오류 수정
  Home({Key? key, required this.isUserVerified, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storeCubit = StoreCubit.of(context);
    final isStoreTileClickedNotifier = useState<bool>(false);
    final storeNotifier = useState<Stores?>(null);

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            _userAccountSection(context),
            ListTile(
              leading: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              title: Text(
                '찜한 가게',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.grey,
              ),
              title: Text(
                '설정',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: TransparentAppBar(
        title: myCurrentLocation,
        actions: [
          TextButton(
            onPressed: isUserVerified
                ? () async {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => StoreSearchScreen(),
              ));
            }
                : null,
            child: Text('가게 추가'),
          ),
        ],
      ),
      body: BlocConsumer<StoreCubit, StoreState>(
          bloc: storeCubit,
          listener: (context, state) async {
            if (state is StoreLoadingState) await storeCubit.getStores();
          },
          builder: (_, state) {
            print(state);
            if (state is StoreLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if(state is StoreInitialState)  storeCubit.init();

            if (state is StoreLoadedState) {
              storeList = state.storeList;
              //
              // final List<Marker> markers = [];
              // for(Stores store in storeList) {
              //   markers.add(
              //       Marker(
              //         markerId: '${store.id}',
              //         position: LatLng(store.latitude, store.longitude),
              //       ));
              // }

              return Stack(
                children: [
                  NaverMap(
                    initLocationTrackingMode: LocationTrackingMode.Follow,
                    onMapTap: (latLng) {isStoreTileClickedNotifier.value = false;},
                    markers: storeList.map(
                          (store) => Marker(
                        markerId: 'store${store.id}',
                        position: LatLng(store.latitude, store.longitude),
                        icon: image,
                        onMarkerTab: (a, b) {
                          isStoreTileClickedNotifier.value = true;
                          storeNotifier.value = store;
                        },
                      ),
                    ).toList(),
                    // markers: markers,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      isStoreTileClickedNotifier.value
                          ? 30
                          :  MediaQuery.of(context).size.width - 30,
                      MediaQuery.of(context).size.height*0.68,
                      30,
                      MediaQuery.of(context).size.height*0.07,
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        final http.Response response = await http.get(
                          Uri.parse('$NON_AUTH_SERVER_URL/review/6'),
                          headers: {
                            "Accept": "application/json",
                            "Authorization": "Bearer ${TokenHive().accessToken!}"
                          },
                        );


                        print("${response.body} ${response.statusCode}");


                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) =>
                              StoreMainScreen(
                                  store: storeNotifier.value!,
                                reviews: [],
                              ),
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          border: Border.all(
                            width: 2,
                            color: Colors.teal.shade200,
                          ),
                          color: Colors.teal.shade50,
                        ),
                        child: storeNotifier.value != null
                            ? StoreTile(store: storeNotifier.value!) : null,
                      ),
                    ),
                  ),
                ],
              );
            }

            return Container();
          }
      ),
      // floatingActionButton: FloatingActionButton(
      //   // todo: 에러 처리 할 수도 있음
      //   onPressed: widget.isUserVerified
      //       ? () async {
      //     Navigator.push(context, MaterialPageRoute(
      //       builder: (_) => StoreSearchScreen(),
      //     ));
      //   }
      //       : null,
      //   child: Icon(Icons.add),
      //   backgroundColor: widget.isUserVerified
      //       ? Colors.blue
      //       : Colors.grey,
      // ),
    );
  }

  Widget _userAccountSection(BuildContext context) {
    if (isUserVerified) {
      return UserAccountsDrawerHeader(
        accountName: Text('닉네임'),
        accountEmail: Text('example@naver.com'),
        currentAccountPicture: const CircleAvatar(
          backgroundImage: AssetImage('assets/images/pukka.png'),
        ),
        decoration: BoxDecoration(
          color: THEME_COLOR,
        ),
      );
    }

    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height / 5,
      color: THEME_COLOR,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => LogInScreen(),
                ));
              },
              child: Text('로그인', textAlign: TextAlign.center,),
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => SignInSelectScreen(),
                ));
              },
              child: Text('회원가입', textAlign: TextAlign.center,),
            ),
          ],
        ),
      ),
    );
  }
}
