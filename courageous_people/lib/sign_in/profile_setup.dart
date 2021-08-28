import 'package:flutter/material.dart';

class ProfileSetup extends StatelessWidget {
  const ProfileSetup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width*0.9,
          child: Column(
            children: [
              SizedBox(height: 20,),
              Container(
                width: 190.0,
                height: 190.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.asset('assets/images/profile.png').image
                  ),
                ),
              ),
              SizedBox(height: 10,),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(width:100,height: 40),
                child: ElevatedButton(
                    onPressed: ()=> {},
                    child: Text('사진 선택')),
              ),
              SizedBox(height: 30,),
              Text('이름'),
              TextField(),
              SizedBox(height: 10,),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(width:100,height: 40),
                child: ElevatedButton(
                    onPressed: ()=> {},
                    child: Text('확인')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
