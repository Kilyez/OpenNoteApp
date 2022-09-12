// ignore_for_file: prefer_const_constructors, sort_child_properties_last


import 'package:app/app/sign_in/sign_in_form.dart';

import 'SignIn_Button.dart';
import 'Social_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:app/Common_widgets/CustomButton.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Note for All',
          style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: 23.0),
          ),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          '',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 48.0,
        ),
        SocialSignInButton(
          assetName:'images/google-logo.png',
          text: 'Sign In with Google',
          textColor: Colors.black87,
          color: Colors.white,
          onPressed:() {},
        ),
        SizedBox(
          height: 8.0,
        ),
        SocialSignInButton(
          assetName:'images/facebook-logo.png',
          text: 'Sign In with Facebook',
          textColor: Colors.white,
          color: Color(0xFF334D92),
          onPressed:() {},
        ),
        SizedBox(
          height: 8.0,
        ),
        SignInButton(
          text: 'Sign In with email',
          textColor: Colors.white,
          color: Color(0xFF00796B),
          onPressed:() {Navigator.pushNamedAndRemoveUntil(context, SignInModel.routeName, (route) => false);},
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          'or',
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 8.0,
        ),
        SignInButton(
          text: 'Go anonymous',
          textColor: Colors.black,
          color: Color(0xFFDCE775),
          onPressed:() {},
        ),
      ],
    ),
  );
}
}



void _signInWithGoogle(){

}
