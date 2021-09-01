import 'package:courageous_people/constants.dart';
import 'package:flutter/material.dart';
import '../../widget/transparent_app_bar.dart';
import 'package:http/http.dart' as http;

class StoreAddScreen extends StatefulWidget {
  const StoreAddScreen({Key? key}) : super(key: key);

  @override
  _StoreAddScreenState createState() => _StoreAddScreenState();
}

class _StoreAddScreenState extends State<StoreAddScreen> {
  late String crawledStoreData;

  @override
  void initState() {
    super.initState();

    crawledStoreData = 'crawledStoreData';
  }

  @override
  Widget build(BuildContext context) {
    final storeSearchInputController = TextEditingController();

    return Scaffold(
      appBar: TransparentAppBar(
        title: '가게 추가하기',
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Text('가게 찾기'),
          TextField(
            controller: storeSearchInputController,
          ),
          ElevatedButton(
            onPressed: () async {
              String url = 'https://openapi.naver.com/v1/search/local.json';
              String queryString =
                  "?query=${storeSearchInputController.text}&display=10&start=1&sort=random";
              http.Response response = await http.get(
                Uri.parse('$url$queryString'),
                headers: {
                  "X-Naver-Client-Id": NAVER_API_CLINET_ID,
                  "X-Naver-Client-Secret": NAVER_API_CLINET_SECRET
                },
              );

              print(response.body);

              setState(() {
                crawledStoreData = response.body;
              });
            },
            child: Text('검색'),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(child: Text(crawledStoreData)),
            ),
          ),
        ],
      ),
    );
  }
}
