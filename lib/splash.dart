import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plant_doc_new/dashboard_screen.dart';


class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override

  void initState() {
    super.initState();
    
    Timer(const Duration(seconds: 4),(){
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context)=>const Dashboardscreen()),
        );
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        persistentFooterAlignment: AlignmentDirectional.center,
        body: Container(
          color: Color.fromARGB(255, 3, 158, 8),
          child: const Center(child: Text('Plant Doc.',style: TextStyle(
            fontSize: 45,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),)),
        ),
      ),
    );
  }
}