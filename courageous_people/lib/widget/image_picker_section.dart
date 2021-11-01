import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerSection extends StatelessWidget {
  ImagePickerSection({
    Key? key,
    this.size,
    required this.onPhotoTap,
  }) : super(key: key);

  final _picker = ImagePicker();
  final int? size;
  final void Function(List<XFile>?) onPhotoTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()  async {
        final files = await _picker.pickMultiImage();

        onPhotoTap(files);
      },
      child: Container(
        padding: EdgeInsets.all(15),
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 1),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Center(child: Icon(Icons.camera_alt_outlined, size: 80)),
            Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                "No Image",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
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
        ),
      ),
    );
  }
}
