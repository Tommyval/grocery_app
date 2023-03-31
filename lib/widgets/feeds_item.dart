import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({Key? key}) : super(key: key);
  @override
  State<FeedsWidget> createState() => _FeedsItemsState();
}

class _FeedsItemsState extends State<FeedsWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor.withOpacity(0.9),
        child: InkWell(
          onTap: () {
            viewedProdProvider.addProductToHistory(productModel.id);
            // GlobalMethods.navigateTo(
            //     context: context, routeName: ProductScreen.routeName);
            Navigator.pushNamed(context, ProductScreen.routeName,
                arguments: productModel.id);
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              FancyShimmerImage(
                  imageUrl: productModel.imageUrl,
                  boxFit: BoxFit.fill,
                  height: size.width * 0.21,
                  width: size.width * 0.2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: TextWidget(
                      maxLines: 1,
                      text: productModel.title,
                      colors: color,
                      fontsize: 18,
                      isTitle: true,
                    ),
                  ),
                  Flexible(
                      flex: 1,
                      child: HeartBtn(
                        productId: productModel.id,
                        isInWishList: isInWishList,
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PriceWidget(
                      isOnSale: productModel.isOnSale,
                      price: productModel.price,
                      salePrice: productModel.salePrice,
                      textPrice: _quantityTextController.text,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 3,
                      child: Row(
                        children: [
                          FittedBox(
                            child: TextWidget(
                              text: productModel.isPiece ? 'piece' : 'kg',
                              colors: color,
                              fontsize: 18,
                              isTitle: true,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Flexible(
                              flex: 2,
                              child: SizedBox(
                                  height: 30,
                                  width: 35,
                                  child: TextFormField(
                                      controller: _quantityTextController,
                                      keyboardType: TextInputType.number,
                                      style:
                                          TextStyle(color: color, fontSize: 18),
                                      maxLines: 1,
                                      enabled: true,
                                      onChanged: (valueee) {
                                        setState(() {});
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp('[0-9.]'),
                                        ),
                                      ])))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: isInCart
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
                          // if (_isInCart) {
                          //   return;
                          // }
                          await GlobalMethods.addToCart(
                              productId: productModel.id,
                              quantity: int.parse(_quantityTextController.text),
                              context: context);
                          await cartProvider.fetchCart();
                          // cartProvider.addProductToCart(
                          //     productId: productModel.id,
                          //     quantity:
                          //         int.parse(_quantityTextController.text));
                        },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).cardColor),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0),
                      )))),
                  child: TextWidget(
                    text: isInCart ? 'In cart' : 'Add to cart',
                    colors: color,
                    fontsize: 20,
                    isTitle: true,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
