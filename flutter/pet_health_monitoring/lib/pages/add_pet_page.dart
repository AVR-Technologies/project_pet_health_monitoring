import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_health_monitoring/custom_libs/custom_lib.dart';
import 'package:http/http.dart' as http;
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
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetsImages.farm),
            fit: BoxFit.cover,
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: MediaQuery.of(context).size.width <= 500 ? addPetUi() : CenterCard(child: addPetUi(),),),
    );
  }
  Widget addPetUi() {
    return ListView(
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
          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          borderRadius: 30,
        ),
        UnElevatedButton(
          title: 'Go Back',
          onPressed: () {
            Navigator.pop(context);
          },
          textColor: Colors.indigo[800],
          borderRadius: 20,
        ),
        UnElevatedButton(
          title: 'Save',
          onPressed: save,
          color: Colors.indigo[800],
          textColor: Colors.white,
          borderRadius: 20,
        ),
      ],
    );
  }

  save() {
    AddPetHandler
        .save( collarId: collarIdController.text, breed: breedController.text, age: ageController.text,)
        .then((dynamic result) { scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(result['message']),));});
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