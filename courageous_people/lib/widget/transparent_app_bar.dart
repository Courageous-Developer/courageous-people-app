import 'package:flutter/material.dart';

class TransparentAppBar extends StatelessWidget with PreferredSizeWidget {
  String? title;   // current location where user is at
  Widget? leading;
  List<Widget>? actions;
  double? elevation;


  TransparentAppBar({
    Key? key,
    this.title,
    this.leading,
    this.actions,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title ?? '',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      leading: leading,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      actions: actions,
      backgroundColor: Colors.transparent,
      elevation: elevation ?? 0,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
