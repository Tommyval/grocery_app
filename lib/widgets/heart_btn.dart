import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Providers/wishlist_provider.dart';
import 'package:grocery_app/const/firebase_consts.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:provider/provider.dart';

class HeartBtn extends StatelessWidget {
  HeartBtn({Key? key, this.isInWishList = false, required this.productId})
      : super(key: key);
  String productId;
  bool? isInWishList;
  @override
  Widget build(BuildContext context) {
    final wishListProvider = Provider.of<WishListProvider>(context);
    @override
    final Color color = Utils(context).color;
    return GestureDetector(
      onTap: () {
        final User? user = authInstance.currentUser;
        // print('user id is $user!.uid');
        if (user == null) {
          GlobalMethods.errorDialog(
              context: context, subTitle: 'No user found, please log in');
          return;
        }
        wishListProvider.addProductToWishList(productId);
      },
      child: Icon(
        isInWishList != null && isInWishList == true
            ? IconlyBold.heart
            : IconlyLight.heart,
        size: 22,
        color:
            isInWishList != null && isInWishList == true ? Colors.red : color,
      ),
    );
  }
}
