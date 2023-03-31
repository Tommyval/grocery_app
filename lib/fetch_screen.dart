import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grocery_app/Providers/wishlist_provider.dart';
import 'package:grocery_app/const/firebase_consts.dart';
import 'package:grocery_app/screens/btm_bar_screen.dart';
import 'package:provider/provider.dart';

import 'Providers/cart_provider.dart';
import 'Providers/orders_provider.dart';
import 'Providers/product_provider.dart';
import 'const/consts.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({Key? key}) : super(key: key);

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  List<String> images = Consts.authImagesPaths;
  @override
  void initState() {
    images.shuffle();
    Future.delayed(const Duration(microseconds: 5), (() async {
      final ordersProvider =
          Provider.of<OrdersProvider>(context, listen: false);
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final wishListProvider =
          Provider.of<WishListProvider>(context, listen: false);
      final User? user = authInstance.currentUser;
      await productProvider.fetchProducts();
      cartProvider.fetchCart();
      cartProvider.clearLocalCart();
      wishListProvider.fetchWishList();
      wishListProvider.clearLocalWish();
      ordersProvider.clearLocalOrders();
      // if (user == null) {
      //   await productProvider.fetchProducts();
      //   cartProvider.clearLocalCart();
      //   wishListProvider.clearLocalWish();
      // } else {
      //   await productProvider.fetchProducts();
      //   await cartProvider.fetchCart();
      //   await wishListProvider.fetchWishList();
      // }
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const BottomBarScreen(),
      ));
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            images[0],
            fit: BoxFit.cover,
            height: double.infinity,
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          const Center(
              child: SpinKitFadingFour(
            color: Colors.white,
          ))
        ],
      ),
    );
  }
}
