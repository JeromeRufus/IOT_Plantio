import 'dart:io';
import 'dart:async';

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:file/file.dart';
import 'package:tflite/tflite.dart';

class ImageAnalyze extends StatefulWidget {
  const ImageAnalyze({super.key});
  static const routName = '/image';

  @override
  State<ImageAnalyze> createState() => _ImageAnalyzeState();
}

class _ImageAnalyzeState extends State<ImageAnalyze> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Analyze",
          style: TextStyle(
            fontSize: 24,
            color: Color.fromARGB(255, 66, 96, 32),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bc.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // SizedBox(
            //   height: 100.0,
            // ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 40),
              child: Container(
                alignment: Alignment.center,
                // padding: EdgeInsets.all(50),
                // decoration: BoxDecoration(
                //   color: const Color.fromARGB(255, 106, 148, 59),
                //   borderRadius: BorderRadius.circular(30),
                // ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Center(
                        child: _loading == true
                            ? null //show nothing if no picture selected
                            : Container(
                                child: Column(
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.5,
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: _image != null
                                            ? Image.file(
                                                _image!,
                                                fit: BoxFit.fill,
                                              )
                                            : const Center(
                                                child: Text(
                                                  'No image selected', // Show a message when no image is selected
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                    Divider(
                                      height: 25,
                                      thickness: 1,
                                    ),
                                    // ignore: unnecessary_null_comparison
                                    _outputs != null
                                        ? Text(
                                            'This is: ${_outputs![0]['label']}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        : Container(),
                                    Divider(
                                      height: 25,
                                      thickness: 1,
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: pickCamera,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 200,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 17),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 43, 97, 45),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                'Take A Photo',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          GestureDetector(
                            onTap: getGalleryImage,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 200,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 17),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 43, 97, 45),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                'Pick From Gallery',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
