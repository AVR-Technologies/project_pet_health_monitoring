import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pet_health_monitoring/custom_libs/custom_lib.dart';
import 'package:pet_health_monitoring/pages/dash_board_page.dart';
import 'package:pet_health_monitoring/pages/register_page.dart';
import '../custom_libs/custom_lib.dart';
import '../strings.dart';

class LoginPage extends StatefulWidget{
  @override _LoginPageState createState() { return _LoginPageState(); }
}

class _LoginPageState extends State<LoginPage> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override Widget build(BuildContext context) {
    return FormUi(
      scaffoldKey: scaffoldKey,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          HeaderTile(
            title: 'Login',
          ),
          InputField(
            controller: usernameController,
            labelText: 'Username',
            padding: 10,
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
            title: 'REGISTER INSTEAD',
            onPressed: goToRegisterPage,
            textColor: Colors.indigo[800],
            borderRadius: 20,
          ),
          FlatButtonWithPadding(
            title: 'LOGIN',
            onPressed: login,
            color: Colors.indigo[800],
            textColor: Colors.white,
            borderRadius: 20,
          ),
        ],
      ),);
  }
  login() {
    if(usernameController.text.isNotEmpty && passwordController.text.isNotEmpty){
      LoginHandler.
      login(username: usernameController.text, password: passwordController.text,).
      then((dynamic result){
        if(result['success']){ goToDashBoarPage();}
        else{ displaySnackBar(result['message']); }
      });
    }else{
      displaySnackBar('All fields necessary');
    }
  }
  goToRegisterPage(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }
  goToDashBoarPage(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => DashBoardPage()));
  }
  displaySnackBar(String message){
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}

class LoginHandler {
  static Future<dynamic> login({String username, String password}) async {
    var url = Urls.login_url + withUsername(username) + withPassword(password);
    var response = await http.get(url);
    return json.decode(response.body);
  }
  static String withUsername(String username) { return 'username=' + username + '&'; }
  static String withPassword(String password) { return 'password=' + password; }
}