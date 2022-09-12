
import 'package:app/Common_widgets/CustomButton.dart';
import 'package:flutter/material.dart';

class SocialSignInButton extends CustomButton{
  SocialSignInButton({
    required String assetName,
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,

  }) : super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(assetName),
              
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: 15.0),
              ),
              // Opacity(
              //   opacity: 0,
              //   child: Image.asset('images/google-logo.png')
              // ),
              SizedBox(width: 10,)
            ],
          ),
            color: color,
            height: 40.0,
            borderRadius: 16.0,
            onPressed: onPressed,
      );
    
}