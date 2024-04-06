import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class Data extends StatefulWidget {
  // Constructor to initialize temperature and humidity
  static const routename = '/data';
  Data(
    this.humid,
    this.temp,
    this.mois, {
    Key? key,
  }) : super(key: key);

  // Fields to hold temperature and humidity values
  String temp;
  String humid;
  String mois;

  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  late List<DataPoint> _tempData = [];
  late List<DataPoint> _humidData = [];
  late List<DataPoint> _moisData = [];
  late bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    fetchDataFromThingSpeak();
  }

  @override
  void dispose() {
    _isDisposed = true; // Set _isDisposed to true when disposing the widget
    super.dispose();
  }

  Future<void> fetchDataFromThingSpeak() async {
    var url = Uri.parse(
        "https://api.thingspeak.com/channels/2452869/feeds.json?api_key=I8NKYUZPL080I43Y&results=3");
    while (true) {
      var result = await http.get(url);
      Map<String, dynamic> feeds = jsonDecode(result.body);
      Map<String, dynamic> fields = feeds["feeds"][0];

      setState(() {
        widget.temp = fields["field1"];
        widget.humid = fields["field2"];
        widget.mois = fields["field3"];
        _tempData
            .add(DataPoint("Temperature", double.tryParse(widget.temp) ?? 0.0));
        _humidData
            .add(DataPoint("Humidity", double.tryParse(widget.humid) ?? 0.0));
        _moisData.add(
            DataPoint("Soil Moisture", double.tryParse(widget.mois) ?? 0.0));
      });

      await Future.delayed(Duration(seconds: 5));

      if (_isDisposed) {
        break; // Break the loop if the widget is disposed
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('ThingSpeak Chart'),
      // ),
      body: Center(
        child: (_tempData.isNotEmpty && _humidData.isNotEmpty)
            ? Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SfCartesianChart(
                        title: ChartTitle(text: 'Temperature'),
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(),
                        series: <CartesianSeries<DataPoint, String>>[
                          LineSeries<DataPoint, String>(
                            dataSource: _tempData,
                            xValueMapper: (DataPoint dp, _) => dp.label,
                            yValueMapper: (DataPoint dp, _) => dp.value,
                            trendlines: [Trendline()],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: SfCartesianChart(
                        title: ChartTitle(text: 'Humidity'),
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(),
                        series: <CartesianSeries<DataPoint, String>>[
                          LineSeries<DataPoint, String>(
                            dataSource: _humidData,
                            xValueMapper: (DataPoint dp, _) => dp.label,
                            yValueMapper: (DataPoint dp, _) => dp.value,
                            trendlines: [Trendline()],

                            //color: Colors.cyanAccent,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: SfCartesianChart(
                        title: ChartTitle(text: 'Soil Moisture'),
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(),
                        series: <CartesianSeries<DataPoint, String>>[
                          LineSeries<DataPoint, String>(
                            dataSource: _moisData,
                            xValueMapper: (DataPoint dp, _) => dp.label,
                            yValueMapper: (DataPoint dp, _) => dp.value,
                            trendlines: [Trendline()],

                            //color: Colors.cyanAccent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}

// Method to convert temperature and humidity values into chart data points
// List<DataPoint> getChartData() {
//   final List<DataPoint> chartData = [
//     DataPoint("Temperature", double.tryParse(widget.temp) ?? 0.0),
//     DataPoint("Humidity", double.tryParse(widget.humid) ?? 0.0),
//   ];
//   return chartData;
// }

// Class to represent a data point
class DataPoint {
  DataPoint(this.label, this.value);
  final String label;
  final double value;
}
