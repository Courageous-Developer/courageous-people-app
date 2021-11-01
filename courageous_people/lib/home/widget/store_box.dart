import 'package:courageous_people/model/store_data.dart';
import 'package:courageous_people/store/screen/store_main_screen.dart';
import 'package:flutter/material.dart';

class StoreBox extends StatelessWidget {
  final StoreData? store;

  const StoreBox({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(store == null) return SizedBox(width: 0);

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => StoreMainScreen(store: store!),
        ));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(
          30,
          MediaQuery.of(context).size.height * 0.68 + 50,
          30,
          MediaQuery.of(context).size.height * 0.07,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          border: Border.all(
            width: 2,
            color: Colors.teal.shade200,
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                store!.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                store!.address,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            color: Colors.black,
                            width: 80,
                          ),
                        ],
                      ),
                    ),
                    Divider(thickness: 0.5, color: Colors.grey.shade900),
                    Icon(Icons.favorite, color: Colors.red, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
