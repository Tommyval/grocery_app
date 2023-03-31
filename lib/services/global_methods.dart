import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/const/firebase_consts.dart';
import 'package:uuid/uuid.dart';

class GlobalMethods {
  static navigateTo(
      {required BuildContext context, required String routeName}) {
    Navigator.pushNamed(context, routeName);
  }

  static Future<void> warningDialog(
      {required BuildContext context,
      required String title,
      required subTitle,
      required Function fxn}) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(subTitle),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('cancel')),
              TextButton(
                  onPressed: () {
                    fxn();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('ok'))
            ],
          );
        });
  }

  static Future<void> errorDialog({
    required BuildContext context,
    required subTitle,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Image.asset(
                  'assets/images/warning-sign.png',
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: 8),
                const Text('An error occured'),
              ],
            ),
            content: Text(subTitle),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok')),
            ],
          );
        });
  }

  static Future<void> addToCart(
      {required String productId,
      required int quantity,
      required BuildContext context}) async {
    final User? user = authInstance.currentUser;
    final uid = user!.uid;
    final cartId = const Uuid().v4();
    try {
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'userCart': FieldValue.arrayUnion([
          {'cartId': cartId, 'productId': productId, 'quantity': quantity}
        ])
      });
      Fluttertoast.showToast(
        msg: 'Item has been added to your cart',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
    } catch (error) {
      errorDialog(context: context, subTitle: error.toString());
    }
  }

  static Future<void> addProductToWishList(
      {required String productId, required BuildContext context}) async {
    final User? user = authInstance.currentUser;
    final uid = user!.uid;
    final wishListId = const Uuid().v4();
    try {
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'userwish': FieldValue.arrayUnion([
          {'wishListId': wishListId, 'productId': productId}
        ])
      });
      Fluttertoast.showToast(
        msg: 'Item has been added to your wishList',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
      );
    } catch (err) {
      errorDialog(context: context, subTitle: err.toString());
    }
  }
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