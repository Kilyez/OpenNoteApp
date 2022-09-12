import 'package:app/app/sign_in/sign_in_form.dart';
import 'package:app/app/sign_in/sign_up_form.dart';
import 'package:app/Common_widgets/bottom_bar.dart';
import 'package:app/screens/home_screens.dart';
import 'package:flutter/material.dart';


Route<dynamic> generateRoute(RouteSettings routeSettings){
  switch(routeSettings.name){
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen()
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => BottomBar()
      );
    case SignUpModel.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SignUpModel()
    );
    case SignInModel.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SignInModel()
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist'),
          ),
        )
      );
      
  }
}