import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/const/consts.dart';
import 'package:grocery_app/fetch_screen.dart';
import 'package:grocery_app/screens/auth/forget_password.dart';
import 'package:grocery_app/screens/auth/register.dart';
import 'package:grocery_app/screens/loading_manager.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/widgets/auth_button.dart';
import 'package:grocery_app/widgets/google_button.dart';
import 'package:grocery_app/widgets/text_widgets.dart';

import '../../const/firebase_consts.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _obscureText = true;
  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _submitFormOnLogin() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await authInstance.signInWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const FetchScreen()));
        print('successfully logged in');
      } on FirebaseException catch (err) {
        GlobalMethods.errorDialog(context: context, subTitle: '${err.message}');
        setState(() {
          _isLoading = false;
        });
      } catch (err) {
        GlobalMethods.errorDialog(context: context, subTitle: '$err');
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(
          children: [
            Swiper(
              duration: 800,
              autoplayDelay: 6000,
              itemBuilder: (BuildContext context, int index) {
                return Image.asset(
                  Consts.authImagesPaths[index],
                  fit: BoxFit.fill,
                );
              },
              autoplay: true,
              itemCount: Consts.authImagesPaths.length,
              // control: const SwiperControl(color: Colors.amber),
            ),
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 120,
                    ),
                    TextWidget(
                      text: 'Welcome Back',
                      colors: Colors.white,
                      fontsize: 30,
                      isTitle: true,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextWidget(
                      text: "Sign in to continue",
                      colors: Colors.white,
                      fontsize: 18,
                      isTitle: false,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                                controller: _emailTextController,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_passFocusNode),
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'please enter a valid email address';
                                  } else {
                                    return null;
                                  }
                                },
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: TextStyle(color: Colors.white),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                )),
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                                controller: _passTextController,
                                obscureText: _obscureText,
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                onEditingComplete: () {
                                  _submitFormOnLogin();
                                },
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 7) {
                                    return 'please enter a valid password';
                                  } else {
                                    return null;
                                  }
                                },
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      child: Icon(_obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off)),
                                  hintText: 'Password',
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                )),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.topRight,
                              child: TextButton(
                                onPressed: () {
                                  GlobalMethods.navigateTo(
                                      context: context,
                                      routeName: ForgetPassword.routeName);
                                },
                                child: const Text(
                                  'Forget password?',
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.lightBlue,
                                      fontSize: 18,
                                      decoration: TextDecoration.underline,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            AuthButton(
                              fct: () {
                                _submitFormOnLogin();
                              },
                              buttonText: 'Login',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GoogleButton(),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 2,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                TextWidget(
                                  text: 'OR',
                                  colors: Colors.white,
                                  fontsize: 18,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Expanded(
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AuthButton(
                              fct: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const FetchScreen(),
                                    ));
                              },
                              buttonText: 'Continue as a guest',
                              primary: Colors.black,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            RichText(
                                text: TextSpan(
                                    text: 'Don\'t have an account?',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                    children: [
                                  TextSpan(
                                      text: '  Sign up',
                                      style: const TextStyle(
                                        color: Colors.lightBlue,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          GlobalMethods.navigateTo(
                                              context: context,
                                              routeName:
                                                  RegisterScreen.routeName);
                                        })
                                ]))
                          ],
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
