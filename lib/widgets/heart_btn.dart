import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Providers/product_provider.dart';
import 'package:grocery_app/Providers/wishlist_provider.dart';
import 'package:grocery_app/const/firebase_consts.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:provider/provider.dart';

class HeartBtn extends StatefulWidget {
  HeartBtn({Key? key, this.isInWishList = false, required this.productId})
      : super(key: key);
  String productId;
  bool? isInWishList;

  @override
  State<HeartBtn> createState() => _HeartBtnState();
}

class _HeartBtnState extends State<HeartBtn> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final wishListProvider = Provider.of<WishListProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findProdById(widget.productId);
    @override
    final Color color = Utils(context).color;
    return GestureDetector(
      onTap: () async {
        setState(() {
          loading = true;
        });
        try {
          final User? user = authInstance.currentUser;
          if (user == null) {
            GlobalMethods.errorDialog(
                context: context,
                subTitle: 'No user Found, please Login First');
            return;
          }
          if (widget.isInWishList == false && widget.isInWishList != null) {
            await GlobalMethods.addProductToWishList(
                productId: widget.productId, context: context);
          } else {
            wishListProvider.remove0neItem(
              productId: widget.productId,
              wishListId:
                  wishListProvider.getWishListItems[getCurrProduct.id]!.id,
            );
          }
          await wishListProvider.fetchWishList();
          setState(() {
            loading = false;
          });
        } catch (err) {
          GlobalMethods.errorDialog(context: context, subTitle: '$err');
        } finally {
          setState(() {
            loading = false;
          });
        }
      },
      // if(isInWishList == false && isInWishList!=)  await GlobalMethods.addProductToWishList(
      //       productId: productId, context: context);
      // },
      child: loading
          ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 20, width: 20, child: CircularProgressIndicator()),
            )
          : Icon(
              widget.isInWishList != null && widget.isInWishList == true
                  ? IconlyBold.heart
                  : IconlyLight.heart,
              size: 22,
              color: widget.isInWishList != null && widget.isInWishList == true
                  ? Colors.red
                  : color,
            ),
    );
  }
}
