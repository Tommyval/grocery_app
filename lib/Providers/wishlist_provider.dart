import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_app/const/firebase_consts.dart';
import 'package:grocery_app/models/wishlistmodels.dart';

class WishListProvider with ChangeNotifier {
  final Map<String, WishListModel> _wishListItem = {};
  Map<String, WishListModel> get getWishListItems {
    return _wishListItem;
  }

  // void addProductToWishList(String productId) {
  //   if (getWishListItems.containsKey(productId)) {
  //     remove0neItem(productId);
  //   } else {
  //     getWishListItems.putIfAbsent(
  //         productId,
  //         () => WishListModel(
  //             id: DateTime.now().toString(), productId: productId));
  //     notifyListeners();
  //   }
  // }

  Future<void> fetchWishList() async {
    final User? user = authInstance.currentUser;
    final uid = user!.uid;
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (user == null) {
      return;
    } else {
      final leng = userDoc.get('userwish').length;
      for (int i = 0; i < leng; i++) {
        _wishListItem.putIfAbsent(
            userDoc.get('userwish')[i]['productId'],
            () => WishListModel(
                  id: userDoc.get('userwish')[i]['wishListIdId'],
                  productId: userDoc.get('userwish')[i]['productId'],
                ));
      }
    }
    notifyListeners();
  }

  Future<void> remove0neItem({
    required String productId,
    required String wishListId,
  }) async {
    final userCollection = FirebaseFirestore.instance.collection('users');
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update({
      'userwish': FieldValue.arrayRemove([
        {'wishListId': wishListId, 'productId': productId}
      ])
    });
    _wishListItem.remove(productId);
    await fetchWishList();
    notifyListeners();
  }

  Future<void> clearOnlineWish() async {
    final userCollection = FirebaseFirestore.instance.collection('users');
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update({
      'userwish': [],
    });
    _wishListItem.clear();
    notifyListeners();
  }

  void clearLocalWish() {
    _wishListItem.clear();
    notifyListeners();
  }
}
