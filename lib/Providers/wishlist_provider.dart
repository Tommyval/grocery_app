import 'package:flutter/cupertino.dart';
import 'package:grocery_app/models/wishlistmodels.dart';

class WishListProvider with ChangeNotifier {
  final Map<String, WishListModel> _wishListItem = {};
  Map<String, WishListModel> get getWishListItems {
    return _wishListItem;
  }

  void addProductToWishList(String productId) {
    if (getWishListItems.containsKey(productId)) {
      remove0neItem(productId);
    } else {
      getWishListItems.putIfAbsent(
          productId,
          () => WishListModel(
              id: DateTime.now().toString(), productId: productId));
      notifyListeners();
    }
  }

  void remove0neItem(String productId) {
    _wishListItem.remove(productId);
    notifyListeners();
  }

  void clearWishList() {
    _wishListItem.clear();
    notifyListeners();
  }
}
