import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {


  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: Color.fromRGBO(196,246,130,1),
          body: Center(
            child: Container(
              width: MediaQuery.of(context).size.width*0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.25,
                  ),
                  Image.asset(
                      'assets/images/logo.png'
                  ),
                ],
              ),
            ),
          ),
        );
  }
}

