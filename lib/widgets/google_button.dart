import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_app/const/firebase_consts.dart';
import 'package:grocery_app/screens/btm_bar_screen.dart';
import 'package:grocery_app/services/global_methods.dart';
import 'package:grocery_app/widgets/text_widgets.dart';

class GoogleButton extends StatelessWidget {
  GoogleButton({Key? key}) : super(key: key);
  final bool _isLoading = false;
  Future<void> _googleSignIn(context) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          await authInstance.signInWithCredential(
            GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken),
          );
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const BottomBarScreen()));
        } on FirebaseException catch (error) {
          GlobalMethods.errorDialog(
              context: context, subTitle: '${error.message}');
        } catch (error) {
          GlobalMethods.errorDialog(context: context, subTitle: '$error');
        } finally {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: InkWell(
        onTap: () {
          _googleSignIn(context);
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            color: Colors.white,
            child: Image.asset(
              'assets/images/google.png',
              width: 40,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          TextWidget(
              text: 'Sign in with google', colors: Colors.white, fontsize: 18)
        ]),
      ),
    );
  }
}
