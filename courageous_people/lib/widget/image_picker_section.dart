import 'dart:typed_data';

import 'package:courageous_people/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerSection extends HookWidget {
  ImagePickerSection({
    Key? key,
    this.size,
    required this.maxImageNumber,
    required this.onImageChanged,
  }) : super(key: key);

  final _picker = ImagePicker();

  final int maxImageNumber;
  final double? size;
  final void Function(List<Uint8List>) onImageChanged;

  @override
  Widget build(BuildContext context) {
    final imageSourceNotifier = useState<ImageSource?>(null);
    final imageByteListNotifier = useState<List<Uint8List>>([]);

    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            imageSourceNotifier.value = null;

            await showDialog(
              context: context,
              builder: (context) => SelectImagePickerDialog(
                onSelectImageSource: (imageSource) {
                  imageSourceNotifier.value = imageSource;
                },
              ),
            );

            if(imageSourceNotifier.value == null) return;

            imageByteListNotifier.value = await _onImagePicked(
              imageSourceNotifier.value!,
            );

            onImageChanged(imageByteListNotifier.value);
          },
          child: Container(
            padding: EdgeInsets.all(size == null ? 15 : size!/10),
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(width: 1),
              color: Colors.white,
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: size == null ? 80 : size!/2,
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "사진 등록",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size == null ? 10 : size!/8,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "${imageByteListNotifier.value.length}/$maxImageNumber",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size == null ? 10 : size!/8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 30),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: _imageWidgetList(
            imageByteList: imageByteListNotifier.value,
            removeImage: (index) {
              if(index < 0) return;

              var copiedList = imageByteListNotifier.value;
              copiedList.removeAt(index);
              imageByteListNotifier.value = [...copiedList];
            },
          ),
        ),
      ],
    );
  }

  Future<List<Uint8List>> _onImagePicked(ImageSource imageSource) async {
    List<Uint8List> imageByteList = [];

    if(imageSource == ImageSource.camera) {
      final image = await _picker.pickImage(source: imageSource);
      if(image == null) return [];

      imageByteList.add(await image.readAsBytes());

      return imageByteList;
    }

    final files = await _picker.pickMultiImage();
    if(files == null) return [];

    for(XFile image in files) {
      final index = files.indexOf(image);
      if(index >= maxImageNumber)  break;

      imageByteList.add(await image.readAsBytes());
    }

      return imageByteList;
  }

  List<Widget> _imageWidgetList({
    required List<Uint8List> imageByteList,
    required void Function(int) removeImage,
  }) {
    if(imageByteList.isEmpty) return [];

    return imageByteList.map(
          (imageByte) => _ImageWidget(
        index: imageByteList.indexOf(imageByte),
        size: size ?? 80,
        imageByte: imageByte,
        removeImage: (index) => removeImage(index),
      ),
    ).toList();
  }
}

class _ImageWidget extends StatelessWidget {
  const _ImageWidget({
    Key? key,
    required this.index,
    required this.size,
    required this.imageByte,
    required this.removeImage,
  }) : super(key: key);

  final int index;
  final double size;
  final Uint8List imageByte;
  final void Function(int) removeImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: EdgeInsets.only(right: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(child: Image.memory(imageByte)),
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () => removeImage(index),
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade900,
                ),
                child: Center(
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectImagePickerDialog extends StatelessWidget {
  SelectImagePickerDialog({
    Key? key,
    required this.onSelectImageSource,
  }) : super(key: key);

  final void Function(ImageSource) onSelectImageSource;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: THEME_COLOR,
                borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                '사진 선택',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _contentItem(
              imageSource: ImageSource.camera,
              title: '카메라로 촬영',
              icon: Icons.camera_alt_outlined,
              onTap: (imageSource) {
                onSelectImageSource(imageSource);
                Navigator.pop(context);
              },
            ),
            Divider(thickness: 1.5),
            _contentItem(
              imageSource: ImageSource.gallery,
              title: '갤러리에서 선택',
              icon: Icons.image_outlined,
              onTap: (imageSource) {
                onSelectImageSource(imageSource);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentItem({
    required ImageSource imageSource,
    required String title,
    required IconData icon,
    required void Function(ImageSource) onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(imageSource),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.grey.shade500),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

