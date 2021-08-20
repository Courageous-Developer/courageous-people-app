import 'package:flutter/material.dart';
import '../constants.dart';
import '../widget/transparent_app_bar.dart';

class StoreMainScreen extends StatelessWidget {
  const StoreMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: THEME_COLOR,
      appBar: TransparentAppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
          child: Stack(
            children: [
              Container(
                child: Column(
                  children: [
                    Flexible(child: Container(color: Colors.transparent), flex: 2),
                    Flexible(child: Container(color: Colors.white), flex: 1),
                    Flexible(child: Container(
                      child: StoreTabWidget(),
                      color: Colors.white,
                    ), flex: 3),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.height/3,
                margin: EdgeInsets.fromLTRB(10, MediaQuery.of(context).size.height/9 - kToolbarHeight, 10, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: StoreIntrodectionWidget(),
              )
            ],
          )
      ),
    );
  }
}

class StoreIntrodectionWidget extends StatelessWidget {
  const StoreIntrodectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('소개'),
    );
  }
}

class StoreTabWidget extends StatelessWidget {
  const StoreTabWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('탭'),
    );
  }
}
