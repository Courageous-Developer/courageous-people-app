import 'package:courageous_people/model/store_data.dart';
import 'package:flutter/material.dart';

class StoreListTile extends StatelessWidget {
  late String name;
  late String location;
  late String businessNumber;
  late String imageUri;
  final double farFormMe;

  StoreListTile({Key? key, required Store store, required this.farFormMe}) : super(key: key) {
    this.name = store.name;
    this.location = store.location;
    this.businessNumber = store.businessNumber;
    this.imageUri = store.imageUri;
  }

  @override
  Widget build(BuildContext context) {
    final SCREEN_WIDTH = MediaQuery.of(context).size.width;

    return Container(
      height: SCREEN_WIDTH/4,
      child: Row(
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Image.asset(
                  'assets/images/pukka.png',
                ),
              ),
            ),
            flex: 1,
          ),
          Flexible(
            child: Column(
              children: [
                Flexible(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: Size.infinite.width,
                    height: Size.infinite.height,
                    child: Text('아빠가 만든 스파게티  ',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: Size.infinite.width,
                    height: Size.infinite.height,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: Size.infinite.width,
                    height: Size.infinite.height,
                    child: Text('내 위치로부터 3.0km',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            flex: 3,
          ),
        ],
      ),
    );
  }
}