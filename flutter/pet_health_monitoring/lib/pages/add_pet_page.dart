import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_health_monitoring/custom_libs/custom_lib.dart';
import 'package:http/http.dart' as http;
import '../custom_libs/custom_lib.dart';
import '../strings.dart';

class AddPetPage extends StatefulWidget{
  @override _AddPetPageState createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  var collarIdController = TextEditingController();
  var breedController = TextEditingController();
  var ageController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override Widget build(BuildContext context) {
    return FormUi(
      scaffoldKey: scaffoldKey,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          HeaderTile(
            title: 'Add pet',
          ),
          InputField(
            controller: collarIdController,
            labelText: 'Collar Id',
            padding: 10,
            borderRadius: 30,
          ),
          InputField(
            controller: breedController,
            labelText: 'Breed',
            padding: 10,
            borderRadius: 30,
          ),
          InputField(
            controller: ageController,
            labelText: 'Age',
            padding: 10,
            maxLength: 3,
            keyBoardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            borderRadius: 30,
          ),
          FlatButtonWithPadding(
            title: 'BACK',
            onPressed: () { Navigator.pop(context); },
            textColor: Colors.indigo[800],
            borderRadius: 20,
          ),
          FlatButtonWithPadding(
            title: 'SAVE',
            onPressed: save,
            color: Colors.indigo[800],
            textColor: Colors.white,
            borderRadius: 20,
          ),
        ],
      ),
    );
  }

  save() {
    if(collarIdController.text.isNotEmpty && breedController.text.isNotEmpty && ageController.text.isNotEmpty) {
      AddPetHandler.
      save(collarId: collarIdController.text, breed: breedController.text, age: ageController.text,).
      then((dynamic result) { displaySnackBar(result['message']); });
    }else{
      displaySnackBar('All fields necessary');
    }
  }

  displaySnackBar(String message){
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}

class AddPetHandler {
  static Future<dynamic> save({String collarId, String breed, String age}) async {
    var url = Urls.add_pet_url + withCollarId(collarId) + withBreed(breed) + withAge(age);
    var response = await http.get(url);
    return json.decode(response.body);
  }
  static String withCollarId(String collarId) { return 'collarId='  + collarId  + '&'; }
  static String withBreed(String breed)       { return 'breed='     + breed     + '&';}
  static String withAge(String age)           { return 'age='       + age; }
}