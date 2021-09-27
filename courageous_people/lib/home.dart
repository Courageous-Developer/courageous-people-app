import 'package:courageous_people/log_out/cubit/log_out_cubit.dart';
import 'package:courageous_people/register/screen/store_add_screen.dart';
import 'package:courageous_people/store/cubit/store_cubit.dart';
import 'package:courageous_people/store/cubit/store_state.dart';
import 'package:courageous_people/utils/user_verification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

import 'common/constants.dart';
import 'log_in/log_In_screen.dart';
import 'model/store_data.dart';
import 'register/screen/store_search_screen.dart';
import 'sign_in/sign_in_select_screen.dart';
import 'store/screen/store_main_screen.dart';
import 'widget/store_tile.dart';
import 'utils/get_widget_information.dart';

class Home extends HookWidget {
  bool isUserVerified;      // 토큰 확인 / 자동 로그인
  List<Stores> storeList = [];    // 가게 리스트
  String myCurrentLocation = '';  // 내 현재 위치

  GlobalKey _menuIconKey = GlobalKey();

  // todo: naver 지도 처음에 안 뜨는 오류 수정
  // todo: marker 하나만 나오는 오류 수정
  Home({Key? key, required this.isUserVerified}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storeCubit = StoreCubit.of(context);
    final logOutCubit = LogOutCubit.of(context);

    // final isUserVerifiedNotifier = useState<bool>(isUserVerified);
    final storeNotifier = useState<Stores?>(null);  // 클릭해서 선택한 가게
    final markerNotifier = useState<List<Marker>>([]);
    late NaverMapController mapController;

    useEffect(() {}, [isUserVerified]);

    return Scaffold(
      body: Stack(
        children: [
          BlocListener(
            bloc: storeCubit,
            listener: (context, state) async {
              if(state is MapInitializeState) await storeCubit.getStores();
              if(state is StoreLoadedState) {
                final image = await OverlayImage.fromAssetImage(
                  assetName: 'assets/images/container.png',
                );
                storeList = state.storeList;

                markerNotifier.value = storeList.map(
                        (store) {
                      return Marker(
                        // center: LatLng(store.latitude, store.longitude),
                        // overlayId: 'store${store.id}',
                        // radius: 80,
                        markerId: 'store${store.id}',
                        position:  LatLng(store.latitude, store.longitude),
                        icon: image,
                        onMarkerTab: (a, b) {
                          storeNotifier.value = store;
                        },
                      );
                    }
                ).toList();
              }
            },
            child: NaverMap(
              initLocationTrackingMode: LocationTrackingMode.Follow,
              // locationButtonEnable: true,
              onMapCreated: (controller) {
                mapController = controller;
                storeCubit.getStores();
              },
              onMapTap: (latLng) {
                storeNotifier.value = null;
              },
              markers: markerNotifier.value,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
              storeNotifier.value != null
                  ? 30
                  :  MediaQuery.of(context).size.width - 30,
              MediaQuery.of(context).size.height*0.68,
              30,
              MediaQuery.of(context).size.height*0.07,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) =>
                      StoreMainScreen(
                        store: storeNotifier.value!,
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
                    ? StoreTile(store: storeNotifier.value!)
                    : null,
              ),
            ),
          ),
          Positioned(
            // left: 30.0,
            // top: 30.0,
            // child: FloatingActionButton(
            //   onPressed: () {},
            //   backgroundColor: isUserVerified ? Colors.black : Colors.pink,
            //   child: Icon(Icons.menu),
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   // child: MyStatefulWidget(),
            // ),
            left: 34,
            top: 40,
            child: _userSection(),
          ),
          Positioned(
            left: 34,
            top: 103,
            child: _menuListButton(
              icon: Icons.add,
              menuTitle: "가게 추가",
              backgroundColor: Colors.blue.shade300,
              heroTag: "registerStore",
              onPressed: () {
                print('asdf ${getWidgetSizeByKey(_menuIconKey)!.width}');
                print('asdf ${getWidgetSizeByKey(_menuIconKey)!.height}');

                isUserVerified
                    ? Navigator.push(context, MaterialPageRoute(
                  builder: (_) => StoreSearchScreen(),
                ))
                    : showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('로그인이 필요합니다.'),
                    content: Image.asset('assets/images/pukka.png'),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);

                          isUserVerified = await Navigator.push(context, MaterialPageRoute(
                            builder: (_) => LogInScreen(),
                          ));
                        },
                        child: Text('로그인'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('취소'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 34,
            top: 168,
            child: _menuListButton(
              icon: Icons.favorite,
              menuTitle: "내가 찜한 가게",
              backgroundColor: Colors.pink.shade300,
              heroTag: "favorite",
              onPressed: () {},
            ),
          ),
          Positioned(
            left: 34,
            top: 233,
            child: _menuListButton(
              icon: Icons.store,
              menuTitle: "가까운 가게",
              backgroundColor: Colors.teal.shade300,
              heroTag: "near",
              onPressed: () {},
            ),
          ),
          isUserVerified
              ? Positioned(
            left: 34,
            top: 298,
            child: _menuListButton(
              icon: Icons.sensor_door,
              menuTitle: "로그아웃",
              backgroundColor: Colors.grey.shade500,
              heroTag: "logout",
              onPressed: () async {
                // todo: 로그아웃 시 새로고침
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('로그아웃합니다'),
                    content: null,
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);

                          await logOutCubit.logOut();
                          // if(!logOutResult) showDialog(context: context, builder: builder);
                        },
                        child: Text('확인'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('취소'),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
              : SizedBox(height: 0),
        ],
      ),
    );
  }

  Widget _userAccountSection(BuildContext context, bool isUserVerified) {
    if (isUserVerified) {
      return UserAccountsDrawerHeader(
        accountName: Text(''),
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
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(
                  builder: (_) => LogInScreen(),
                ));
              },
              child: Text('로그인', textAlign: TextAlign.center),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => SignInSelectScreen(),
                ));
              },
              child: Text('회원가입', textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuListButton({
    required IconData icon,
    required String menuTitle,
    required Color backgroundColor,
    required String heroTag,
    void Function()? onPressed,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.small(
          onPressed: onPressed,
          backgroundColor: backgroundColor,
          child: Icon(icon),
          shape: CircleBorder(),
          heroTag: heroTag,
          // child: MyStatefulWidget(),
        ),
        SizedBox(width: 5),
        Text(
          menuTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _userSection() {
    return Container(
      width: 150,
      // height: 45,
      // height: Size.fromHeight(),
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
            key: _menuIconKey,
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

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
// class _MyStatefulWidgetState extends State<MyStatefulWidget> with SingleTickerProviderStateMixin {
//   late final AnimationController _controller = AnimationController(
//     duration: const Duration(milliseconds: 400),
//     vsync: this,
//   )..repeat(reverse: true);
//
//   late final Animation<RelativeRect> _offsetAnimation = RelativeRectTween(
//     begin: RelativeRect.fromLTRB(0, 50, 0, 0),
//     end: RelativeRect.fromLTRB(0, 0, 0, 50),
//   ).animate(CurvedAnimation(
//     parent: _controller,
//     curve: Curves.ease,
//   ));
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PositionedTransition(
//       rect: _offsetAnimation,
//       child: const Padding(
//         padding: EdgeInsets.all(8.0),
//         child: FlutterLogo(size: 150.0),
//       ),
//     );
//   }
// }

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















//
// /// This is the stateful widget that the main application instantiates.
// class MyStatefulWidget extends StatefulWidget {
//   const MyStatefulWidget({Key? key}) : super(key: key);
//
//   @override
//   State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
// }
//
// /// This is the private State class that goes with MyStatefulWidget.
// /// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
// class _MyStatefulWidgetState extends State<MyStatefulWidget>
//     with TickerProviderStateMixin {
//   late final AnimationController _controller = AnimationController(
//     duration: const Duration(milliseconds: 500),
//     vsync: this,
//   )..repeat(reverse: true);
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const double smallLogo = 10;
//     const double bigLogo = 20;
//
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         final Size biggest = constraints.biggest;
//         return Stack(
//           children: <Widget>[
//             PositionedTransition(
//               rect: RelativeRectTween(
//                 begin: RelativeRect.fromSize(
//                     const Rect.fromLTWH(0, 0, smallLogo, smallLogo), biggest),
//                 end: RelativeRect.fromSize(
//                     Rect.fromLTWH(biggest.width - bigLogo,
//                         biggest.height - bigLogo, bigLogo, bigLogo),
//                     biggest),
//               ).animate(CurvedAnimation(
//                 parent: _controller,
//                 curve: Curves.ease,
//               )),
//               child: const Padding(
//                   padding: EdgeInsets.all(8), child: FlutterLogo()),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }










// drawer: Drawer(
//   child: ListView(
//     children: [
//       _userAccountSection(context, isUserVerified),
//       ListTile(
//         leading: Icon(
//           Icons.favorite,
//           color: Colors.red,
//         ),
//         title: Text(
//           '찜한 가게',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       ListTile(
//         leading: Icon(
//           Icons.settings,
//           color: Colors.grey,
//         ),
//         title: Text(
//           '설정',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     ],
//   ),
// ),
// appBar: TransparentAppBar(
//   title: myCurrentLocation,
//   actions: [
//     TextButton(
//       onPressed: isUserVerified
//           ? () async {
//         Navigator.push(context, MaterialPageRoute(
//           builder: (_) => StoreSearchScreen(),
//         ));
//       }
//           : null,
//       child: Text('가게 추가'),
//     ),
//   ],
// ),
