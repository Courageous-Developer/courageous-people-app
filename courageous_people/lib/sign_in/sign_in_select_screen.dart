import 'package:flutter/material.dart';
import 'sign_in_screen.dart';

class SignInSelectScreen extends StatelessWidget {
  const SignInSelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.all(30),
              child: GestureDetector(
                onTap: _onTap(context, true),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    border: Border.all(
                      color: Colors.green,
                      width: 10,
                    ),
                  ),
                  alignment: Alignment.center,
                  width: Size.infinite.width,
                  height: Size.infinite.height,
                  child: Text(
                    '손님 회원',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(30),
              child: GestureDetector(
                onTap: _onTap(context, false),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    border: Border.all(
                      color: Colors.green,
                      width: 10,
                    ),
                  ),
                  alignment: Alignment.center,
                  width: Size.infinite.width,
                  height: Size.infinite.height,
                  child: Text(
                    '가게 회원',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onTap(BuildContext context, bool isCustomer) {
    // try {
    //   Navigator.push(context, MaterialPageRoute(
    //     builder: (_) => SignInScreen(),
    //   ));
    // } catch ( Exception ) {};
  }
}
