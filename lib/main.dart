import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/Providers/cart_provider.dart';
import 'package:grocery_app/Providers/orders_provider.dart';
import 'package:grocery_app/Providers/product_provider.dart';
import 'package:grocery_app/Providers/viewed_provider.dart';
import 'package:grocery_app/Providers/wishlist_provider.dart';
import 'package:grocery_app/const/theme_data.dart';
import 'package:grocery_app/fetch_screen.dart';
import 'package:grocery_app/inner_screen/cat_screen.dart';
import 'package:grocery_app/inner_screen/feeds_screen.dart';
import 'package:grocery_app/inner_screen/on_sale_screen.dart';
import 'package:grocery_app/inner_screen/product_screen.dart';
import 'package:grocery_app/orders/orders_screen.dart';
import 'package:grocery_app/provider/dark_theme_provider.dart';
import 'package:grocery_app/screens/auth/forget_password.dart';
import 'package:grocery_app/screens/auth/login.dart';
import 'package:grocery_app/screens/auth/register.dart';
import 'package:grocery_app/viewed_recently/viewed_recently.dart';
import 'package:grocery_app/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  // This widget is the root of your application.
  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          } else if (snapshot.hasError) {
            const MaterialApp(
              home: Scaffold(body: Center(child: Text('An error occured'))),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => DarkThemeProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => ProductProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => CartProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => WishListProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => ViewedProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => OrdersProvider(),
              ),
            ],
            child: Consumer<DarkThemeProvider>(
              builder: (context, value, child) {
                return MaterialApp(
                  title: 'Flutter Demo',
                  theme: Styles.themeData(value.getDarkTheme, context),
                  home: const FetchScreen(),
                  //  const BottomBarScreen(),
                  routes: {
                    OnSaleScreen.routeName: (context) => const OnSaleScreen(),
                    FeedScreen.routeName: (context) => const FeedScreen(),
                    WishlistScreen.routeName: (context) =>
                        const WishlistScreen(),
                    ProductScreen.routeName: (ctx) => const ProductScreen(),
                    OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                    ViewedRecently.routeName: (ctx) => const ViewedRecently(),
                    RegisterScreen.routeName: ((context) =>
                        const RegisterScreen()),
                    LoginScreen.routeName: ((context) => const LoginScreen()),
                    ForgetPassword.routeName: (((context) =>
                        const ForgetPassword())),
                    CategoryScreen.routeName: (((context) =>
                        const CategoryScreen())),
                  },
                );
              },
            ),
          );
        });
  }
}
