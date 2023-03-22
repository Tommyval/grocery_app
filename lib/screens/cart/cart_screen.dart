import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Providers/cart_provider.dart';
import 'package:grocery_app/screens/cart/cart.widget.dart';
import 'package:grocery_app/widgets/empty_screen.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

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
                          fxn: () {
                            cartProvider.clearCart();
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
                onTap: () {},
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
                text: 'Total \$0.29',
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
