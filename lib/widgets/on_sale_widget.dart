import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Providers/cart_provider.dart';
import 'package:grocery_app/Providers/wishlist_provider.dart';
import 'package:grocery_app/const/firebase_consts.dart';
import 'package:grocery_app/inner_screen/product_screen.dart';
import 'package:grocery_app/models/product_model.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/heart_btn.dart';
import 'package:grocery_app/widgets/price_widget.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

import '../Providers/viewed_provider.dart';

class OnSaleWidget extends StatefulWidget {
  const OnSaleWidget({Key? key}) : super(key: key);

  @override
  State<OnSaleWidget> createState() => _OnSaleWidgetState();
}

class _OnSaleWidgetState extends State<OnSaleWidget> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final theme = Utils(context).getTheme;
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    bool isInCart = cartProvider.getCarItems.containsKey(productModel.id);
    final wishListProvider = Provider.of<WishListProvider>(context);
    bool? isInWishList =
        wishListProvider.getWishListItems.containsKey(productModel.id);
    final viewedProdProvider = Provider.of<ViewedProvider>(context);
    return Material(
      color: Theme.of(context).cardColor.withOpacity(0.9),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          viewedProdProvider.addProductToHistory(productModel.id);
          Navigator.pushNamed(context, ProductScreen.routeName,
              arguments: productModel.id);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FancyShimmerImage(
                    imageUrl: productModel.imageUrl,
                    height: size.width * 0.22,
                    width: size.width * 0.22,
                    boxFit: BoxFit.fill,
                  ),
                  Column(
                    children: [
                      TextWidget(
                        text: productModel.isPiece ? '1 piece' : '1kg',
                        colors: color,
                        fontsize: 22,
                        isTitle: true,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: isInCart
                                ? null
                                : () async {
                                    final User? user = authInstance.currentUser;
                                    // print('user id is $user!.uid');
                                    if (user == null) {
                                      GlobalMethods.errorDialog(
                                          context: context,
                                          subTitle:
                                              'No user found, please log in');
                                      return;
                                    }
                                    await GlobalMethods.addToCart(
                                        productId: productModel.id,
                                        quantity: 1,
                                        context: context);
                                    await cartProvider.fetchCart();
                                    // cartProvider.addProductToCart(
                                    //     productId: productModel.id,
                                    //     quantity: 1);
                                  },
                            child: Icon(
                              isInCart ? IconlyBold.bag2 : IconlyLight.bag2,
                              size: 22,
                              color: isInCart ? Colors.green : color,
                            ),
                          ),
                          HeartBtn(
                            productId: productModel.id,
                            isInWishList: isInWishList,
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
              PriceWidget(
                  isOnSale: productModel.isOnSale,
                  price: productModel.price,
                  salePrice: productModel.salePrice,
                  textPrice: '1'),
              const SizedBox(
                height: 5,
              ),
              TextWidget(
                text: productModel.title,
                colors: color,
                fontsize: 16,
                isTitle: true,
              ),
              const SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
//  FancyShimmerImage(
//                       imageUrl: 'https://i.ibb.co/F0s3FHQ/Apricots.png',
//                       height: size.width * 0.22,
//                       width: size.width * 0.22,
//                       boxFit: BoxFit.fill,
//                     ),
//  'https://www.shutterstock.com/image-photo/apricots-apricot-isolate-slice-on-260nw-1808542792.jpg'