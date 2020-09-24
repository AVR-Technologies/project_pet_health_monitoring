import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pet_health_monitoring/custom_libs/custom_lib.dart';
import '../custom_libs/custom_lib.dart';
import '../strings.dart';
import 'dash_board_page.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget{
  @override _RegisterPageState createState() { return _RegisterPageState(); }
}

class _RegisterPageState extends State<RegisterPage> {
  var usernameController = TextEditingController();
  var emailController    = TextEditingController();
  var mobileNoController = TextEditingController();
  var passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override void dispose() {
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
    mobileNoController.dispose();
    passwordController.dispose();
  }
  @override Widget build(BuildContext context) {
    return FormUi(
      scaffoldKey: scaffoldKey,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          HeaderTile(
            title: 'Register',
          ),
          InputField(
            controller: usernameController,
            labelText: 'Username',
            padding: 10,
            borderRadius: 30,
          ),
          InputField(
            controller: emailController,
            labelText: 'Email',
            padding: 10,
            keyBoardType: TextInputType.emailAddress,
            borderRadius: 30,
          ),
          InputField(
            controller: mobileNoController,
            labelText: 'Mobile no.',
            padding: 10,
            keyBoardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            borderRadius: 30,
          ),
          InputField(
            controller: passwordController,
            isPassword: true,
            labelText: 'Password',
            padding: 10,
            borderRadius: 30,
          ),
          FlatButtonWithPadding(
            title: 'LOGIN INSTEAD',
            onPressed: goToLoginPage,
            textColor: Colors.indigo[800],
            borderRadius: 20,
          ),
          FlatButtonWithPadding(
            title: 'REGISTER',
            onPressed: register,
            color: Colors.indigo[800],
            textColor: Colors.white,
            borderRadius: 20,
          ),
        ],
      ),
    );
  }
  register() {

    if(usernameController.text.isNotEmpty && emailController.text.isNotEmpty && mobileNoController.text.isNotEmpty && passwordController.text.isNotEmpty){
      RegisterHandler
          .register(
            username: usernameController.text,
            email: emailController.text,
            mobile: mobileNoController.text,
            password: passwordController.text,)
          .then((dynamic result) {
            if(result['success']){ goToDashBoardPage();}
            else{ displaySnackBar(result['message']); }
          });
    }else{
      displaySnackBar('All fields necessary');
    }
  }
  goToLoginPage(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
  goToDashBoardPage(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => DashBoardPage()));
  }
  displaySnackBar(String message){
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}

class RegisterHandler {
  static Future<dynamic> register({String username, String email, String mobile, String password}) async {
    var url = Urls.register_url + withUsername(username) + withEmail(email) + withMobile(mobile) + withPassword(password);
    var response = await http.get(url);
    return json.decode(response.body);
  }
  static String withUsername(String username) { return 'username='  + username  + '&'; }
  static String withEmail(String email)       { return 'email='     + email     + '&'; }
  static String withMobile(String mobile)     { return 'mobile='    + mobile    + '&'; }
  static String withPassword(String password) { return 'password='  + password; }
}