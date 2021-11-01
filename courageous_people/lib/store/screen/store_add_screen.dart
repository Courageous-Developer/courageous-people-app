import 'dart:typed_data';

import 'package:courageous_people/common/constants.dart';
import 'package:courageous_people/common/hive/user_hive.dart';
import 'package:courageous_people/model/menu_data.dart';
import 'package:courageous_people/store/cubit/store_cubit.dart';
import 'package:courageous_people/store/cubit/store_state.dart';
import 'package:courageous_people/widget/my_input_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../home/screen/home.dart';

class StoreAddScreen extends HookWidget {
  final Map<String, dynamic> storeData;
  final managerFlag;

  StoreAddScreen({
    Key? key,
    required this.storeData,
    required this.managerFlag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storeCubit = StoreCubit.of(context);
    final userId = UserHive().userId;

    final commentNotifier = useState('');
    final storeImageByteNotifier = useState<Uint8List?>(null);

    final menuWidgetListNotifier = useState<List<_MenuWidget>>([]);

    return BlocListener<StoreCubit, StoreState>(
      bloc: storeCubit,
      listener: (context, state) async {
        print(state);
        if (state is AddingStoreSuccessState) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => Home()),
                (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('가게 등록'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                _storeInformationSection,
                SizedBox(height: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '가게 대표사진 등록',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 5),
                    _ImagePickerWidget(
                      size: MediaQuery.of(context).size.width*0.4,
                      onImageChanged: (imageByte) {
                        storeImageByteNotifier.value = imageByte;
                      },
                    ),
                  ],
                ),
                SizedBox(height: 40),
                _managerSection(
                  addMenuSection: () {
                    final newMenuList = [
                      ...menuWidgetListNotifier.value,
                      _MenuWidget(
                        index: menuWidgetListNotifier.value.length,
                        removeMenuSection: (index) {
                          var copiedList = menuWidgetListNotifier.value;
                          menuWidgetListNotifier.value = [];

                          copiedList.removeAt(index);

                          for (int index=0; index<copiedList.length; index++) {
                            final newMenuName = copiedList[index].menuName;
                            final newMenuPrice = copiedList[index].menuPrice;
                            final newMenuImage = copiedList[index].menuImageByte;
                            final newRemove = copiedList[index].removeMenuSection;

                            final newMenuWidget = _MenuWidget(
                              index: index,
                              removeMenuSection: newRemove,
                              menuInitialText: newMenuName,
                              priceInitialText: newMenuPrice,
                            )
                              ..imageByte = newMenuImage;

                            copiedList[index].setIndex(index);
                            copiedList[index].menuInitialText = copiedList[index].menuName;
                            copiedList[index].priceInitialText = copiedList[index].menuPrice;

                            print(copiedList[index].menuName);
                            print(copiedList[index].index);

                            menuWidgetListNotifier.value.add(copiedList[index]);
                          }

                          for (int index=0; index<copiedList.length; index++) {
                            print(copiedList[index].menuName);
                            print(copiedList[index].menuInitialText);
                          }

                          menuWidgetListNotifier.value = copiedList;
                        },
                      ),
                    ];

                    menuWidgetListNotifier.value = [];
                    menuWidgetListNotifier.value = newMenuList;
                  },
                  menus: menuWidgetListNotifier.value,
                ),
                SizedBox(height: 40),
                _bottomButton(
                  context: context,
                  onTap: () async {
                    await storeCubit.addStore(
                      storeData['title'],
                      storeData['address'],
                      commentNotifier.value,
                      storeImageByteNotifier.value,
                      storeData['latitude'],
                      storeData['longitude'],
                      userId,
                      managerFlag,
                      menuWidgetListNotifier.value.map(
                            (menuWidget) =>
                        {
                          'name': menuWidget.menuName,
                          'price': menuWidget.menuPrice,
                          'imageByte': menuWidget.imageByte,
                        },
                      ).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _storeInformationSection {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fixedInputBox(
            title: '가게 이름',
            content: storeData['title'],
          ),
          SizedBox(height: 25),
          _fixedInputBox(
            title: '카테고리',
            content: storeData['category'],
          ),
          SizedBox(height: 25),
          _fixedInputBox(
            title: '주소',
            content: storeData['address'],
          ),
        ],
      ),
    );
  }

  Widget _bottomButton({
    required BuildContext context,
    required void Function()? onTap,
  }) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: THEME_COLOR,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            '등록하기',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _managerSection({
    required void Function() addMenuSection,
    required List<_MenuWidget> menus,
  }) {
    return Column(
      children: [
        MyInputForm(
          title: Text(
            '한 줄 소개',
            style: TextStyle(fontSize: 12),
          ),
        ),
        SizedBox(height: 15),
        _menuSection(
          addMenuSection: addMenuSection,
          menus: menus,
        ),
      ],
    );
  }

  Widget _menuSection({
    required void Function()? addMenuSection,
    required List<_MenuWidget> menus,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '메뉴 등록',
          style: TextStyle(fontSize: 12),
        ),
        ...menus,
        GestureDetector(
          onTap: addMenuSection,
          child: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.green.shade300,
            ),
            child: Text(
              '+',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _fixedInputBox({
    required String title,
    required String content,
  }) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 12),
        ),
        SizedBox(height: 5),
        TextFormField(
          initialValue: content,
          enabled: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[300],
            contentPadding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 15,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
        ),
      ],
    );
  }

