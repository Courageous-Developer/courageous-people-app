import 'package:flutter/material.dart';

Size? getWidgetSizeByKey(GlobalKey key) {
  if(key.currentContext != null) {
    final renderBox = key.currentContext!.findRenderObject() as RenderBox;

    return renderBox.size;
  }

  return null;
}

Offset? getWidgetPositionByKey(GlobalKey key) {
  if(key.currentContext != null) {
    final renderBox = key.currentContext!.findRenderObject() as RenderBox;
    
    return renderBox.localToGlobal(Offset.zero);
  }

  return null;
}