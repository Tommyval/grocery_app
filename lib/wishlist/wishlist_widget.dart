import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Providers/product_provider.dart';
import 'package:grocery_app/Providers/wishlist_provider.dart';
import 'package:grocery_app/inner_screen/product_screen.dart';
import 'package:grocery_app/models/wishlistmodels.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/heart_btn.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final wishListProvider = Provider.of<WishListProvider>(context);

    final productProvider = Provider.of<ProductProvider>(context);
    final wishListModel = Provider.of<WishListModel>(context);

    final getCurrProduct =
        productProvider.findProdById(wishListModel.productId);
    bool? isInWishList =
        wishListProvider.getWishListItems.containsKey(getCurrProduct.id);
    double usedPrice = getCurrProduct.isOnSale
        ? getCurrProduct.salePrice
        : getCurrProduct.price;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProductScreen.routeName,
              arguments: wishListModel.productId);
        },
        child: Container(
          height: size.height * 0.20,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: color, width: 1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  // width: size.width * 0.2,
                  height: size.width * 0.25,
                  child: FancyShimmerImage(
                    imageUrl: getCurrProduct.imageUrl,
                    boxFit: BoxFit.fill,
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                IconlyLight.bag2,
                                color: color,
                              )),
                          HeartBtn(
                            productId: getCurrProduct.id,
                            isInWishList: isInWishList,
                          )
                        ],
                      ),
                    ),
                    TextWidget(
                      maxLines: 1,
                      text: getCurrProduct.title,
                      colors: color,
                      fontsize: 18,
                      isTitle: true,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextWidget(
                      text: '\$${usedPrice.toStringAsFixed(2)}',
                      colors: color,
                      fontsize: 18,
                      isTitle: true,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
