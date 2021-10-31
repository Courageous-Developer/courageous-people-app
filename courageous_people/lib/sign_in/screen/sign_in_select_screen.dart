import 'package:flutter/material.dart';
import 'sign_in_screen.dart';

class SignInSelectScreen extends StatelessWidget {
  const SignInSelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          '회원가입',
          style: TextStyle(color: Colors.black),
        ),
        leading: Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _selectBox(
              right: 60,
              bottom: 20,
              padding: EdgeInsets.only(
                top: 80, bottom: 40, left: 30, right: 30,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SignInScreen(managerFlag: 2),
                  ),
                );
              },
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '사장님으로 회원가입',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30
                        ),
                      ),
                      Text('사장님으로 회원가입'),
                    ],
                  ),
                ],
              ),
            ),
            _selectBox(
              right: 60,
              bottom: 60,
              padding: EdgeInsets.only(
                top: 40, bottom: 80, left: 30, right: 30,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SignInScreen(managerFlag: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectBox({
    required EdgeInsetsGeometry padding,
    required double right,
    required double bottom,
    required void Function()? onTap,
    Widget? child,
  }) {
    return Expanded(
      child: Stack(
        children: [
          Padding(
            padding: padding,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.lightGreen.shade100,
                  border: Border.all(width: 0.2, color: Colors.grey.shade500),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      offset: const Offset(2.4, 2.4),
                    ),
                  ],
                ),
                child: child,
              ),
            ),
          ),
          Positioned(
            right: right,
            bottom: bottom,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green.shade200,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}







// Center(
// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Container(
// child: GestureDetector(
// onTap: () => _onTap(context, 2), //ToDo:회원가입 화면 전환
// child: Stack(
// children: [
// Container(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(15),
// border: Border.all(color:Colors.lightGreenAccent,width: 5)
// ),
// height: 230,
// width: 190,
// ),
// Positioned.fill(
// bottom: 27,
// child: Align(alignment: Alignment.bottomCenter,
// child: Text('가게회원',
// style: TextStyle(
// fontSize: 22,
// fontWeight: FontWeight.bold
// ),
//
// ),
// )
// ),
// Image.asset('assets/images/store.png',width: 190,),
// ],
// ),
// ),
// ),
// SizedBox(width: 10),
// Container(
// child: GestureDetector(
// onTap: () => _onTap(context, 1),//ToDo:회원가입 화면 전환
// child: Stack(
// children: [
// Container(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(15),
// border: Border.all(color:Colors.lightGreenAccent,width: 5),
// ),
// height: 230,
// width: 190,
// ),
// Positioned.fill(
// bottom: 27,
// child: Align(alignment: Alignment.bottomCenter,
// child: Text('일반회원',
// style: TextStyle(
// fontSize: 22,
// fontWeight: FontWeight.bold
// ),
// ),
// )
// ),
// Image.asset('assets/images/container.png', width: 190),
// ],
// ),
// ),
// ),
// ],
// ),
// ),