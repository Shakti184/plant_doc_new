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
        body: Container(
          color: Colors.green,
          child: const Center(child: Text('Plant Doc.',style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),)),
        ),
      ),
    );
  }
}