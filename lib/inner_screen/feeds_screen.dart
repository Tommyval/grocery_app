import 'package:flutter/material.dart';
import 'package:grocery_app/Providers/product_provider.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/back_widget.dart';
import 'package:grocery_app/widgets/empty_products_widget.dart';
import 'package:grocery_app/widgets/feeds_item.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';

class FeedScreen extends StatefulWidget {
  static const routeName = '/FeedsWidget';
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  List<ProductModel> listProductSearch = [];
  @override
  void dispose() {
    _searchTextController.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   final productProvider =
  //       Provider.of<ProductProvider>(context, listen: false);
  //   productProvider.fetchProducts();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    bool isEmpty = false;
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductProvider>(context);
    List<ProductModel> allProducts = productProvider.getProducts;
    return Scaffold(
        appBar: AppBar(
          leading: const BackWidget(),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: TextWidget(
            text: 'All Product',
            colors: color,
            fontsize: 20,
            isTitle: true,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: kBottomNavigationBarHeight,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      listProductSearch = productProvider.searchQuery(value);
                    });
                  },
                  focusNode: _searchTextFocusNode,
                  controller: _searchTextController,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.greenAccent, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.greenAccent, width: 1),
                      ),
                      hintText: 'What is in your mind',
                      prefixIcon: const Icon(Icons.search),
                      suffix: IconButton(
                          onPressed: () {
                            _searchTextController.clear();
                            _searchTextFocusNode.unfocus();
                          },
                          icon: const Icon(Icons.close),
                          color: _searchTextFocusNode.hasFocus
                              ? Colors.red
                              : color)),
                ),
              ),
              _searchTextController.text.isNotEmpty && listProductSearch.isEmpty
                  ? const EmptyProductWidget(
                      errorMessage:
                          'No products found, please try another keyword')
                  : GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      //padding: EdgeInsets.zero,
                      childAspectRatio: size.width / (size.height * 0.64),
                      children: List.generate(
                          _searchTextController.text.isNotEmpty
                              ? listProductSearch.length
                              : allProducts.length, (index) {
                        return ChangeNotifierProvider.value(
                            value: _searchTextController.text.isNotEmpty
                                ? listProductSearch[index]
                                : allProducts[index],
                            child: const FeedsWidget());
                      }),
                    ),
            ],
          ),
        ));
  }
}
