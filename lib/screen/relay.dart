// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// enum RelayStatus { On, Off, Unknown }

// class RelayStatuss extends StatefulWidget {
//   const RelayStatuss({super.key});
//   static const routename = '/relay';

//   @override
//   State<RelayStatuss> createState() => _RelayStatussState();
// }

// class _RelayStatussState extends State<RelayStatuss> {
//   String thingspeakApiKey = 'OWELSEN5P6UA68M8'; // Replace with your API Key
//   String thingspeakChannelId = '2388247'; // Replace with your Channel ID
//   int relayControlField =
//       1; // Field number in your ThingSpeak channel (replace if needed)

// //enum RelayStatus { On, Off, Unknown }

//   void turnRelayOn() async {
//     try {
//       final url = Uri.parse(
//           'https://api.thingspeak.com/update?api_key=$thingspeakApiKey&field=$relayControlField&value=1');
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         print('Relay turned on successfully!');
//         updateRelayStatus(RelayStatus.On);
//       } else {
//         print('Error turning on relay: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('Error: $error');
//     }
//   }

//   void turnRelayOff() async {
//     try {
//       final url = Uri.parse(
//           'https://api.thingspeak.com/update?api_key=$thingspeakApiKey&field=$relayControlField&value=0');
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         print('Relay turned off successfully!');
//         updateRelayStatus(RelayStatus.Off);
//       } else {
//         print('Error turning off relay: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('Error: $error');
//     }
//   }

//   RelayStatus _relayStatus = RelayStatus.Unknown;

//   void updateRelayStatus(RelayStatus newStatus) {
//     setState(() {
//       _relayStatus = newStatus;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Relay Control App'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               _relayStatus == RelayStatus.On
//                   ? 'Relay: ON'
//                   : (_relayStatus == RelayStatus.Off
//                       ? 'Relay: OFF'
//                       : 'Relay Status: Unknown'),
//               style: TextStyle(fontSize: 20),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: turnRelayOn,
//               child: const Text('Turn Relay ON'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: turnRelayOff,
//               child: const Text('Turn Relay OFF'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class RelayStatusScreen extends StatefulWidget {
//   @override
//   _RelayStatusScreenState createState() => _RelayStatusScreenState();
//   static const routename = '/relay';
// }

// class _RelayStatusScreenState extends State<RelayStatusScreen> {
//   String relayStatus = 'Unknown';

//   @override
//   void initState() {
//     super.initState();
//     fetchRelayStatus(); // Fetch relay status when the screen initializes
//   }

//   Future<void> fetchRelayStatus() async {
//     final url = Uri.parse(
//         "https://api.thingspeak.com/channels/2388247/feeds.json?api_key=OWELSEN5P6UA68M8&results=1");
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       final status = jsonData['field3']; // Field 3 contains the relay status
//       setState(() {
//         relayStatus = status == '1'
//             ? 'On'
//             : 'Off'; // Assuming '1' represents on and '0' represents off
//       });
//     } else {
//       setState(() {
//         relayStatus = 'Failed to fetch status';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Relay Status'),
//       ),
//       body: Center(
//         child: Text(
//           'Relay Status: $relayStatus',
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: fetchRelayStatus, // Refresh relay status on button press
//         child: Icon(Icons.refresh),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RelayStatusScreen extends StatefulWidget {
  @override
  _RelayStatusScreenState createState() => _RelayStatusScreenState();
  static const routeName = '/relay';
}

class RelayFeed {
  final String field3;

  RelayFeed({required this.field3});

  factory RelayFeed.fromJson(Map<String, dynamic> json) {
    return RelayFeed(
      field3: json['field4'],
    );
  }
}

class _RelayStatusScreenState extends State<RelayStatusScreen> {
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
  //           print(fields["field4"]);
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
        relayStatus = status == '0'
            ? 'On'
            : 'Off'; // Assuming '1' represents on and '0' represents off
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
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Relay Status'),
      // ),
      body: Center(
        child: Text(
          'Relay Status: $relayStatus',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchRelayStatus,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
