import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:plant_doc/image_picker.dart';

class Dashboard_screen extends StatefulWidget {
  const Dashboard_screen({super.key});

  @override
  State<Dashboard_screen> createState() => _Dashboard_screenState();
}

class _Dashboard_screenState extends State<Dashboard_screen> {
  
  File? pickedImage;


  void imagePickerOption() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Pic Image From",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("CAMERA"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("GALLERY"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("CANCEL"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });

      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/plant_doc.png',fit: BoxFit.cover,),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),

        

        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 0, 21, 11),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context){return Container();}));
          },
          child: const Icon(Icons.add_a_photo),
        ),
          




        bottomNavigationBar: BottomAppBar(
          color: Colors.lightGreenAccent,
          child: Container(height: 50.0,),
        ),
    
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        
        
        
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Color.fromARGB(255, 23, 253, 153), width: 5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          child: pickedImage != null
                              ? Image.file(
                                  pickedImage!,
                                  width: 200,
                                  height: 500,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  'https://mcdn.wallpapersafari.com/medium/3/88/9tOhN2.jpg',
                                  width: 570,
                                  height: 270,
                                  fit: BoxFit.scaleDown,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 5,
                        child: IconButton(
                          onPressed: imagePickerOption,
                          icon: const Icon(
                            Icons.add_a_photo_outlined,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ), 
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                      onPressed: imagePickerOption,
                      icon: const Icon(Icons.add_a_photo_sharp),
                      label: const Text('UPLOAD IMAGE')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}