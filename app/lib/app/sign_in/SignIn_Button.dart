
import 'package:app/Common_widgets/CustomButton.dart';
import 'package:flutter/material.dart';

class SignInButton extends CustomButton{
  SignInButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) : super(
          child: Text(
            text, 
            style: TextStyle(
              color: textColor,
              fontSize: 15.0)
            ),
            color: color,
            height: 40.0,
            borderRadius: 16.0,
            onPressed: onPressed,
      );
    
}