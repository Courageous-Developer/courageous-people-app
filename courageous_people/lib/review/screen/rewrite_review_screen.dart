import 'dart:typed_data';

import 'package:courageous_people/common/constants.dart';
import 'package:courageous_people/model/menu_data.dart';
import 'package:courageous_people/review/cubit/review_cubit.dart';
import 'package:courageous_people/review/cubit/review_state.dart';
import 'package:courageous_people/utils/show_alert_dialog.dart';
import 'package:courageous_people/widget/my_drop_down.dart';
import 'package:courageous_people/widget/transparent_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RewriteReviewScreen extends HookWidget {
  const RewriteReviewScreen({
    Key? key,
    required this.reviewId,
    required this.storeId,
    required this.userId,
    required this.menuList,
    required this.initialMenuText,
    required this.initialVolume,
    required this.initialComment,
    required this.initialImageByte,
  }) : super(key: key);

  final int reviewId;
  final int storeId;
  final int userId;
  final List<MenuData> menuList;
  final String initialMenuText;
  final String initialVolume;
  final String initialComment;
  final Uint8List? initialImageByte;

  @override
  Widget build(BuildContext context) {
    final reviewCubit = context.read<ReviewCubit>();

    final menuNotifier = useState(initialMenuText);
    final containerNotifier = useState(initialVolume);
    final commentNotifier = useState(initialComment);
    final pictureNotifier = useState(initialImageByte);
    final picker = ImagePicker();

    return BlocListener<ReviewCubit, ReviewState>(
      bloc: reviewCubit,
      listener: (context, state) async {
        if(state is ReviewRewrittenState) {
          await showAlertDialog(
            context: context,
            title: state.message,
          );

          Navigator.pop(context, true);
        }

        if(state is ReviewRewriteErrorState) {
          await showAlertDialog(
            context: context,
            title: state.message,
          );

          Navigator.pop(context, false);
        }
      },
      child: Scaffold(
        appBar: TransparentAppBar(title: '수정하기'),
        body: _Body(
          menuList: menuList,
          storeId: storeId,
          userId: userId,
          initialMenuText: initialMenuText,
          initialVolume: initialVolume,
          initialComment: initialComment,
          pictureToByte: initialImageByte,
          onMenuChanged: (menu) => menuNotifier.value = menu,
          onContainerChanged: (container) => containerNotifier.value = container,
          onCommentChanged: (comment) => commentNotifier.value = comment,
          onPhotoTap: () async {
            final picture = await picker.pickImage(source: ImageSource.gallery);
            if(picture != null) {
              pictureNotifier.value = await picture.readAsBytes();
            }
          },
          onSubmit: () async {
            final reviewCommitted = await showAlertDialog(
              context: context,
              title: '리뷰를 수정하시겠습니까?',
              onCancel: () => Navigator.pop(context, false),
            );

            if(!reviewCommitted!)  return;

            print(reviewId);
            print(storeId);
            print(userId);

            await reviewCubit.rewriteReview(
              reviewId: reviewId,
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
  final List<MenuData> menuList;
  final int storeId;
  final int userId;
  final Uint8List? pictureToByte;
  String initialMenuText;
  final String initialVolume;
  final String initialComment;
  final void Function() onSubmit;
  final void Function(String) onMenuChanged;
  final void Function(String) onContainerChanged;
  final void Function(String) onCommentChanged;
  final void Function() onPhotoTap;

  _Body({
    Key? key,
    required this.menuList,
    required this.storeId,
    required this.userId,
    required this.initialMenuText,
    required this.initialVolume,
    required this.initialComment,
    required this.onSubmit,
    required this.onMenuChanged,
    required this.onContainerChanged,
    required this.onCommentChanged,
    required this.onPhotoTap,
    this.pictureToByte,
  }) : super(key: key);

  bool menuExist(List<String> menuList, String menu) {
    return menuList.indexOf(menu) != -1;
  }

  @override
  Widget build(BuildContext context) {
    final menuTitleList = menuList.map((menu) => menu.title).toList();

    final selectedMenuStringNotifier = useState(initialMenuText);

    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _menuField(
                    selected: menuExist(
                      menuTitleList,
                      selectedMenuStringNotifier.value,
                    )
                        ? selectedMenuStringNotifier.value : '직접 입력',
                    onSelectedChanged: (selected) {
                      selectedMenuStringNotifier.value = selected;
                    }
                ),
                SizedBox(height: 25),
                _containerField(),
                SizedBox(height: 25),
                _reviewSection(onCommentChanged: onCommentChanged),
                SizedBox(height: 25),
                Text('사진'),
                SizedBox(height: 5),
                _pictureSection(),
                SizedBox(height: kToolbarHeight),
              ],
            ),
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
      onTap: onPhotoTap,
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
          height: kToolbarHeight,
          color: THEME_COLOR,
          child: Center(
            child:
            Text(
              '수정하기',
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

  Widget _menuField({
    required String selected,
    required void Function(String) onSelectedChanged,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyDropDown(
          title: selected,
          contents: [
            ...(menuList.map((menuData) => menuData.title).toList()),
            '직접 입력'
          ],
          onSelect: (container) {
            onSelectedChanged(container);
            onMenuChanged(container);
          },
        ),
        if(selected == '직접 입력')
          TextFormField(
            initialValue: initialMenuText,
            onChanged: (menu) => onMenuChanged(menu),
            decoration: InputDecoration(
              hintText: '메뉴를 입력해주세요',
            ),
          ),
      ],
    );
  }

  Widget _containerField() {
    return MyDropDown(
      title: initialVolume,
      widgetContents: _containerList,
      onSelect: (container) => onContainerChanged(container),
    );
  }

  Widget _reviewSection({required void Function(String) onCommentChanged}) {
    return TextFormField(
      maxLines: 7,
      onChanged: (menu) => onCommentChanged(menu),
      cursorWidth: 1.0,
      initialValue: initialComment,
      autofocus: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8),
        hintText: '리뷰를 작성하세요',
        hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
        fillColor: Colors.grey.shade200,
        filled: true,
        focusedBorder: InputBorder.none,
        focusColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  List<String> get _containerList {
    return ['300ml 미만', '300ml - 500ml', '500ml - 1L', '1L 이상'];
  }
}