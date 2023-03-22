import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/inner_screen/product_screen.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/text_widgets.dart';

class OrdersWidget extends StatelessWidget {
  const OrdersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return ListTile(
      subtitle: const Text('Paid: \$12.8'),
      onTap: () {
        GlobalMethods.navigateTo(
            context: context, routeName: ProductScreen.routeName);
      },
      leading: FancyShimmerImage(
        width: size.width * 0.2,
        imageUrl:
            'https://www.shutterstock.com/image-photo/apricots-apricot-isolate-slice-on-260nw-1808542792.jpg',
        boxFit: BoxFit.fill,
      ),
      title: TextWidget(text: 'title', colors: color, fontsize: 18),
      trailing: TextWidget(text: '03/03/2021', colors: color, fontsize: 18),
    );
  }
}
