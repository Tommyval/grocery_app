import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Providers/product_provider.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/empty_products_widget.dart';
import 'package:grocery_app/widgets/on_sale_widget.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';

class OnSaleScreen extends StatelessWidget {
  static const routeName = '/OnSaleScreen';
  const OnSaleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    List<ProductModel> productsOnsale = productProvider.getOnSaleProducts;
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              IconlyLight.arrowLeft2,
              color: color,
            ),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: TextWidget(
            text: 'Product on sale',
            colors: color,
            fontsize: 24,
            isTitle: true,
          ),
        ),
        body: productsOnsale.isEmpty
            ? const EmptyProductWidget(
                errorMessage: 'No products on sale yet! stay tuned',
              )
            : GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                //padding: EdgeInsets.zero,
                childAspectRatio: size.width / (size.height * 0.55),
                children: List.generate(productsOnsale.length, (index) {
                  return ChangeNotifierProvider.value(
                      value: productsOnsale[index],
                      child: const OnSaleWidget());
                }),
              ));
  }
}
