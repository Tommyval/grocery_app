import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/Providers/product_provider.dart';
import 'package:grocery_app/const/consts.dart';
import 'package:grocery_app/inner_screen/feeds_screen.dart';
import 'package:grocery_app/inner_screen/on_sale_screen.dart';
import 'package:grocery_app/models/product_model.dart';
import 'package:grocery_app/provider/dark_theme_provider.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/feeds_item.dart';
import 'package:grocery_app/widgets/on_sale_widget.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';
import 'package:card_swiper/card_swiper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductProvider>(context);
    List<ProductModel> allProducts = productProvider.getProducts;
    List<ProductModel> productsOnsale = productProvider.getOnSaleProducts;
    return FutureBuilder(
      future: productProvider.fetchProducts(),
      builder: (context, snapshot) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.33,
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return Image.asset(
                        Consts.offerImages[index],
                        fit: BoxFit.fill,
                      );
                    },
                    autoplay: true,
                    itemCount: Consts.offerImages.length,
                    pagination: const SwiperPagination(
                        alignment: Alignment.bottomCenter,
                        builder: DotSwiperPaginationBuilder(
                            color: Colors.white, activeColor: Colors.red)),
                    control: const SwiperControl(color: Colors.amber),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Center(
                  child: TextButton(
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            context: context,
                            routeName: OnSaleScreen.routeName);
                      },
                      child: TextWidget(
                          text: 'View all', colors: Colors.blue, fontsize: 20)),
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    RotatedBox(
                      quarterTurns: -1,
                      child: Row(
                        children: [
                          TextWidget(
                            text: 'ON SALES',
                            colors: Colors.red,
                            fontsize: 22,
                            isTitle: true,
                          ),
                          const Icon(
                            IconlyLight.discount,
                            color: Colors.red,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: SizedBox(
                        height: size.height * 0.24,
                        child: ListView.builder(
                          itemCount: productsOnsale.length < 10
                              ? productsOnsale.length
                              : 10,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return ChangeNotifierProvider.value(
                              value: productsOnsale[index],
                              child: const OnSaleWidget(),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Our products',
                        colors: Colors.black,
                        fontsize: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          GlobalMethods.navigateTo(
                              context: context,
                              routeName: FeedScreen.routeName);
                        },
                        child: TextWidget(
                          text: 'Browse all',
                          colors: Colors.blue,
                          fontsize: 20,
                        ),
                      )
                    ],
                  ),
                ),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  padding: EdgeInsets.zero,
                  childAspectRatio: size.width / (size.height * 0.69),
                  children: List.generate(
                      allProducts.length < 4 ? allProducts.length : 4, (index) {
                    return ChangeNotifierProvider.value(
                        value: allProducts[index], child: const FeedsWidget());
                  }),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
