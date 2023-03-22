import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Providers/viewed_provider.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/viewed_recently/viewed_widget.dart';
import 'package:grocery_app/widgets/back_widget.dart';
import 'package:grocery_app/widgets/empty_screen.dart';
import 'package:provider/provider.dart';

class ViewedRecently extends StatefulWidget {
  static const routeName = '/ViewedRecentlyScreen';
  const ViewedRecently({Key? key}) : super(key: key);

  @override
  State<ViewedRecently> createState() => _ViewedRecentlyState();
}

class _ViewedRecentlyState extends State<ViewedRecently> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    bool check = false;
    final viewedProdProvider = Provider.of<ViewedProvider>(context);
    final viewedItemList =
        viewedProdProvider.getViewedItems.values.toList().reversed.toList();
    return viewedItemList.isEmpty
        ? const EmptyScreen(
            title: 'Your history is empty',
            subtitle: 'No product has been viewed yet!',
            buttonText: 'Shop now',
            imagePath: 'assets/images/history.png',
          )
        : Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      GlobalMethods.warningDialog(
                          context: context,
                          title: 'Empty your history',
                          subTitle: 'Are you sure?',
                          fxn: () {});
                    },
                    icon: const Icon(IconlyBroken.delete))
              ],
              leading: const BackWidget(),
              automaticallyImplyLeading: false,
              backgroundColor:
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
            ),
            body: ListView.builder(
              itemCount: viewedItemList.length,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                    value: viewedItemList[index],
                    child: const ViewedRecentlyWidget());
              },
            ),
          );
  }
}
