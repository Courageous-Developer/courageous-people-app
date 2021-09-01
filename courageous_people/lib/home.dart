import 'package:courageous_people/review/widget/review_tile.dart';
import 'package:courageous_people/store/cubit/store_cubit.dart';
import 'package:courageous_people/store/cubit/store_repository.dart';
import 'package:courageous_people/store/cubit/store_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'constants.dart';
import 'log_in/log_In_screen.dart';
import 'model/store_data.dart';
import 'sign_in/sign_in_select_screen.dart';
import 'store/screen/store_add_screen.dart';
import 'store/screen/store_main_screen.dart';
import 'widget/transparent_app_bar.dart';
import 'classes.dart';
import 'widget/store_list_tile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String myLocation;
  late List<Store> storeList;

  @override
  void initState() {
    super.initState();

    myLocation = '내 위치';
    storeList = [];
  }

  @override
  Widget build(BuildContext context) {
    final storeCubit = StoreCubit.of(context);
    storeCubit.init();

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
        title: "서울시 강동구 둔촌동",
        actions: [
          IconButton(
            onPressed: () {
              // todo: 내 위치로 오기
            },
            icon: Icon(Icons.location_on_outlined),
          ),
        ],
      ),
      body: BlocConsumer<StoreCubit, StoreState>(
        bloc: storeCubit,
        listener: (context, state) async {
          if(state is StoreInitialState)  await storeCubit.getStores();
        },
        builder: (_, state) {
          if(state is StoreLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if(state is StoreLoadedState) {
            storeList = state.storeList;

            return NaverMap(
              initLocationTrackingMode: LocationTrackingMode.Follow,
              onMapTap: (latLng) async {
                print(latLng);
              },
              markers: storeList.map(
                      (store) {
                    print(store.toString());
                    return Marker(
                      markerId: '',
                      position: LatLng(store.latitude, store.longitude),
                      onMarkerTab: (a, b) {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) =>
                              MainPageBottomSheet(
                                  store: store
                              ),
                        );
                      }
                    );
                  }
              ).toList(),
            );
          }

          return Container();
          // return Center(
          //   child: ElevatedButton(
          //     onPressed: () async { await storeCubit.getStores(); },
          //     child: Text(''),
          //   ),
          // return GestureDetector(
          //     onTap: () => showModalBottomSheet(
          //   context: context,
          //   builder: (_) => MainPageBottomSheet(
          //     store: Store('아빠가 만든 스파게티', '무슨무슨길 18', '12345-6789', 'assets/images/pukka.png'),
          //   ),
          // ),
          // child: NaverMap(
          // initLocationTrackingMode: LocationTrackingMode.Face,
          // onMapTap: (latLng) {
          // print(latLng);
          // },
          // markers: [
          // Marker(
          // markerId: 'aa',
          // position: LatLng(37.53251998113193, 127.14683754900574),
          // // icon: _marker(context, 'assets/images/container.png'),
          // ),
          // ],
          // );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => StoreAddScreen(),
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _userAccountSection(BuildContext context) {
    if (1 > 0) {
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
}

class MainPageBottomSheet extends StatelessWidget {
  final Store store;
  const MainPageBottomSheet({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => StoreMainScreen(store: store)));
      },
      child: StoreListTile(
        store: store,
        farFormMe: 2.8,
      ),
    );
  }
}
