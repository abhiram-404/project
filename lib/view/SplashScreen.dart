import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../controller/session.dart';
import 'Doc/dochomepg.dart';
import 'Pat/PatHomepg.dart';
import 'firstpg.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }
  _checkSession() async {
    var sessionData = await SessionManager().getSession();

    if (sessionData == null) {
      Timer(Duration(seconds: 1), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => FirstPg()));
      });
    } else {
      String userId = sessionData['userId'] ?? '';

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      DocumentSnapshot doctorSnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        Timer(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => PatHomePg()));
        });
      } else if (doctorSnapshot.exists) {
        Timer(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => DocHomepg()));
        });
      } else {
        Timer(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => FirstPg()));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Container(
          child: Image.asset('asset/main_logo.png'),
        ),
      ),
    );
  }
}
