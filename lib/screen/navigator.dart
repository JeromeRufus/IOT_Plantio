import 'package:flutter/material.dart';
import 'package:plant/screen/classification.dart';
import 'package:plant/screen/relay.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NavigatorButton extends StatefulWidget {
  const NavigatorButton({super.key});

  @override
  _NavigatorButtonState createState() => _NavigatorButtonState();
}

class RelayFeed {
  final String field3;

  RelayFeed({required this.field3});

  factory RelayFeed.fromJson(Map<String, dynamic> json) {
    return RelayFeed(
      field3: json['field3'],
    );
  }
}

class _NavigatorButtonState extends State<NavigatorButton> {
  String relayStatus = 'Unknown';

  @override
  void initState() {
    super.initState();
    fetchRelayStatus(); // Fetch relay status when the screen initializes
  }

  // Future<void> fetchRelayStatus() async {
  //   final url = Uri.parse(
  //       "https://api.thingspeak.com/channels/2452869/feeds.json?api_key=I8NKYUZPL080I43Y&results=1");
  //   try {
  //     while (true) {
  //       final response = await http.get(url);

  //       if (response.statusCode == 200) {
  //         Map<String, dynamic> jsonData = json.decode(response.body);
  //         Map<String, dynamic> fields = jsonData['feeds'][0];

  //         setState(() {
  //           relayStatus = fields["field4"] == '0' ? 'On' : 'Off';
  //           //print(fields["field4"]);
  //         });
  //       } else {
  //         setState(() {
  //           relayStatus = 'Failed to fetch status';
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     setState(() {
  //       relayStatus = 'Error: $e';
  //     });
  //   }
  // }

  Future<void> fetchRelayStatus() async {
    final url = Uri.parse(
        "https://api.thingspeak.com/channels/2452869/feeds.json?api_key=I8NKYUZPL080I43Y&results=1");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final status = jsonData['field4']; // Field 3 contains the relay status
      setState(() {
        relayStatus = status == '1'
            ? 'Off'
            : 'On'; // Assuming '1' represents on and '0' represents off
        print(relayStatus);
      });
    } else {
      setState(() {
        relayStatus = 'Failed to fetch status';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 30.0),
            alignment: Alignment.centerLeft,
            width: 450,
            height: 75.0,
            child: Text(
              "Plant Assistance",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.white,
                  color: const Color.fromARGB(255, 112, 171, 219)),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Card(
              color: Color.fromARGB(255, 187, 226, 142),
              // child: Container(
              //   margin: EdgeInsets.only(right: 20.0),
              //   child: InkWell(
              //   onTap: () => Navigator.of(context)
              //       .pushNamed(RelayStatusScreen.routeName),
              child: Container(
                width: 550,
                height: 90.0,
                // decoration: BoxDecoration(
                //   //color: Color.fromARGB(255, 129, 187, 62),
                //   border: Border.all(color: Colors.white, width: 2.0),
                //   borderRadius: BorderRadius.circular(10.0),
                // ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Title(
                          color: Colors.black,
                          child: Text(
                            'Relay Status: $relayStatus',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 34, 79, 102),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: fetchRelayStatus,
                        ),
                      ],
                    ),
                    // Text(
                    //   "Turn ON/OFF",
                    //   style: TextStyle(fontWeight: FontWeight.normal),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          //   ),
          // ),
          // child: Card(
          //   color: Color.fromARGB(255, 187, 226, 142),
          //   child: Container(
          //     margin: EdgeInsets.only(right: 20.0),
          //     child: InkWell(
          //       onTap: () => Navigator.of(context)
          //           .pushNamed(RelayStatusScreen.routeName),
          //       child: Container(
          //         width: 450,
          //         height: 75.0,
          //         // decoration: BoxDecoration(
          //         //   //color: Color.fromARGB(255, 129, 187, 62),
          //         //   border: Border.all(color: Colors.white, width: 2.0),
          //         //   borderRadius: BorderRadius.circular(10.0),
          //         // ),
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: [
          //             Title(
          //               color: Colors.black,
          //               child: Text(
          //                 "Control Pump",
          //                 textAlign: TextAlign.left,
          //                 style: TextStyle(
          //                   fontSize: 24,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ),
          //             Text(
          //               "Turn ON/OFF",
          //               style: TextStyle(fontWeight: FontWeight.normal),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Card(
              color: Color.fromARGB(255, 116, 164, 60),
              child: Container(
                margin: EdgeInsets.only(right: 20.0),
                child: InkWell(
                  onTap: () =>
                      Navigator.of(context).pushNamed(ImageAnalyze.routName),
                  child: Container(
                    width: 450,
                    height: 75.0,
                    // decoration: BoxDecoration(
                    //   //color: Color.fromARGB(255, 129, 187, 62),
                    //   border: Border.all(color: Colors.white, width: 2.0),
                    //   borderRadius: BorderRadius.circular(10.0),
                    // ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Title(
                          color: Colors.white,
                          child: Text(
                            "Health Check",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          "Take a photo of your plant",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
