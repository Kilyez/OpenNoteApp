import 'package:app/app/sign_in/sign_up_form.dart';
import 'package:flutter/material.dart';
import 'app/sign_in/sign_in.dart';
import 'package:app/utils/user_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSharedPreferences.init();

  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NotesForALL',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: SignUpModel()
    );
  }
}