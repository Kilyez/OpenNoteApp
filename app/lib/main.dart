
import 'package:app/Common_widgets/bottom_bar.dart';
import 'package:app/app/sign_in/sign_in_form.dart';
import 'package:app/app/sign_in/sign_up_form.dart';
import 'package:app/screens/add_screen.dart';
import 'package:app/screens/user_screen.dart';
import 'package:app/router.dart';
import 'package:app/screens/home_screens.dart';
import 'package:app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'app/sign_in/sign_in.dart';
import 'package:app/utils/user_preferences.dart';
import 'package:provider/provider.dart';
import 'package:app/providers/user_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await UserSharedPreferences.init();
  runApp(MultiProvider(
    providers: [
    ChangeNotifierProvider(create: (context) => UserProvider(),)
    ],
    child: Myapp()));
}

class Myapp extends StatefulWidget {
  const Myapp ({Key? key}) : super(key: key);

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  final AuthService authService = AuthService();

  @override
  void initState(){
    print('here?');
    super.initState();
    authService.getUserData(context: context);
  }


  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NotesForALL',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[100],
        primarySwatch: Colors.indigo,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: Provider.of<UserProvider>(context).user.token.isNotEmpty ? const BottomBar() : SignInModel()
      // Provider.of<UserProvider>(context).user.token.isNotEmpty ? const BottomBar() :
      

    );
  }
}