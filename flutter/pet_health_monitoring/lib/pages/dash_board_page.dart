import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pet_health_monitoring/pages/add_pet_page.dart';
import 'package:pet_health_monitoring/pages/logs_page.dart';
import 'package:pet_health_monitoring/strings.dart';

class DashBoardPage extends StatefulWidget{

	@override _DashBoardPageState createState() {
		return _DashBoardPageState();
	}
}

class _DashBoardPageState extends State<DashBoardPage> {
	List<Pet> pets = List();
	final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
	@override void initState() {
		super.initState();
		refreshPetList();
	}
	@override Widget build(BuildContext context) {
		return Scaffold(
			key: scaffoldKey,
			appBar: AppBar(
				title: Text('Dashboard'),
				centerTitle: true,
				actions: <Widget>[
					FlatButton(
						child: Text('Add'),
						onPressed: goToAddPetPage,
						textColor: Colors.white,
					),
					FlatButton(
						child: Text('Refresh'),
						onPressed: refreshPetList,
						textColor: Colors.white,
					),
				],
			),
			body: Container(
				decoration: BoxDecoration(
					image: DecorationImage(
						image: AssetImage(AssetsImages.farm),
						fit: BoxFit.cover,
					),
				),
				width: MediaQuery.of(context).size.width,
				height: MediaQuery.of(context).size.height,
				child: Center(
				  child: Container(
						width: MediaQuery.of(context).size.width > 500 ? 500 : MediaQuery.of(context).size.width,
				    child: ListView.builder(
				    	itemCount: pets.length,
				    	itemBuilder: (context,index) { return petCard(pets[index]); }),
				  ),
				),
			),
		);
	}
	Widget petCard(Pet pet){
		return Card(
			child: InkWell(
				onTap: (){
					Navigator.push(context, MaterialPageRoute(builder: (context) => LogsPage(id: pet.collarId)));
				},
				child: Container(
					child: Row(
						children: <Widget>[
							Padding(
								padding: const EdgeInsets.all(10),
								child: Icon(Icons.pets, size: 40, color: Colors.indigo[500],),
							),
							Padding(
								padding: const EdgeInsets.all(10),
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									mainAxisAlignment: MainAxisAlignment.start,
									children: <Widget>[
										Text(pet.collarId, style: Theme.of(context).textTheme.headline6,),
										Text('Breed: ${pet.breed}', style: Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 14,),)
									],
								),
							),
							Spacer(),
							Padding(
								padding: const EdgeInsets.all(10),
								child: CircleAvatar(
									backgroundColor: Colors.grey[600],
									foregroundColor: Colors.white,
									child: Text(pet.age),),
							),
						],
					),
				),
			),
		);
	}
	refreshPetList() {
    PetsCardHandler().getList().then((result) {
			if(result['success']){
				setState(() {
					pets.clear();
					for(dynamic item in result['data']){
						pets.add(Pet.fromDynamic(item));
					}
				});
			}else{
				scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(result['message']),));
			}
    });
	}
	goToAddPetPage(){
		Navigator.push(context, MaterialPageRoute(builder: (context) => AddPetPage()));
	}
	
}
class PetsCardHandler{
	Future<dynamic> getList() async{
		var response = await http.get(Urls.pet_list_url);
		return json.decode(response.body);
	}
}

class Pet{
	String collarId;
	String breed;
	String age;
	Pet({this.collarId, this.breed, this.age});
	Pet.fromDynamic(dynamic map) {
		this.collarId = map['collarId'];
		this.breed = map['breed'];
		this.age = map['age'];
	}
}