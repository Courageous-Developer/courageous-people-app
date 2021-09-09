import 'package:courageous_people/widget/my_input_form.dart';
import 'package:flutter/material.dart';

class ReviewBox extends StatelessWidget {
  const ReviewBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reviewController = TextEditingController();
    final containerController = TextEditingController();
    final tagController = TextEditingController();

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width*0.8,
        height: MediaQuery.of(context).size.height*0.8,
        child: Column(
          children: [
            MyInputForm(
              title: Text('리뷰'),
              controller: reviewController,
            ),
            MyInputForm(controller: containerController),
            MyInputForm(controller: tagController),
          ],
        ),
      ),
    );
  }
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
