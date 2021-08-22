import 'package:courageous_people/review/widget/review_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'log_in/log_In_screen.dart';
import 'sign_in/sign_in_screen.dart';
import 'sign_in/sign_in_select_screen.dart';
import 'store/screen/store_add_screen.dart';
import 'store/screen/store_main_screen.dart';
import 'widget/transparent_app_bar.dart';

import 'widget/store_list_tile.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountSection(),
            ListTile(
              leading: Icon(
                  Icons.home,
                  color: Colors.indigo[600]
              ),
              title: Text(
                '홈',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              title: Text(
                '찜',
                style: TextStyle(
                    fontWeight: FontWeight.bold
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
      body: GestureDetector(
        onTap: () => showModalBottomSheet(
          context: context, builder: (_) => MainPageBottomSheet(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => StoreAddScreen(),
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class MainPageBottomSheet extends StatelessWidget {
  const MainPageBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => StoreMainScreen()));
      },
      child: StoreListTile(),
    );
  }
}

class UserAccountSection extends StatelessWidget {
  const UserAccountSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(1>0) {
      return Container(
        height: MediaQuery.of(context).size.height/5,
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
