import 'package:courageous_people/utils/http_client.dart';
import 'package:courageous_people/widget/my_input_form.dart';
import 'package:courageous_people/widget/transparent_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

// class ReviewBox extends StatelessWidget {
//   const ReviewBox({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final reviewController = TextEditingController();
//     final containerController = TextEditingController();
//     final tagController = TextEditingController();
//
//     return Scaffold(
//       body: Container(
//         width: MediaQuery.of(context).size.width*0.8,
//         height: MediaQuery.of(context).size.height*0.8,
//         child: Column(
//           children: [
//             MyInputForm(
//               title: Text('리뷰'),
//               controller: reviewController,
//             ),
//             MyInputForm(controller: containerController),
//             MyInputForm(controller: tagController),
//           ],
//         ),
//       ),
//     );
//   }
// }


class ReviewBox extends HookWidget {
  const ReviewBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reviewController = TextEditingController();
    final containerController = TextEditingController();
    final tagController = TextEditingController();

    final pictureNotifier = useState<String?>(null);
    final _picker = ImagePicker();

    return Scaffold(
      appBar: TransparentAppBar(
        title: '리뷰 등록',
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                MyInputForm(
                  title: Text('메뉴'),
                  controller: tagController,
                ),
                SizedBox(height: 25),
                Text('사진'),
                SizedBox(height: 5,),
                GestureDetector(
                  onTap: () async {
                    final picture = await _picker.pickImage(source: ImageSource.gallery);
                    pictureNotifier.value = "assets/images/chicken.jpg";
                  },
                  child: Container(
                    padding: pictureNotifier.value != null
                        ? null
                        : EdgeInsets.all(15),
                    width: 200,
                    height: 200,
                    decoration: pictureNotifier.value != null
                        ? null
                        : BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(width: 1),
                      color: Colors.white,
                    ),
                    child:  pictureNotifier.value != null
                        ? Image.asset(pictureNotifier.value!)
                        : _nonPictureForm(),
                  ),
                ),
                SizedBox(height: 25),
                MyInputForm(
                  title: Text('용기 정보'),
                  // hintText: "ML",
                  controller: reviewController,
                ),
                SizedBox(height: 25),
                MyInputForm(
                  title: Text('리뷰'),
                  controller: containerController,
                ),
                SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () async {
                    final response = await httpRequestWithToken(
                        requestType: 'POST',
                        path: '/board/review',
                      body: {
                          'user': 1,
                        'store': 2,
                      },
                    );

                    print(response.statusCode);
                    print(response.body);
                  },
                  child: Text('리뷰 등록'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _nonPictureForm() => Stack(
    children: [
      Center(child: Icon(Icons.camera_alt_outlined, size: 80)),
      Container(
        alignment: Alignment.bottomCenter,
        child: Text(
          "No Image",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25
          ),
        ),
      ),
      Container(
        alignment: Alignment.topCenter,
        child: Text(
          "사진을 추가하려면 터치하세요",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    ],
  );
}
// import 'package:courageous_people/widget/my_rating_bar.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class ReviewBox extends StatelessWidget {
//   const ReviewBox({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('리뷰 작성'),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Center(
//               child: Container(
//                 width: MediaQuery.of(context).size.width*0.9,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.fromLTRB(0,12,0,12),
//                       height: 5 * 24.0,
//                       child: TextField(
//                         maxLines: 5,
//                         decoration: InputDecoration(
//                           hintText: "가게에 대한 리뷰를 작성해 주세요",
//                           fillColor: Colors.grey[200],
//                           filled: true,
//                         ),
//                       ),
//                     ),//리뷰 내용
//                     SizedBox(height: 20,),
//
//                     Row(
//                       children: [
//                         InkWell(
//                           onTap: () {},//이미지 선택
//                           splashColor: Colors.white.withOpacity(0.2),
//                           child: Ink(
//                             height:  MediaQuery.of(context).size.height*0.12,
//                             width: MediaQuery.of(context).size.height*0.12,
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                 image: AssetImage('assets/images/picture.png'),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           height: MediaQuery.of(context).size.height*0.12,
//                           width: MediaQuery.of(context).size.width*0.9-MediaQuery.of(context).size.height*0.12,
//                           color: Colors.white,
//                         )
//                       ],
//                     ),
//                     Container(
//                       margin: EdgeInsets.fromLTRB(0,12,0,12),
//                       height: 2 * 24.0,
//                       child: TextField(
//                         maxLines: 2,
//                         decoration: InputDecoration(
//                           hintText: "드신 메뉴와 사용하신 포장 용기를 적어 주세요.",
//                           fillColor: Colors.grey[200],
//                           filled: true,
//                         ),
//                       ),
//                     ),//태그 쉼표로 구분
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
//                       child: Text('메뉴와 용기는 각각 쉼표로 구분해서 적어주세요.\nex)후라이드 치킨,1L용기',
//                         style: TextStyle(color: Colors.black38),),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             alignment: Alignment.bottomRight,
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: FloatingActionButton(
//                 onPressed: (){},//ToDo:리뷰 등록(서버로 전달)
//                 child: Icon(Icons.add),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
