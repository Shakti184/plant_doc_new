import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  
  File? pickedImage;
  List? _outputs=[];
  bool _loading=false;

  @override
  void initState() {
    super.initState();
    _loading=true;
    loadModel()
    .then((value){
      setState(() {
        _loading=false;
      });
    });
  }
  
  loadModel()async{
    Tflite.close();
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
  }
  
  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
 
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

  void showResult() {
    Get.to(
      Center(
        child: SingleChildScrollView(
          // physics: const BouncingScrollPhysics(decelerationRate:ScrollDecelerationRate.fast),
          scrollDirection: Axis.vertical,
          child:
            Center(
              child: Column(          
                children:<Widget>[ 
                  
                  Container(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  height: 600,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        (_loading)?Card(
                          // margin: const EdgeInsets.all(10),
                          elevation: 8,
                          shadowColor: const Color.fromARGB(255, 0, 136, 255),
                          child: Image.file(pickedImage!),
                        ):const Card(
                          elevation: 15,
                          shadowColor: Color.fromARGB(255, 0, 136, 255),
                          margin: EdgeInsets.all(10),
                          child: Opacity(opacity: 0.8,
                          child: Center(
                            child: Text("No Image selected"),
                          ),),
                        ),
                        const SizedBox(height: 10,),
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(decelerationRate:ScrollDecelerationRate.normal),
                          child: Column(
                             children:
                           (_loading)?_outputs!.map((output){
                            return Column(
                              children: [
                                Card(
                                  elevation: 8,
                                  shadowColor: const Color.fromARGB(255, 0, 136, 255),
                                  child: Container(
                                    width: 250,
                                    // height: 200,
                                    margin: const EdgeInsets.all(10),
                                    child: Text("Confidence : ${output['confidence'].toStringAsFixed(5)}",
                                        style:const TextStyle(
                                          color: Color.fromARGB(255, 134, 24, 16),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  const Padding(padding:EdgeInsets.all(10)),
                                  Card(
                                  elevation: 8,
                                  shadowColor: const Color.fromARGB(255, 0, 136, 255),
                                  child: Container(
                                    width: 250,
                                    // height: 200,
                                    margin: const EdgeInsets.all(10),
                                    child: Text("Label : ${output['label']}",
                                        style:const TextStyle(
                                          color: Colors.red,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                            },
                          ).toList():[],
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
                ],
              ),
            ),
          // ],
        ),
      ),
    );
  }

  processingstart()async{
    try {
      File? photo = pickedImage;
      if (photo == null) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.leftSlide,
          showCloseIcon: true,
          title: 'No Image',
          desc: "Please add the leaf Image",
          btnCancelOnPress: (){},
          ).show();
        return;
      }
      setState(() {
        _loading=true;
        classifyImage(photo);
      });
      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }
  
  classifyImage(File photo)async{
    var output=await Tflite.runModelOnImage(
      path: photo.path,
      numResults: 2,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
      );
      // print('$output[0]');
      setState(() {
        _loading=true;
        _outputs=output;
        showResult();
      });
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
    return Scaffold(
      
        appBar: AppBar(
          title: const Text('Plant Doc',style: TextStyle(fontSize:35,color:Color.fromARGB(255, 255, 255, 255),fontWeight:FontWeight.w900,fontStyle: FontStyle.italic),),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),

        drawer: const NavigationDrawer(),

        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 0, 21, 11),
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context){
                  return const Card(
                    color: Colors.blue,
                    child: Center(
                      child: Text('Chat bot will be added soon',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w900,fontStyle: FontStyle.italic,color:Colors.white,),),
                    ),
                  );
                },
              ),
            );
          },
          child: const Icon(Icons.chat_bubble_rounded,size: 25,color: Color.fromARGB(255, 255, 255, 255),),
        ),
          
        bottomNavigationBar: BottomAppBar(
          color:Colors.blue,
          child: Container(height: 50.0,),
        ),
    
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

        body: SingleChildScrollView(
          
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
                      border: Border.all(color: Colors.indigo, width: 5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Card(
                      child: pickedImage != null
                          ? Image.file(
                              pickedImage!,
                              width: 570,
                              height: 270,
                              fit: BoxFit.scaleDown,
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                        onPressed: processingstart,
                        icon: const Icon(Icons.data_thresholding),
                        label: const Text('Run Test')),
                  ),
                ],
        ),
      )
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shadowColor: Colors.blueAccent,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItem(context),
          ],
        ),
      ),
    );
  }
  
  buildHeader(BuildContext context) =>Container(
    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top,
    ),
  );
  buildMenuItem(BuildContext context)=>Container(
    padding: const EdgeInsets.all(25),
    child: Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: (){},
        ),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Menu'),
          onTap: (){},
        ),
        const Divider(color: Colors.black,),
        ListTile(
          leading: const Icon(Icons.update),
          title: const Text('Update'),
          onTap: (){},
        ),
        ListTile(
          leading: const Icon(Icons.favorite),
          title: const Text('Favourites'),
          onTap: (){},
        ),
        ListTile(
          leading: const Icon(Icons.menu_open_outlined),
          title: const Text('Menu'),
          onTap: (){},
        ),
        ListTile(
          leading: const Icon(Icons.menu_open_outlined),
          title: const Text('Menu'),
          onTap: (){},
        ),
      ],
    ),
  );
}

