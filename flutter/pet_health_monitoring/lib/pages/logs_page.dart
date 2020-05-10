import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pet_health_monitoring/custom_libs/custom_lib.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../strings.dart';
import 'add_pet_page.dart';
//compiling for web is failed hence in package
// /C:/Devolopment/flutter/.pub-cache/hosted/pub.dartlang.org/syncfusion_flutter_charts-17.4.46/lib/src/circular_chart/utils/helper.d
//art:22:47:
// is commented
class LogsPage extends StatefulWidget{
  final String id;
  const LogsPage({Key key, this.id}) : super(key: key);
  @override _LogsPageState createState() {
    return _LogsPageState();
  }
}

class _LogsPageState extends State<LogsPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<TemperatureLogs> data = new List();
  @override void initState() {
    super.initState();
    refreshTempLogsOfThisWeek();
  }
  @override Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.id,),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text('Add'),
            onPressed: goToAddPetPage,
            textColor: Colors.white,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buttonBar(),
            chartWidget(),
          ],
        ),
      ),
    );
  }
  Widget chartWidget(){
    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
        height: MediaQuery.of(context).size.height*0.8,
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Time'),),
          primaryYAxis: NumericAxis(title: AxisTitle(text: 'temperature (C)')),
          title: ChartTitle(text: 'Temperature log'),
          tooltipBehavior: TooltipBehavior(enable: true,),
          series: <ChartSeries<TemperatureLogs, DateTime>>[
            LineSeries<TemperatureLogs, DateTime>(
              dataSource: data,
              xValueMapper: (TemperatureLogs logs, _) => logs.time,
              yValueMapper: (TemperatureLogs logs, _) => logs.temperature,
              dataLabelSettings: DataLabelSettings(isVisible: true),
              markerSettings: MarkerSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }
  Widget buttonBar(){
    return Padding(
      padding: EdgeInsets.only(
          left: 20,
          right: 20
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ElevatedButton(
            paddingLeft: 4,
            onPressed: refreshTempLogsOfThisMonth,
            title: 'This month',
            borderRadius: 4,
            textColor: Colors.white,
            color: Colors.red,
          ),
          ElevatedButton(
            paddingLeft: 4,
            onPressed: refreshTempLogsOfThisWeek,
            title: 'This week',
            borderRadius: 4,
            textColor: Colors.white,
            color: Colors.red,
          ),
          ElevatedButton(
            paddingLeft: 4,
            onPressed: refreshTempLogsOfToday,
            title: 'Today',
            borderRadius: 4,
            textColor: Colors.white,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
  goToAddPetPage(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddPetPage()));
  }
  refreshTempLogsOfToday(){
    GetTempLogsHandler.get(duration: '1', collarId: widget.id).then((dynamic result){
      if(result['success']){
        setState(() {
          data.clear();
          List<dynamic> tempLogs = result['data'];
          for(var tempLogEntry in tempLogs){
            data.add(TemperatureLogs.fromDynamic(tempLogEntry));
          }
        });
      }
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(result['message']),));
    });
  }
  refreshTempLogsOfThisWeek(){
    GetTempLogsHandler.get(duration: '7', collarId: widget.id).then((dynamic result){
      if(result['success']){
        setState(() {
          data.clear();
          List<dynamic> tempLogs = result['data'];
          for(var tempLogEntry in tempLogs){
            data.add(TemperatureLogs.fromDynamic(tempLogEntry));
          }
        });
      }
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(result['message']),));
    });
  }
  refreshTempLogsOfThisMonth(){
    GetTempLogsHandler.get(duration: '31', collarId: widget.id).then((dynamic result){
      if(result['success']){
        setState(() {
          data.clear();
          List<dynamic> tempLogs = result['data'];
          for(var tempLogEntry in tempLogs){
            data.add(TemperatureLogs.fromDynamic(tempLogEntry));
          }
        });
      }
      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(result['message']),));
    });
  }
}
class GetTempLogsHandler {
  static Future<dynamic> get({String duration, String collarId}) async {
    var url = Urls.get_temp_logs_url + withDuration(duration) + withCollarId(collarId);
    var response = await http.get(url);
    return json.decode(response.body);
  }
  static String withDuration(String duration) { return 'duration=' + duration + '&'; }
  static String withCollarId(String collarId) { return 'collarId=' + collarId;}
}

class TemperatureLogs {
  DateTime time;
  int temperature;
  TemperatureLogs(this.time, this.temperature);
  TemperatureLogs.fromDynamic(dynamic map) {
    this.temperature = int.parse(map['temperature']);
    this.time = /*DateFormat("dd/MM/yyyy HH:mm:ss")*/DateTime.parse(map['time']);
  }
}