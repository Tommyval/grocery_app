import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/const/consts.dart';
import 'package:grocery_app/const/firebase_consts.dart';
import 'package:grocery_app/screens/auth/login.dart';
import 'package:grocery_app/screens/btm_bar_screen.dart';
import 'package:grocery_app/screens/loading_manager.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/auth_button.dart';
import 'package:grocery_app/widgets/text_widgets.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/RegisterScreen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _addressTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _obscureText = true;
  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _addressTextController.dispose();
    _passFocusNode.dispose();
    _fullNameTextController.dispose();
    _emailFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _submitFormOnRegister() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });
    if (isValid) {
      _formKey.currentState!.save();
      try {
        await authInstance.createUserWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        final User? user = authInstance.currentUser;
        final uid = user!.uid;
        FirebaseFirestore.instance.collection('users').doc(uid).set({
          'id': uid,
          'name': _fullNameTextController.text,
          'email': _emailTextController.text,
          'shipping Address': _addressTextController.text,
          'userwish': [],
          'userCart': [],
          'createAt': Timestamp.now()
        });
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const BottomBarScreen()));
        print('successfully registered');
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
    final theme = Utils(context).getTheme;
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
                      height: 60.0,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.canPop(context)
                          ? Navigator.pop(context)
                          : null,
                      child: Icon(
                        IconlyLight.arrowLeft2,
                        color: theme == true ? Colors.white : Colors.black,
                        size: 24,
                      ),
                    ),
                    const SizedBox(
                      height: 40.0,
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
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_emailFocusNode),
                              keyboardType: TextInputType.name,
                              controller: _fullNameTextController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "This Field is missing";
                                } else {
                                  return null;
                                }
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Full name',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                            TextFormField(
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_passFocusNode),
                                controller: _emailTextController,
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
                                focusNode: _passFocusNode,
                                obscureText: _obscureText,
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_addressFocusNode),
                                controller: _passTextController,
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
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              focusNode: _addressFocusNode,
                              textInputAction: TextInputAction.done,
                              onEditingComplete: _submitFormOnRegister,
                              controller: _addressTextController,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 10) {
                                  return "Please enter a valid  address";
                                } else {
                                  return null;
                                }
                              },
                              style: const TextStyle(color: Colors.white),
                              maxLines: 2,
                              textAlign: TextAlign.start,
                              decoration: const InputDecoration(
                                hintText: 'Shipping address',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.topRight,
                              child: TextButton(
                                onPressed: () {},
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
                              buttonText: 'Sign up',
                              fct: () {
                                _submitFormOnRegister();
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            RichText(
                              text: TextSpan(
                                  text: 'Already a user?',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: ' Sign in',
                                        style: const TextStyle(
                                            color: Colors.lightBlue,
                                            fontSize: 18),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushReplacementNamed(
                                                context, LoginScreen.routeName);
                                          }),
                                  ]),
                            ),
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
