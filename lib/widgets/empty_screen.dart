import 'package:flutter/material.dart';
import 'package:grocery_app/inner_screen/feeds_screen.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/text_widgets.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen(
      {Key? key,
      required this.imagePath,
      required this.title,
      required this.subtitle,
      required this.buttonText})
      : super(key: key);
  final String imagePath, title, subtitle, buttonText;

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final themeState = Utils(context).getTheme;
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          Image.asset(
            imagePath,
            width: double.infinity,
            height: size.height * 0.4,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Whoops!',
            style: TextStyle(
                color: Colors.red, fontSize: 40, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 20,
          ),
          TextWidget(text: title, colors: Colors.cyan, fontsize: 20),
          const SizedBox(
            height: 20,
          ),
          TextWidget(text: subtitle, colors: Colors.cyan, fontsize: 20),
          SizedBox(
            height: size.height * 0.1,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(
                  color: color,
                ),
              ),
              // onPrimary: color,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            onPressed: () {
              GlobalMethods.navigateTo(
                  context: context, routeName: FeedScreen.routeName);
            },
            child: TextWidget(
              text: buttonText,
              fontsize: 20,
              colors: themeState ? Colors.grey.shade300 : Colors.grey.shade800,
              isTitle: true,
            ),
          ),
        ],
      )),
    );
  }
}
