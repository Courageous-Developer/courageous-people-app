import 'dart:math';

import 'package:courageous_people/common/constants.dart';
import 'package:courageous_people/common/hive/user_hive.dart';
import 'package:courageous_people/review/cubit/review_cubit.dart';
import 'package:courageous_people/review/cubit/review_repository.dart';
import 'package:courageous_people/review/cubit/review_state.dart';
import 'package:courageous_people/utils/http_client.dart';
import 'package:courageous_people/utils/show_alert_dialog.dart';
import 'package:courageous_people/widget/my_input_form.dart';
import 'package:courageous_people/widget/transparent_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/src/provider.dart';

class AddReviewScreen extends HookWidget {
  final int storeId;
  final int userId;

  const AddReviewScreen({
    Key? key,
    required this.storeId,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reviewCubit = context.read<ReviewCubit>();

    final menuNotifier = useState<String?>(null);
    final containerNotifier = useState<String?>(null);
    final commentNotifier = useState('');
    final pictureNotifier = useState<Image?>(null);
    final picker = ImagePicker();

    return BlocListener<ReviewCubit, ReviewState>(
      bloc: reviewCubit,
      listener: (context, state) async {
        if(state is AddingReviewSuccessState) {
          await showAlertDialog(
            context: context,
            title: state.message,
          );

          Navigator.pop(context, true);
        }

        if(state is ReviewErrorState) {
          await showAlertDialog(
            context: context,
            title: state.message,
          );

          Navigator.pop(context, false);
        }
      },
      child: Scaffold(
        appBar: TransparentAppBar(title: '리뷰 등록'),
        body: _Body(
          storeId: storeId,
          userId: userId,
          picture: pictureNotifier.value,
          onMenuChanged: (menu) => menuNotifier.value = menu,
          onContainerChanged: (container) => containerNotifier.value = container,
          onCommentChanged: (comment) => commentNotifier.value = comment,
          onPhotoTab: () async {
            final picture = await picker.pickImage(source: ImageSource.gallery);
            if(picture != null)
              pictureNotifier.value = Image.memory(await picture.readAsBytes());
          },
          onSubmit: () async {
            await reviewCubit.addReview(
              storeId: storeId,
              userId: userId,
              comment: commentNotifier.value,
            );
          },
        ),
      ),
    );
  }
}

class _Body extends HookWidget {
  final int storeId;
  final int userId;
  final void Function() onSubmit;
  final void Function(String) onMenuChanged;
  final void Function(String) onContainerChanged;
  final void Function(String) onCommentChanged;
  final void Function() onPhotoTab;
  final Image? picture;

  const _Body({
    Key? key,
    required this.storeId,
    required this.userId,
    required this.onSubmit,
    required this.onMenuChanged,
    required this.onContainerChanged,
    required this.onCommentChanged,
    required this.onPhotoTab,
    this.picture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              MyInputForm(
                title: Text('메뉴'),
                onChanged: onMenuChanged,
              ),
              SizedBox(height: 25),
              Text('사진'),
              SizedBox(height: 5),
              _pictureSection(picture: picture),
              SizedBox(height: 25),
              MyInputForm(
                title: Text('용기'),
                onChanged: onContainerChanged,
              ),
              SizedBox(height: 25),
              MyInputForm(
                title: Text('리뷰'),
                onChanged: onCommentChanged,
              ),
            ],
          ),
        ),
        _bottomButton(
          context: context,
          onSubmit: onSubmit,
        ),
      ],
    );
  }

  Widget _pictureSection({
    required Image? picture,
  }) {
    return GestureDetector(
      onTap: onPhotoTab,
      child: Container(
        padding: picture != null
            ? null
            : EdgeInsets.all(15),
        width: 200,
        height: 200,
        decoration: picture != null
            ? null
            : BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 1),
          color: Colors.white,
        ),
        child: picture != null
            ? picture
            : _nonPictureForm(),
      ),
    );

  }

  Widget _nonPictureForm() {
    return Stack(
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

  Widget _bottomButton({
    required BuildContext context,
    required void Function() onSubmit,
  }) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: onSubmit,
        child: Container(
          height: 50,
          color: THEME_COLOR,
          child: Center(
            child:
            Text(
              '등록하기',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}









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
