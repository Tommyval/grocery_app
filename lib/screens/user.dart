import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/const/firebase_consts.dart';
import 'package:grocery_app/orders/orders_screen.dart';
import 'package:grocery_app/screens/auth/forget_password.dart';
import 'package:grocery_app/screens/auth/login.dart';
import 'package:grocery_app/screens/loading_manager.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/viewed_recently/viewed_recently.dart';
import 'package:grocery_app/widgets/text_widgets.dart';
import 'package:grocery_app/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';

import '../provider/dark_theme_provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController addressContorller =
      TextEditingController(text: '');
  @override
  void dispose() {
    addressContorller.dispose();
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  String? _email;
  String? _name;
  String? address;
  final bool _isLoading = false;
  Future<void> getUserData() async {
    setState(() {
      bool isLoading = true;
    });
    if (user == null) {
      setState(() {
        bool isLoading = false;
      });
      return;
    }
    try {
      String uid = user!.uid;
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc == null) {
        return;
      } else {
        _email = userDoc.get('email');
        _name = userDoc.get('name');
        address = userDoc.get('shipping Address');
        addressContorller.text = userDoc.get('shipping Address');
      }
    } catch (err) {
      setState(() {
        bool isLoading = false;
      });
      GlobalMethods.errorDialog(context: context, subTitle: '$err');
    } finally {
      setState(() {
        bool isLoading = false;
      });
    }
  }

  final User? user = authInstance.currentUser;
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color colors = themeState.getDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Hi,  ',
                        style: const TextStyle(
                          color: Colors.cyan,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: _name ?? 'name',
                              style: TextStyle(
                                color: colors,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print('My name is oyin');
                                }),
                        ]),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextWidget(
                      text: _email == null ? 'email' : _email!,
                      colors: colors,
                      fontsize: 20),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(height: 20),
                  _listTiles(
                    color: colors,
                    onPressed: () async {
                      await _showAddressDialog();
                    },
                    title: 'Address',
                    subtitle: address,
                    icon1: IconlyLight.profile,
                  ),
                  _listTiles(
                    color: colors,
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          context: context, routeName: OrdersScreen.routeName);
                    },
                    title: 'Orders',
                    icon1: IconlyLight.bag,
                  ),
                  _listTiles(
                    color: colors,
                    onPressed: () {
                      Navigator.pushNamed(context, WishlistScreen.routeName);
                    },
                    title: 'Wishlist',
                    icon1: IconlyLight.heart,
                  ),
                  _listTiles(
                    color: colors,
                    onPressed: () {
                      Navigator.pushNamed(context, ViewedRecently.routeName);
                    },
                    title: 'Viewed',
                    icon1: IconlyLight.show,
                  ),
                  _listTiles(
                    color: colors,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const ForgetPassword()));
                    },
                    title: 'Forget password',
                    icon1: IconlyLight.unlock,
                  ),
                  SwitchListTile(
                      title: TextWidget(
                          text: themeState.getDarkTheme
                              ? 'darkTheme'
                              : 'lightTheme',
                          colors: colors,
                          fontsize: 18),
                      secondary: themeState.getDarkTheme
                          ? const Icon(Icons.dark_mode_outlined)
                          : const Icon(Icons.light_mode_outlined),
                      value: themeState.getDarkTheme,
                      onChanged: (bool value) {
                        setState(() {
                          themeState.setDarkTheme = value;
                        });
                      }),
                  _listTiles(
                    color: colors,
                    onPressed: () async {
                      if (user == null) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ));
                        return;
                      }

                      await GlobalMethods.warningDialog(
                          context: context,
                          title: 'Sign out',
                          subTitle: 'Do you want to sign out',
                          fxn: () async {
                            await authInstance.signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ));
                          });
                    },
                    title: user == null ? 'Login' : 'Logout',
                    icon1: user == null ? Icons.login : IconlyLight.logout,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _listTiles(
      {required String title,
      String? subtitle,
      required VoidCallback onPressed,
      required IconData icon1,
      required Color color}) {
    return ListTile(
      onTap: onPressed,
      title: TextWidget(
        text: title,
        colors: color,
        fontsize: 22,
        isTitle: true,
      ),
      subtitle: TextWidget(text: subtitle ?? '', colors: color, fontsize: 15),
      leading: Icon(icon1),
      trailing: const Icon(IconlyLight.arrowRight2),
    );
  }

  Future<void> _showAddressDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update'),
          content: TextField(
            // onChanged: (value) {
            //   addressContorller.text;
            // },
            controller: addressContorller,
            maxLines: 5,
            decoration: const InputDecoration(hintText: 'Your Address'),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  String uid = user!.uid;
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .update({'shipping Address': addressContorller.text});
                    Navigator.pop(context);
                    setState(() {
                      address = addressContorller.text;
                    });
                  } catch (err) {
                    GlobalMethods.errorDialog(
                        context: context, subTitle: err.toString());
                  }
                },
                child: const Text('Update'))
          ],
        );
      },
    );
  }
}
