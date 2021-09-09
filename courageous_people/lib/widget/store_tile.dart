import 'package:courageous_people/model/store_data.dart';
import 'package:flutter/material.dart';

class StoreTile extends StatelessWidget {
  final Stores store;

  const StoreTile({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.height/4-110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.all(width: 2),
              color: Colors.white,
            ),
            child: Stack(
              children: [
                Center(child: Icon(Icons.camera_alt_outlined)),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "No Image",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13
                    ),
                  ),
                ),
              ],
            ),
            // child: Image.asset(
            //   'assets/images/pukka.png',
            // ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        store.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        store.intro ?? '한 줄 소개가 없습니다',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}