import 'package:flutter/cupertino.dart';
import 'package:grocery_app/models/cart.models.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};
  Map<String, CartModel> get getCarItems {
    return _cartItems;
  }

  void addProductToCart({required String productId, required int quantity}) {
    _cartItems.putIfAbsent(
        productId,
        () => CartModel(
            id: DateTime.now().toString(),
            productId: productId,
            quantity: quantity));
    notifyListeners();
  }

  void reduceQuantityByOne(String productId) {
    _cartItems.update(
        productId,
        (value) => CartModel(
            id: value.id,
            productId: value.productId,
            quantity: value.quantity - 1));
    notifyListeners();
  }

  void increaseQuantityByOne(String productId) {
    _cartItems.update(
        productId,
        (value) => CartModel(
            id: value.id,
            productId: value.productId,
            quantity: value.quantity + 1));
    notifyListeners();
  }

  void remove0neItem(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
