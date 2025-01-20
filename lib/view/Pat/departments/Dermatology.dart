import 'package:flutter/material.dart';

class DermatologyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dermatology'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text('Dermatology Department'),
      ),
    );
  }
}