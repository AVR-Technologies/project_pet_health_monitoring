import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pet_health_monitoring/custom_libs/custom_lib.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../custom_libs/custom_lib.dart';
import '../strings.dart';
import 'package:intl/intl.dart';
import 'add_pet_page.dart';
//in syncfusion_flutter_charts-17.4.46
//[   +6 ms] Target dart2js failed: Exception:
//C:/Devolopment/flutter/.pub-cache/hosted/pub.dartlang.org/syncfusion_flutter_charts-17.4.46/lib/src/common/user_interaction/tooltip.dart:345:52:
//           Error: Constant evaluation error:
//             void hide() => _painter._calculateLocation(const Offset(null, null));
//
// only const is commented
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
    refreshTempLogsOfLastYear();
  }
  @override Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.id,),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text('ADD'),
            hoverColor: Colors.indigo[900],
            onPressed: goToAddPetPage,
            textColor: Colors.white,
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          buttonBar(),
          chartWidget(),
        ],
      ),
    );
  }
  Widget buttonBar(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ButtonWithPadding(
            paddingLeft: 4,
            onPressed: refreshTempLogsOfLastMonth,
            title: 'THIS MONTH',
            borderRadius: 4,
            textColor: Colors.white,
            color: Colors.red,
          ),
          ButtonWithPadding(
            paddingLeft: 4,
            onPressed: refreshTempLogsOfLastWeek,
            title: 'THIS WEEK',
            borderRadius: 4,
            textColor: Colors.white,
            color: Colors.red,
          ),
          ButtonWithPadding(
            paddingLeft: 4,
            onPressed: refreshTempLogsOfLastDay,
            title: 'TODAY',
            borderRadius: 4,
            textColor: Colors.white,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
  Widget chartWidget(){
    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
        height: MediaQuery.of(context).size.height*0.8,
        child: SfCartesianChart(
          primaryXAxis: DateTimeAxis( title: AxisTitle(text: 'Time')),
          primaryYAxis: NumericAxis( title: AxisTitle(text: 'temperature (°C)')),
          title: ChartTitle(text: 'Temperature log'),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            tooltipPosition: TooltipPosition.pointer,
            builder: (_, point,__, ___,____){
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Temp: ' + (point as CartesianChartPoint<dynamic>).y.toString() + ' °C'),
                      Text('Time: ' + DateFormat("hh:mm:ss").format((point as CartesianChartPoint<dynamic>).x) ),
                      Text('Date: ' + DateFormat("dd/MM/yyyy").format((point as CartesianChartPoint<dynamic>).x) ),
                    ],
                  ),
                ),
              );
            }
          ),
          legend: Legend(
            isVisible: true,
            position: LegendPosition.top
          ),
          series: <ChartSeries<TemperatureLogs, DateTime>>[
            LineSeries<TemperatureLogs, DateTime>(
              name: 'Temperature',
              enableTooltip: true,
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
  refreshTempLogsOfLastDay(){
    fetchData('1');
  }
  refreshTempLogsOfLastWeek(){
    fetchData('7');
  }
  refreshTempLogsOfLastMonth(){
    fetchData('31');
  }
  refreshTempLogsOfLastYear(){
    fetchData('365');
  }
  fetchData(String days){
    GetTempLogsHandler.
    get(duration: days, collarId: widget.id).
    then((dynamic result){
      if(result['success']){
        setState(() {
          data.clear();
          List<dynamic> tempLogs = result['data'];
          for(var tempLogEntry in tempLogs){
            data.add(TemperatureLogs.fromDynamic(tempLogEntry));
          }
        });
      }
      displaySnackBar(result['message']);
    });
  }
  goToAddPetPage(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddPetPage()));
  }
  displaySnackBar(String message){
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
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
    //this.time = /*DateFormat("dd/MM/yyyy HH:mm:ss")*/DateTime.parse(map['time']);//2020-02-07 11:57:01
    this.time = DateFormat("dd-MM-yyyy HH:mm:ss").parse(map['time']);
  }
}