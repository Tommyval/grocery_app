import 'package:flutter/material.dart';
import 'package:grocery_app/Providers/orders_provider.dart';
import 'package:grocery_app/orders/orders_widget.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/back_widget.dart';
import 'package:grocery_app/widgets/empty_screen.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/OrderScreen';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final ordersList = ordersProvider.getOrders;
    return FutureBuilder(
      future: ordersProvider.fetchOrders(),
      builder: (context, snapshot) {
        return ordersList.isEmpty
            ? const EmptyScreen(
                title: 'You didnt place any order yet',
                subtitle: 'order something and make me happy',
                buttonText: 'Shop now',
                imagePath: 'assets/images/cart.png',
              )
            : Scaffold(
                appBar: AppBar(
                  leading: const BackWidget(),
                  elevation: 0,
                  centerTitle: false,
                  title: TextWidget(
                    text: 'Your orders (${ordersList.length})',
                    colors: color,
                    fontsize: 24.0,
                    isTitle: true,
                  ),
                  backgroundColor: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.9),
                ),
                body: ListView.separated(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 6),
                        child: ChangeNotifierProvider.value(
                            value: ordersList[index],
                            child: const OrdersWidget()),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: color,
                      );
                    },
                    itemCount: ordersList.length),
              );
      },
    );
  }
}
