import 'package:flutter/material.dart';
import 'package:courageous_people/sign_in/sign_in_select_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<LogInScreen> {
  final login_selection=<bool>[true,false];
  bool? _autologin=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width*0.9,
          child: Column(
            children: [
              Image.asset('assets/images/logo.png'),//logo
              // ToggleButtons(
              //   isSelected: login_selection,
              //   onPressed: (index) {setState(() {
              //     if(index==0){
              //       login_selection[0]=true;
              //       login_selection[1]=false;
              //     }else{
              //       login_selection[1]=true;
              //       login_selection[0]=false;
              //     }
              //   });
              //   },
              //   children: [
              //     SizedBox(
              //       width: 150,
              //       child: Center(child: Text('개인회원'),),
              //     ),
              //     SizedBox(
              //       width: 150,
              //       child: Center(child: Text('점주'),),
              //     ),
              //   ],
              // ),
              SizedBox(height: 30,),
              TextField(
                decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(),
                  ),
                  hintText: 'email',
                ),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(),
                  ),
                  hintText: 'Password',
                ),
              ),
              SizedBox(
                child:
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                    onPressed: ()=>{},
                    child: Text('로그인')
                ),
                width:MediaQuery.of(context).size.width*0.9 ,
                height:45,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,3,5,0),
                      child: Checkbox(
                        value: _autologin,
                        onChanged: (value) {setState(() {
                          _autologin=value;
                        });
                        },
                      ),
                    ),
                  ),
                  Text('자동 로그인',style: TextStyle(color: Colors.grey[700]),),
                  Spacer(),
                  TextButton(onPressed: (){},
                      child: Text(
                        '아이디찾기',
                        style: TextStyle(color: Colors.grey[700]),)
                  ),
                  Text(' | ',style: TextStyle(color: Colors.grey[700]),),
                  TextButton(onPressed: (){},
                      child: Text(
                        '비밀번호찾기',
                        style: TextStyle(color: Colors.grey[700]),)
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(children: <Widget>[
                Expanded(
                  child: new Container(
                      margin: const EdgeInsets.only(right: 10.0),
                      child: Divider(
                        color: Colors.grey[350],
                      )),
                ),
                Text("소셜 로그인",
                  style: TextStyle(
                      color: Colors.grey[350]
                  ),),
                Expanded(
                  child: new Container(
                    margin: const EdgeInsets.only(left: 10,),
                    child: Divider(
                      color: Colors.grey[350],
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: ()=>{},
                    child: SizedBox(
                        height: 48,
                        child: Image.asset('assets/images/kakao_circular.png')
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: CircleBorder(),
                    ),
                  ),
                  ElevatedButton(onPressed: ()=>{},
                    child: SizedBox(
                        height: 48,
                        child: Image.asset('assets/images/naver_circular.png')
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: CircleBorder(),
                    ),
                  ),
                  ElevatedButton(onPressed: ()=>{},
                    child: SizedBox(
                        height: 48,
                        child: Image.asset('assets/images/google_circular.png')
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: CircleBorder(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 80,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('처음 사용하신다면?'),
                  TextButton(
                    onPressed: (){
                      Navigator.push(
                          context,MaterialPageRoute(builder: (context)=>SignInSelectScreen())
                      );
                    },
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                        color: Color.fromRGBO(6,69,173,1.0),
                        //decoration: TextDecoration.underline
                      ),
                    ),
                  ),
                ],
              ),
            ],

          ),
        ),
      ),
    );
  }
}