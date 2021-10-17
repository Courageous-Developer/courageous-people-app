import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final void Function()? onPressed;
  final IconData iconData;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final String? menuTitle;
  final Color? backgroundColor;
  final double? size;
  final String? heroTag;
  final Color? iconColor;
  final double? borderRadiusValue;
  final EdgeInsetsGeometry? margin;

  const MenuButton({
    Key? key,
    required this.onPressed,
    required this.iconData,
    this.left,
    this.right,
    this.top,
    this.bottom,
    this.heroTag,
    this.menuTitle,
    this.size = 40,
    this.backgroundColor,
    this.iconColor = Colors.white,
    this.borderRadiusValue,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin!,
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadiusValue ?? 0),
                color: backgroundColor,
              ),
              child: Icon(iconData, color: iconColor, size: size!-14),
            ),
            const SizedBox(width: 5),
            if(menuTitle != null) Text(
              menuTitle!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}













// Positioned(
// left: left,
// right: right,
// top: top,
// bottom: bottom,
// child: Row(
// mainAxisSize: MainAxisSize.min,
// children: [
// FloatingActionButton(
// onPressed: onPressed,
// backgroundColor: backgroundColor ?? Colors.grey.shade700,
// elevation: 0,
// mini: isMini,
// heroTag: heroTag,
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(borderRadiusValue ?? 0),
// ),
// child: Icon(iconData, color: iconColor ?? Colors.white),
// ),
// Container(),
// const SizedBox(width: 5),
// if(menuTitle != null) Text(
// menuTitle!,
// style: TextStyle(fontWeight: FontWeight.bold),
// ),
// ],
// ),
// );