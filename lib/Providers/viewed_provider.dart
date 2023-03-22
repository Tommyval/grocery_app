import 'package:flutter/cupertino.dart';

import 'package:grocery_app/models/viewed_model.dart';

class ViewedProvider with ChangeNotifier {
  final Map<String, ViewedModel> _viewedItem = {};
  Map<String, ViewedModel> get getViewedItems {
    return _viewedItem;
  }

  void addProductToHistory(String productId) {
    getViewedItems.putIfAbsent(productId,
        () => ViewedModel(id: DateTime.now().toString(), productId: productId));
    notifyListeners();
  }

  void clearHistory() {
    _viewedItem.clear();
    notifyListeners();
  }
}
