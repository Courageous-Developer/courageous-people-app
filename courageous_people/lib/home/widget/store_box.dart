import 'package:courageous_people/model/store_data.dart';
import 'package:courageous_people/store/screen/store_main_screen.dart';
import 'package:flutter/material.dart';

class StoreBox extends StatelessWidget {
  final StoreData? store;

  const StoreBox({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(store == null) return SizedBox(width: 0);
    print(store!.imageUrl);

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
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 25, top: 15, bottom: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            store!.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Colors.grey.shade900,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            store!.address,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.height / 4 - 90,
                height: MediaQuery.of(context).size.height / 4 - 90,
                padding: EdgeInsets.all(15),
                child: store!.imageUrl.length != 0
                    ? ClipRRect(child: Image.network(store!.imageUrl[0]))
                    :
                Container(
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.grey.shade400),
                  ),
                  child: Center(
                    child: Text(
                      'No Image',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
