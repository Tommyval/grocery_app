import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/Providers/cart_provider.dart';
import 'package:grocery_app/Providers/orders_provider.dart';
import 'package:grocery_app/const/firebase_consts.dart';
import 'package:grocery_app/screens/cart/cart.widget.dart';
import 'package:grocery_app/widgets/empty_screen.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../Providers/product_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemList =
        cartProvider.getCarItems.values.toList().reversed.toList();
    return cartItemList.isEmpty
        ? const EmptyScreen(
            title: 'Your cart is empty',
            subtitle: 'Add something and make me happy',
            buttonText: 'Shop now',
            imagePath: 'assets/images/cart.png',
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Theme.of(context).backgroundColor,
              title: TextWidget(
                text: 'Cart(${cartItemList.length})',
                colors: color,
                fontsize: 22,
                isTitle: true,
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      GlobalMethods.warningDialog(
                          context: context,
                          title: 'Empty your cart',
                          subTitle: 'Are you sure',
                          fxn: () async {
                            cartProvider.clearOnlineCart();
                            cartProvider.clearLocalCart();
                          });
                    },
                    icon: Icon(
                      IconlyBroken.delete,
                      color: color,
                    ))
              ],
            ),
            body: Column(
              children: [
                _checkOut(context: context),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItemList.length,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                          value: cartItemList[index],
                          child: CartWidget(
                            q: cartItemList[index].quantity,
                          ));
                    },
                  ),
                ),
              ],
            ));
  }

  Widget _checkOut({required BuildContext context}) {
    final cartProvider = Provider.of<CartProvider>(context);
    final ordersProvider = Provider.of<OrdersProvider>(
      context,
    );
    double total = 0.0;
    cartProvider.getCarItems.forEach((key, value) {
      final productProvider = Provider.of<ProductProvider>(context);
      final getCurrProduct = productProvider.findProdById(value.productId);
      total += (getCurrProduct.isOnSale
              ? getCurrProduct.salePrice
              : getCurrProduct.price) *
          value.quantity;
    });
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      // color: ,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Material(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  final User? user = authInstance.currentUser;
                  final uid = user!.uid;
                  final orderId = const Uuid().v4();
                  final productProvider =
                      Provider.of<ProductProvider>(context, listen: false);

                  cartProvider.getCarItems.forEach((key, value) async {
                    final getCurrProduct = productProvider.findProdById(
                      value.productId,
                    );
                    try {
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(orderId)
                          .set({
                        'orderId': orderId,
                        'userId': uid,
                        'productId': value.productId,
                        'price': (getCurrProduct.isOnSale
                                ? getCurrProduct.salePrice
                                : getCurrProduct.price) *
                            value.quantity,
                        'totalPrice': total,
                        'quantity': value.quantity,
                        'imageUrl': getCurrProduct.imageUrl,
                        'userName': user.displayName,
                        'orderDate': Timestamp.now(),
                      });
                      await cartProvider.clearOnlineCart();
                      cartProvider.clearLocalCart();
                      ordersProvider.fetchOrders();
                      Fluttertoast.showToast(
                        msg: 'You order has been places',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                      );
                    } catch (err) {
                      GlobalMethods.errorDialog(
                          context: context, subTitle: '$err');
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextWidget(
                      text: 'Order Now', colors: color, fontsize: 20),
                ),
              ),
            ),
            const Spacer(),
            FittedBox(
              child: TextWidget(
                text: 'Total \$${total.toStringAsFixed(2)}',
                colors: color,
                fontsize: 18,
                isTitle: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
