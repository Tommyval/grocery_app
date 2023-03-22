import 'package:flutter/material.dart';
import 'package:grocery_app/services/utils.dart';

class EmptyProductWidget extends StatelessWidget {
  const EmptyProductWidget({Key? key, required this.errorMessage})
      : super(key: key);
  final String errorMessage;
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Image.asset('assets/images/box.png'),
            ),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: color, fontSize: 40, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
