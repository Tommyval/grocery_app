import 'package:flutter/material.dart';
import 'package:grocery_app/models/grid_models.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/categories_screen.dart';
import 'package:grocery_app/widgets/text_widgets.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final utils = Utils(context);
    Color color = utils.color;
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).backgroundColor,
          title: TextWidget(
            text: 'Categories',
            colors: color,
            fontsize: 24,
            isTitle: true,
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 245 / 250,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: List.generate(6, (index) {
            return CategoroesWidget(
              info: demoFields[index],
            );
          }),
        ),
      ),
    );
  }
}
