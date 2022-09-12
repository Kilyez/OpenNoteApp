import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:app/constraints/utils.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess

}){
  switch(response.statusCode){
    case 200:
    onSuccess();
    break;
    case 400:
    showTopSnackBar(
      context,
      CustomSnackBar.error(
        message: jsonDecode(response.body)['message'],
      ),
    );
    break;
    case 500:
    showTopSnackBar(
      context,
      CustomSnackBar.error(
        message: jsonDecode(response.body)['error'],
      ),
    );
    break;
    default:
    showSnackBar(context, response.body);
  }
}
