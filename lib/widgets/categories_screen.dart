import 'package:flutter/material.dart';
import 'package:grocery_app/inner_screen/cat_screen.dart';
import 'package:grocery_app/models/grid_models.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

import '../provider/dark_theme_provider.dart';

class CategoroesWidget extends StatelessWidget {
  const CategoroesWidget({Key? key, required this.info}) : super(key: key);
  final Gridmodel info;
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color colors = themeState.getDarkTheme ? Colors.white : Colors.black;

    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, CategoryScreen.routeName,
            arguments: info.catText);
      },
      child: Container(
        decoration: BoxDecoration(
            color: info.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: info.color, width: 2)),
        child: Column(
          children: [
            Container(
              height: screenWidth * 0.3,
              width: screenWidth * 0.3,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(info.imgPath), fit: BoxFit.fill)),
            ),
            TextWidget(
              text: info.catText,
              colors: colors,
              fontsize: 20,
              isTitle: true,
            )
          ],
        ),
      ),
    );
  }
}
