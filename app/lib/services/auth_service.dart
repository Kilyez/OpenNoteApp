import 'package:app/Models/user.dart';
import 'package:app/constraints/api_path.dart';
import 'package:app/constraints/error_handling.dart';
import 'package:app/constraints/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AuthService{

  void signUpUser({
    required BuildContext context,
    required User user,

  }) async {

    try{
      
      http.Response res = await http.post(
        Uri.parse(uri), 
        body: user.toJson(),
        headers: <String,String>{
          'Content-Type': 'application/json; cahrset=UTF-8',
        }
        );
        httpErrorHandle(response: res, context: context, onSuccess: (){
          showSnackBar(context, 'Account created!');
        });
    }catch(e){
      showSnackBar(context, e.toString());

    }
  }
  
}