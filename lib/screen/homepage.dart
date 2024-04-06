import 'dart:async';

import 'dart:io';
import 'dart:math';
//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant/screen/navigator.dart';
import 'package:plant/screen/thingspeak.dart';
//import 'package:file/file.dart';
import 'package:tflite/tflite.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  //const HomePage({super.key});
  static const routeName = '/homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

// var valueChoose;
// List year = ["2024", "2023", "2022", "2021", "2020"];
// List brand = ["Ford", "Hyundai", "Honda"];
// List model = ["Endeavour", "Figo", "Fiesta"];
// List variant = ["Petrol", "Disel", "Hybird", "CNG"];
// List location = ["Chennai", "Bengalaru", "Hyerabad"];
// List ownership = ["1", "2", "3", "4", "5"];
// List condition = ["Good", "Average", "Bad"];

class _HomePageState extends State<HomePage> {
  List? _outputs;
  File? _image;

  //final _picker = ImagePicker();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  String greetingMessage() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   title: Text(
      //     'Crop Disease Classifier',
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontWeight: FontWeight.w500,
      //       fontSize: 23,
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bd.jpg'),
                fit: BoxFit.contain,
              ),
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 15.0),
                  child: FittedBox(
                    child: Text(
                      greetingMessage(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: const Color.fromARGB(255, 93, 107, 187),
                      ),
                    ),
                    //size: 25,
                  ),
                ),
                //color: Color.fromRGBO(68, 190, 255, 0.8)
                TpSub("0", "0", "0"),
                SizedBox(
                  height: 5,
                ),
                NavigatorButton(),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 35, vertical: 40),
                //   child: Container(
                //     alignment: Alignment.center,
                //     padding: EdgeInsets.all(50),
                //     decoration: BoxDecoration(
                //       color: Colors.indigo,
                //       borderRadius: BorderRadius.circular(30),
                //     ),
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Container(
                //           child: Center(
                //             child: _loading == true
                //                 ? null //show nothing if no picture selected
                //                 : Container(
                //                     child: Column(
                //                       children: [
                //                         Container(
                //                           height:
                //                               MediaQuery.of(context).size.width *
                //                                   0.5,
                //                           width: MediaQuery.of(context).size.width *
                //                               0.5,
                //                           child: ClipRRect(
                //                             borderRadius: BorderRadius.circular(30),
                //                             child: _image != null
                //                                 ? Image.file(
                //                                     _image!,
                //                                     fit: BoxFit.fill,
                //                                   )
                //                                 : const Center(
                //                                     child: Text(
                //                                       'No image selected', // Show a message when no image is selected
                //                                       style: TextStyle(
                //                                         color: Colors.white,
                //                                         fontSize: 18,
                //                                         fontWeight: FontWeight.w400,
                //                                       ),
                //                                     ),
                //                                   ),
                //                           ),
                //                         ),
                //                         Divider(
                //                           height: 25,
                //                           thickness: 1,
                //                         ),
                //                         // ignore: unnecessary_null_comparison
                //                         _outputs != null
                //                             ? Text(
                //                                 'This is: ${_outputs![0]['label']}',
                //                                 style: TextStyle(
                //                                   color: Colors.white,
                //                                   fontSize: 18,
                //                                   fontWeight: FontWeight.w400,
                //                                 ),
                //                               )
                //                             : Container(),
                //                         Divider(
                //                           height: 25,
                //                           thickness: 1,
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //           ),
                //         ),
                //         Container(
                //           child: Column(
                //             children: [
                //               GestureDetector(
                //                 onTap: pickCamera,
                //                 child: Container(
                //                   width: MediaQuery.of(context).size.width - 200,
                //                   alignment: Alignment.center,
                //                   padding: EdgeInsets.symmetric(
                //                       horizontal: 24, vertical: 17),
                //                   decoration: BoxDecoration(
                //                     color: Colors.blue,
                //                     borderRadius: BorderRadius.circular(15),
                //                   ),
                //                   child: Text(
                //                     'Take A Photo',
                //                     style: TextStyle(
                //                         color: Colors.white, fontSize: 16),
                //                   ),
                //                 ),
                //               ),
                //               SizedBox(height: 30),
                //               GestureDetector(
                //                 onTap: getGalleryImage,
                //                 child: Container(
                //                   width: MediaQuery.of(context).size.width - 200,
                //                   alignment: Alignment.center,
                //                   padding: EdgeInsets.symmetric(
                //                       horizontal: 24, vertical: 17),
                //                   decoration: BoxDecoration(
                //                     color: Colors.blue,
                //                     borderRadius: BorderRadius.circular(15),
                //                   ),
                //                   child: Text(
                //                     'Pick From Gallery',
                //                     style: TextStyle(
                //                         color: Colors.white, fontSize: 16),
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getGalleryImage() async {
    ImagePicker _picker = ImagePicker();
    var pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    //print(pickedFile);
    if (pickedFile == null) return null;
    setState(() {
      _loading = true;
      _image = File(pickedFile.path);
    });
    classifyImage(_image!);
    //print(_image!);
  }

  pickCamera() async {
    ImagePicker _picker = ImagePicker();
    var image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image!);
  }

  classifyImage(File _image) async {
    var output = await Tflite.runModelOnImage(
      path: _image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      _outputs = output!;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
