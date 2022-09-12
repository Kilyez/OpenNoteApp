import 'package:app/app/sign_in/sign_in_form.dart';
import 'package:app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/Models/user.dart';
import 'package:email_validator/email_validator.dart';

class SignUpModel extends StatefulWidget {
  static const String routeName = '/SignUp';
  SignUpModel({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpModel> {
  final _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  User user = User('', '', '','');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      reverse: true,
      child: Stack(children: _buildContent()),
    ));
  }

  List<Widget> _buildContent() {
    return [
      Positioned(
          top: 0,
          child: SvgPicture.asset(
            'images/top.svg',
            width: 400,
            height: 150,
          )),
      _buildForm(),
    ];
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 170,
          ),
          Text(
            "Sign Up",
            style: GoogleFonts.pacifico(
                fontWeight: FontWeight.bold, fontSize: 50, color: Colors.blue),
          ),
          SizedBox(
            height: 50,
          ),
          _buildEmailTextField(),
          SizedBox(height: 16.0),
          _buildPasswordTextField(),
          SizedBox(height: 32.0),
          _buildButton(),
          SizedBox(height: 10.0),
          _buildTextLink()
        ],
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        controller: TextEditingController(text: user.password),
        onChanged: (value) {
          user.password = value;
        },
        validator: (value) => validatePassword(value),
        decoration: InputDecoration(
            hintText: 'Inserisci password',
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.blue)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.blue)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red))),
      ),
    );
  }

  Widget _buildEmailTextField() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: TextEditingController(text: user.password),
        onChanged: (value) {
          user.email = value;
        },
        validator: (value) => validateEmail(value),
        decoration: InputDecoration(
            hintText: 'Inserisci email',
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.blue)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.blue)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red))),
      ),
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: SizedBox(
        height: 50.0,
        width: 400.0,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
            ),
            child: Text(
              "Sign up",
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            onPressed: () => signUpUser()),
      ),
    );
  }

  Widget _buildTextLink() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'sei iscritto?',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 6),
            InkWell(
              onTap: () {Navigator.pushNamedAndRemoveUntil(context, SignInModel.routeName, (route) => false);},
              child: Text(
                'Accedi',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ));
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your email';
    } else if (!EmailValidator.validate(value)) {
      return 'Enter valid email';
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your password';
    } else if (value.length < 6) {
      return 'password must have 6 character at least';
    }
  }

  void signUpUser() {
    if (_formKey.currentState!.validate()) {
      authService.signUpUser(context: context, user: user);
    }
  }
}
