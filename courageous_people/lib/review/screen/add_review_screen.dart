import 'dart:typed_data';

import 'package:courageous_people/common/constants.dart';
import 'package:courageous_people/review/cubit/review_cubit.dart';
import 'package:courageous_people/review/cubit/review_state.dart';
import 'package:courageous_people/service/token_service.dart';
import 'package:courageous_people/utils/http_client.dart';
import 'package:courageous_people/utils/show_alert_dialog.dart';
import 'package:courageous_people/widget/my_input_form.dart';
import 'package:courageous_people/widget/transparent_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

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
    final pictureNotifier = useState<Uint8List?>(null);
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
          pictureToByte: pictureNotifier.value,
          onMenuChanged: (menu) => menuNotifier.value = menu,
          onContainerChanged: (container) => containerNotifier.value = container,
          onCommentChanged: (comment) => commentNotifier.value = comment,
          onPhotoTab: () async {
            final picture = await picker.pickImage(source: ImageSource.gallery);
            if(picture != null) {
              pictureNotifier.value = await picture.readAsBytes();
            }
          },
          onSubmit: () async {
            await reviewCubit.addReview(
              storeId: storeId,
              userId: userId,
              comment: commentNotifier.value,
              pictureToByte: pictureNotifier.value,
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
  final Uint8List? pictureToByte;

  const _Body({
    Key? key,
    required this.storeId,
    required this.userId,
    required this.onSubmit,
    required this.onMenuChanged,
    required this.onContainerChanged,
    required this.onCommentChanged,
    required this.onPhotoTab,
    this.pictureToByte,
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
              _pictureSection(),
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

  Widget _pictureSection() {
    return GestureDetector(
      onTap: onPhotoTab,
      child: Container(
        padding: pictureToByte != null
            ? null
            : EdgeInsets.all(15),
        width: 200,
        height: 200,
        decoration: pictureToByte != null
            ? null
            : BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 1),
          color: Colors.white,
        ),
        child: pictureToByte != null
            ? Image.memory(pictureToByte!)
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