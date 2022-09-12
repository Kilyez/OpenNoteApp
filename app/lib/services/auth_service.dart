import 'dart:convert';

import 'package:app/Common_widgets/bottom_bar.dart';
import 'package:app/Models/user.dart';
import 'package:app/constraints/api_path.dart';
import 'package:app/constraints/error_handling.dart';
import 'package:app/constraints/utils.dart';
import 'package:app/providers/user_provider.dart';
import 'package:app/screens/home_screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:app/utils/user_preferences.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../providers/user_provider.dart';

class AuthService {
  void signUpUser({
    required BuildContext context,
    required User user,
  }) async {
    try {
      http.Response res = await http.post(Uri.parse(signUpuri),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; cahrset=UTF-8',
          });
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            showTopSnackBar(
              context,
              CustomSnackBar.success(
                message: "Account created successfully!",
              ),
            );

            Provider.of<UserProvider>(context, listen: false).setUser(res.body);
            await UserSharedPreferences.setUserToken(
                jsonDecode(res.body)['token']);
            Navigator.pushNamedAndRemoveUntil(
                context, BottomBar.routeName, (route) => false);
          });
    } catch (e) {
     showTopSnackBar(
      context,
      CustomSnackBar.error(
        message: e.toString(),
      ),
    );
    }
  }

  void signInUser({
    required BuildContext context,
    required User user,
  }) async {
    try {
      http.Response res = await http.post(Uri.parse(signInuri),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; cahrset=UTF-8',
          });
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            Provider.of<UserProvider>(context, listen: false).setUser(res.body);
            await UserSharedPreferences.setUserToken(
                jsonDecode(res.body)['token']);
            Navigator.pushNamedAndRemoveUntil(
                context, BottomBar.routeName, (route) => false);
          });
    } catch (e) {
      showTopSnackBar(
      context,
      CustomSnackBar.error(
        message: e.toString(),
      ),
    );
    }
  }

  void getUserData({
    required BuildContext context,
  }) async {
    try {
      String? token = UserSharedPreferences.getToken();
      if (token == null) {
        await UserSharedPreferences.setUserToken("");
        token = "";
      }

      var tokenRes = await http.post(Uri.parse(validateTokenuri),
          headers: <String, String>{
            'Content-Type': 'application/json; cahrset=UTF-8',
            'token': token
          });

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(Uri.parse(getUseruri),
            headers: <String, String>{
              'Content-Type': 'application/json; cahrset=UTF-8',
              'token': token
            });
        print('HERE HERE ' + userRes.body);
        Provider.of<UserProvider>(context, listen: false).setUser(userRes.body);
      }
    } catch (e) {
      
      showTopSnackBar(
      context,
      CustomSnackBar.error(
        message: e.toString(),
      ),
    );
    }
  }
}