  List<_SendMenuData> toMenuDataList(List<_MenuWidget> menuWidgetList) {
    if(menuWidgetList.length == 0)  return [];

    return menuWidgetList.map(
          (menuWidget) => _SendMenuData(
        menuWidget.menuName,
        menuWidget.menuPrice,
        menuWidget.menuImageByte,
      ),
    ).toList();
  }
}

class _MenuWidget extends StatelessWidget {
  _MenuWidget({
    Key? key,
    required this.index,
    required this.removeMenuSection,
    this.menuInitialText,
    this.priceInitialText,
  }) : super(key: key);

  final void Function(int) removeMenuSection;
  int index;
  String? menuInitialText;
  String? priceInitialText;

  String name = '';
  String price = '';
  Uint8List? imageByte;

  @override
  Widget build(BuildContext context) {
    print(menuInitialText);
    print(priceInitialText);

    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => removeMenuSection(index),
            icon: Icon(Icons.cancel),
          ),
          SizedBox(height: 3),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: Colors.grey.shade400),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _ImagePickerWidget(
                  size: 90,
                  onImageChanged: (imageByte) => this.imageByte = imageByte,
                ),
                SizedBox(width: 20),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('이름'),
                        SizedBox(width: 10),
                        Container(
                          width: 30,
                          child: TextFormField(
                            initialValue: menuInitialText ?? '',
                            onChanged: (name) => this.name = name,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('가격'),
                        SizedBox(width: 10),
                        Container(
                          width: 30,
                          child: TextFormField(
                            initialValue: priceInitialText ?? '',
                            onChanged: (price) => this.price = price,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get menuName => this.name;
  String get menuPrice => this.price;
  Uint8List? get menuImageByte => this.imageByte;
  int get menuIndex => this.index;

  void setIndex(int index) => this.index = index;
}

class _ImagePickerWidget extends HookWidget {
  _ImagePickerWidget({
    Key? key,
    required this.size,
    this.onImageChanged,
  }) : super(key: key);

  final double size;
  Uint8List? selectedImageByte;
  void Function(Uint8List?)? onImageChanged;

  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();
    final selectedImageByteNotifier = useState<Uint8List?>(selectedImageByte);

    return GestureDetector(
      onTap: () async {
        final image = await picker.pickImage(
          source: ImageSource.gallery,
        );

        if (image == null) return;
        selectedImageByteNotifier.value = await image.readAsBytes();

        onImageChanged == null
            ? selectedImageByte = selectedImageByteNotifier.value
            : onImageChanged!(selectedImageByteNotifier.value);
      },
      child: selectedImageByteNotifier.value == null
          ?
      Container(
        padding: EdgeInsets.all(10),
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: Colors.grey.shade400),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Text(
              "No Image",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            Center(
              child: Icon(
                Icons.camera_alt_outlined,
                color: Colors.grey,
                size: size / 2,
              ),
            ),
          ],
        ),
      )
          :
      Container(
        width: size,
        height:  size,
        child: Image.memory(selectedImageByteNotifier.value!),
      ),
    );
  }

  Uint8List? get imageByte => this.imageByte;
}

class _SendMenuData {
  final String name;
  final String price;
  final Uint8List? imageByte;

  const _SendMenuData(this.name, this.price, this.imageByte);

  String get menuName => this.name;
  String get menuPrice => this.price;
  Uint8List? get storeImageByte => this.imageByte;
}

