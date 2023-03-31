import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Providers/cart_provider.dart';
import 'package:grocery_app/const/firebase_consts.dart';
import 'package:grocery_app/inner_screen/product_screen.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

import '../Providers/product_provider.dart';
import '../models/viewed_model.dart';

class ViewedRecentlyWidget extends StatefulWidget {
  const ViewedRecentlyWidget({Key? key}) : super(key: key);

  @override
  State<ViewedRecentlyWidget> createState() => _ViewedRecentlyWidgetState();
}

class _ViewedRecentlyWidgetState extends State<ViewedRecentlyWidget> {
  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productModel = Provider.of<ProductProvider>(context);
    final viewedProdModel = Provider.of<ViewedModel>(context);
    final getCurrProduct = productModel.findProdById(viewedProdModel.productId);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    bool? isInCart = cartProvider.getCarItems.containsKey(getCurrProduct.id);
    return GestureDetector(
      onTap: () {
        GlobalMethods.navigateTo(
            context: context, routeName: ProductScreen.routeName);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FancyShimmerImage(
            imageUrl: getCurrProduct.imageUrl,
            boxFit: BoxFit.fill,
            height: size.width * 0.27,
            width: size.width * 0.25,
          ),
          const SizedBox(
            width: 12,
          ),
          Column(
            children: [
              TextWidget(
                text: getCurrProduct.title,
                colors: color,
                fontsize: 24,
                isTitle: true,
              ),
              const SizedBox(
                height: 12,
              ),
              TextWidget(
                text: '\$${usedPrice.toStringAsFixed(2)}',
                colors: color,
                fontsize: 20,
                isTitle: false,
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Material(
              borderRadius: BorderRadius.circular(12),
              color: Colors.green,
              child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: isInCart
                      ? null
                      : () async {
                          final User? user = authInstance.currentUser;
                          // print('user id is $user!.uid');
                          if (user == null) {
                            GlobalMethods.errorDialog(
                                context: context,
                                subTitle: 'No user found, please log in');
                            return;
                          }
                          await GlobalMethods.addToCart(
                              productId: getCurrProduct.id,
                              quantity: 1,
                              context: context);
                          await cartProvider.fetchCart();
                          // cartProvider.addProductToCart(
                          //     productId: getCurrProduct.id, quantity: 1);
                        },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      isInCart ? Icons.check : IconlyBold.plus,
                      color: Colors.white,
                      size: 20,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
