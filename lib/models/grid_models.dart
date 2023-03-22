import 'package:flutter/material.dart';

class Gridmodel {
  final String imgPath, catText;
  Color color;

  Gridmodel(
      {required this.imgPath, required this.catText, required this.color});
}

List demoFields = [
  Gridmodel(
    imgPath: 'assets/images/cat/fruits.png',
    catText: 'Fruits',
    color: const Color(0xff53B175),
  ),
  Gridmodel(
    imgPath: 'assets/images/cat/veg.png',
    catText: 'Vegetables',
    color: const Color(0xffF8A44C),
  ),
  Gridmodel(
    imgPath: 'assets/images/cat/Spinach.png',
    catText: 'Herbs',
    color: const Color(0xffF7A593),
  ),
  Gridmodel(
    imgPath: 'assets/images/cat/nuts.png',
    catText: 'Nuts',
    color: const Color(0xffD3B0E0),
  ),
  Gridmodel(
    imgPath: 'assets/images/cat/spices.png',
    catText: 'Spices',
    color: const Color(0xffFDE598),
  ),
  Gridmodel(
    imgPath: 'assets/images/cat/grains.png',
    catText: 'Grains',
    color: const Color(0xffB7DFF5),
  )
];
