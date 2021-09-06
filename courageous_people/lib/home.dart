import 'package:courageous_people/common/hive/token_hive.dart';
import 'package:courageous_people/store/cubit/store_cubit.dart';
import 'package:courageous_people/store/cubit/store_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'common/constants.dart';
import 'log_in/log_In_screen.dart';
import 'model/store_data.dart';
import 'sign_in/sign_in_select_screen.dart';
import 'register/screen/store_search_screen.dart';
import 'store/screen/store_main_screen.dart';
import 'widget/transparent_app_bar.dart';
import 'widget/store_list_tile.dart';

class Home extends StatefulWidget {
  // todo: naver 지도 처음에 안 뜨는 오류 수정
  // todo: marker 하나만 나오는 오류 수정
  const Home({Key? key}) : super(key: key);


  @override
  _HomeState createState() => _HomeState();
}

// todo: store cubit blocklistener initial state를 반환하지 않는 문제 수정
class _HomeState extends State<Home> {
  late List<Store> storeList;
  String myCurrentLocation = '';

  @override
  void initState() {
    super.initState();

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
                Icons.
                favorite,
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
          if (state is StoreLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is StoreLoadedState) {
            storeList = state.storeList;

            return NaverMap(
              initLocationTrackingMode: LocationTrackingMode.Follow,
              onMapTap: (latLng) async {
                print(latLng);
              },
              markers: storeList.map(
                      (store) =>
                      Marker(
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
                      )
              ).toList(),
            );
          }

          return Container();
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => StoreSearchScreen(),
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
  //
  // Future<bool> _isAccessTokenAuthenticated(String? accessToken) async {
  //   if(accessToken == null) return false;
  //
  //   await Future.delayed(Duration(seconds: 1));
  //   // todo: 여기서 http로 액세스 토큰 검증 로직 실행
  //
  //   if()
  //
  //   return true;
  // }
}

class MainPageBottomSheet extends StatelessWidget {
  final Store store;
  const MainPageBottomSheet({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => StoreMainScreen(store: store),
        ));
      },
      child: StoreListTile(
        store: store,
        farFormMe: 2.8,
      ),
    );
  }
}
