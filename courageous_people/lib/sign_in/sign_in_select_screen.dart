import 'package:flutter/material.dart';
import 'sign_in_screen.dart';
//
// class SignInSelectScreen extends StatelessWidget {
//   const SignInSelectScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Flexible(
//             child: Container(
//               padding: EdgeInsets.all(30),
//               child: GestureDetector(
//                 onTap: _onTap(context, true),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(30)),
//                     border: Border.all(
//                       color: Colors.green,
//                       width: 10,
//                     ),
//                   ),
//                   alignment: Alignment.center,
//                   width: Size.infinite.width,
//                   height: Size.infinite.height,
//                   child: Text(
//                     '손님 회원',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.normal,
//                       decoration: TextDecoration.none,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Flexible(
//             child: Container(
//               padding: EdgeInsets.all(30),
//               child: GestureDetector(
//                 onTap: _onTap(context, false),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(30)),
//                     border: Border.all(
//                       color: Colors.green,
//                       width: 10,
//                     ),
//                   ),
//                   alignment: Alignment.center,
//                   width: Size.infinite.width,
//                   height: Size.infinite.height,
//                   child: Text(
//                     '가게 회원',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.normal,
//                       decoration: TextDecoration.none,
//                     ),
//                   ),
//                 ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class SignInSelectScreen extends StatelessWidget {
  const SignInSelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text('회원가입'),
      ),
      body: Center(
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: GestureDetector(
                onTap: () => _onTap(context, 2),//ToDo:회원가입 화면 전환
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color:Colors.lightGreenAccent,width: 5)
                      ),
                      height: 230,
                      width: 190,
                    ),
                    Positioned.fill(
                        bottom: 27,
                        child: Align(alignment: Alignment.bottomCenter,
                          child: Text('가게회원',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                            ),

                          ),
                        )
                    ),
                    Image.asset('assets/images/store.png',width: 190,),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            Container(
              child: GestureDetector(
                onTap: () => _onTap(context, 1),//ToDo:회원가입 화면 전환
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color:Colors.lightGreenAccent,width: 5)
                      ),
                      height: 230,
                      width: 190,
                    ),
                    Positioned.fill(
                        bottom: 27,
                        child: Align(alignment: Alignment.bottomCenter,
                          child: Text('일반회원',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        )
                    ),
                    Image.asset('assets/images/container.png', width: 190),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onTap(BuildContext context, int managerFlag) {
    try {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => SignInScreen(manageType: managerFlag),
      ));
    } catch ( Exception ) {};
  }
}