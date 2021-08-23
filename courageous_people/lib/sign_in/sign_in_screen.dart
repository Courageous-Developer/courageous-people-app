import 'package:flutter/material.dart';
import 'package:courageous_people/sign_in/profile_setup.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('회원가입'),elevation: 0,),
        body: GestureDetector(
            onTap:(){FocusScope.of(context).unfocus();},
            child:SingleChildScrollView(
              child:Center(
                child: Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20,),
                        Text(' 이메일'),
                        SizedBox(
                            height: 3
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.9,
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 15
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero)
                              ,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(),
                              ),
                              hintText: 'Email',
                              helperText:'현재 사용하고 계신 이메일을 입력해주세요.',
                            ),
                          ),
                        ),
                        SizedBox(
                            height: 3
                        ),
                        Text('비밀번호'),
                        SizedBox(
                            height: 3
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.9,
                          child: TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                              border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(),
                              ),
                              hintText: 'Password',
                              helperText: '비밀번호는 영문,숫자를 조합하여 8~16자리로 입력해주세요.',
                            ),
                          ),
                        ),

                        Text('비밀번호 확인'),
                        SizedBox(
                            height: 3
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.9,
                          child: TextField(
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
                              helperText: '확인을 위해 비밀번호를 다시 입력해주세요.',
                            ),
                          ),
                        ),
                        SizedBox(
                            height:15
                        ),
                        SizedBox(
                          child:
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                              onPressed: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>ProfileSetup()));
                              },
                              child: Text('다음으로')
                          ),
                          width:MediaQuery.of(context).size.width*0.9 ,
                          height:45,
                        ),
                        SizedBox(height: 30,),
                        Row(children: <Widget>[
                          Expanded(
                            child: new Container(
                                margin: const EdgeInsets.only(right: 10.0),
                                child: Divider(
                                  color: Colors.black54,
                                )),
                          ),
                          Text("간편하게 회원가입",
                            style: TextStyle(
                              color: Colors.black54,
                            ),),
                          Expanded(
                            child: new Container(
                                margin: const EdgeInsets.only(left: 10,),
                                child: Divider(
                                  color: Colors.black54,
                                )),
                          ),
                        ]),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(onPressed: ()=>{},
                              child: SizedBox(
                                  height: 48,
                                  child: Image.asset('image/kakao_circular.png')
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: CircleBorder(),
                              ),
                            ),
                            ElevatedButton(onPressed: ()=>{},
                              child: SizedBox(
                                  height: 48,
                                  child: Image.asset('image/naver_circular.png')
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: CircleBorder(),
                              ),
                            ),
                            ElevatedButton(onPressed: ()=>{},
                              child: SizedBox(
                                  height: 48,
                                  child: Image.asset('image/google_circular.png')
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: CircleBorder(),
                              ),
                            ),
                          ],
                        ),
                      ]
                  ),
                ),
              ),
            )
        )
    );
  }
}