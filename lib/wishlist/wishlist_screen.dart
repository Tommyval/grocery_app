import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grocery_app/Providers/wishlist_provider.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/back_widget.dart';
import 'package:grocery_app/widgets/empty_screen.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:grocery_app/wishlist/wishlist_widget.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = '/WishlistScreen';
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final wishListProvider = Provider.of<WishListProvider>(context);
    final wishItemList =
        wishListProvider.getWishListItems.values.toList().reversed.toList();
    return wishItemList.isEmpty
        ? const EmptyScreen(
            title: 'Your wishlist is empty',
            subtitle: 'Eplore more and shortlist some items',
            buttonText: 'Add a wish',
            imagePath: 'assets/images/wishlist.png',
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: const BackWidget(),
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: TextWidget(
                text: 'Wishlist(${wishItemList.length})',
                colors: color,
                fontsize: 22,
                isTitle: true,
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      GlobalMethods.warningDialog(
                          context: context,
                          title: 'Empty your wishlist',
                          subTitle: 'Are you sure',
                          fxn: () async {
                            await wishListProvider.clearOnlineWish();
                            wishListProvider.clearLocalWish();
                          });
                    },
                    icon: Icon(
                      IconlyBroken.delete,
                      color: color,
                    ))
              ],
            ),
            body: MasonryGridView.count(
              itemCount: wishItemList.length,
              crossAxisCount: 2,
              // mainAxisSpacing: 4,
              // crossAxisSpacing: 4,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                    value: wishItemList[index], child: const WishlistWidget());
              },
            ));
  }
}
