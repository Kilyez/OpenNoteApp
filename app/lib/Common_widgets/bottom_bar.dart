import 'package:app/app/sign_in/sign_in_form.dart';
import 'package:app/screens/add_screen.dart';
import 'package:app/screens/home_screens.dart';
import 'package:app/utils/user_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:app/screens/user_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});
  static const String routeName = '/bottomBar';

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  List<Widget> pages = [
    const UserScreen(),
    const HomeScreen(),
    const AddNote(),
  ];
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Note for All',
          style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 23.0),
        ),
        leading:IconButton(icon: Icon(CupertinoIcons.moon_stars), onPressed: () {}) ,
        actions: [
          IconButton(icon: Icon(Icons.logout_sharp), onPressed: logout)
        ],
        elevation: 2.0,
      ),
        body: pages[_page],
        bottomNavigationBar: CurvedNavigationBar(
          
          backgroundColor: Colors.indigo,
          key: _bottomNavigationKey,
          items: const <Widget>[
            Icon(Icons.person, size: 30),
            Icon(Icons.home, size: 30),
            Icon(Icons.add, size: 30),
          ],
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
        ));
        
  }

  void logout(){
    UserSharedPreferences.clear();
    Navigator.pushNamedAndRemoveUntil(context, SignInModel.routeName, (route) => false);
  }

   
}