import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  TextWidget(
      {Key? key,
      required this.text,
      required this.colors,
      required this.fontsize,
      this.maxLines = 10,
      this.isTitle = false})
      : super(key: key);
  final String text;
  final Color colors;
  final double fontsize;
  bool isTitle;
  int maxLines = 10;
  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fontsize,
          fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
          color: colors,
        ));
  }
}
