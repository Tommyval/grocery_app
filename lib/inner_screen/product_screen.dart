import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Providers/cart_provider.dart';
import 'package:grocery_app/Providers/product_provider.dart';
import 'package:grocery_app/Providers/viewed_provider.dart';
import 'package:grocery_app/Providers/wishlist_provider.dart';
import 'package:grocery_app/const/firebase_consts.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/heart_btn.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  static const routeName = '/ProductScreen';
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _quntityTextController = TextEditingController(text: '1');
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final theme = Utils(context).getTheme;
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final productId = ModalRoute.of(context)!.settings.arguments as String;

    final getCurrProduct = productProvider.findProdById(productId);
    final wishListProvider = Provider.of<WishListProvider>(context);
    bool? isInWishList =
        wishListProvider.getWishListItems.containsKey(getCurrProduct.id);

    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    double totalPrice = usedPrice * int.parse(_quntityTextController.text);
    bool isInCart = cartProvider.getCarItems.containsKey(getCurrProduct.id);
    final viewedProdProvider = Provider.of<ViewedProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        //  viewedProdProvider.addProductToHistory(productId);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            leading: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () =>
                  Navigator.canPop(context) ? Navigator.pop(context) : null,
              child: Icon(
                IconlyLight.arrowLeft2,
                color: color,
                size: 24,
              ),
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        body: Column(
          children: [
            Flexible(
              flex: 2,
              child: FancyShimmerImage(
                imageUrl: getCurrProduct.imageUrl,
                boxFit: BoxFit.scaleDown,
                width: size.width,
                // height: screenHeight * .4,
              ),
            ),
            Flexible(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: TextWidget(
                                text: getCurrProduct.title,
                                colors: color,
                                fontsize: 25,
                                isTitle: true,
                              ),
                            ),
                            HeartBtn(
                              productId: getCurrProduct.id,
                              isInWishList: isInWishList,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextWidget(
                              text: '\$${usedPrice.toStringAsFixed(2)}',
                              colors: color,
                              fontsize: 22,
                              isTitle: false,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            TextWidget(
                                text:
                                    getCurrProduct.isPiece ? '1 piece' : '/kg',
                                colors: color,
                                fontsize: 12),
                            const SizedBox(
                              width: 10,
                            ),
                            Visibility(
                              visible: getCurrProduct.isOnSale ? true : false,
                              child: Text(
                                '\$${getCurrProduct.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: color,
                                    decoration: TextDecoration.lineThrough),
                              ),
                            ),
                            const Spacer(),
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(63, 200, 101, 1),
                                    borderRadius: BorderRadius.circular(5)),
                                child: TextWidget(
                                  text: 'Free delivery',
                                  colors: color,
                                  fontsize: 20,
                                  isTitle: true,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          quantityControl(
                            fct: () {
                              setState(() {
                                _quntityTextController.text =
                                    (int.parse(_quntityTextController.text) - 1)
                                        .toString();
                              });
                            },
                            icon: CupertinoIcons.minus,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            flex: 1,
                            child: TextField(
                              controller: _quntityTextController,
                              key: const ValueKey('quantity'),
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                              ),
                              textAlign: TextAlign.center,
                              cursorColor: Colors.green,
                              enabled: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[0-9]')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  if (value.isEmpty) {
                                    _quntityTextController.text = '1';
                                  } else {}
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          quantityControl(
                            fct: () {
                              setState(() {
                                _quntityTextController.text =
                                    (int.parse(_quntityTextController.text) + 1)
                                        .toString();
                              });
                            },
                            icon: CupertinoIcons.plus,
                            color: Colors.green,
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Spacer(),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 30),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: 'Total',
                                    colors: Colors.red.shade300,
                                    fontsize: 20,
                                    isTitle: true,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        TextWidget(
                                          text:
                                              '\$${totalPrice.toStringAsFixed(2)}/',
                                          colors: color,
                                          fontsize: 20,
                                          isTitle: true,
                                        ),
                                        TextWidget(
                                          text:
                                              '${_quntityTextController.text}/Kg',
                                          colors: color,
                                          fontsize: 16,
                                          isTitle: false,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: Material(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  onTap: isInCart
                                      ? null
                                      : () async {
                                          final User? user =
                                              authInstance.currentUser;
                                          // print('user id is $user!.uid');
                                          if (user == null) {
                                            GlobalMethods.errorDialog(
                                                context: context,
                                                subTitle:
                                                    'No user found, please log in');
                                            return;
                                          }
                                          await GlobalMethods.addToCart(
                                              productId: getCurrProduct.id,
                                              quantity: int.parse(
                                                  _quntityTextController.text),
                                              context: context);
                                          await cartProvider.fetchCart();
                                          // cartProvider.addProductToCart(
                                          //     productId: getCurrProduct.id,
                                          //     quantity: int.parse(
                                          //         _quntityTextController.text));
                                        },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: TextWidget(
                                          text: isInCart
                                              ? 'In Cart'
                                              : 'Add to cart',
                                          colors: Colors.white,
                                          fontsize: 18)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget quantityControl(
      {required Function fct, required IconData icon, required Color color}) {
    return Flexible(
      flex: 2,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: color,
        child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              fct();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: 25,
              ),
            )),
      ),
    );
  }
}
