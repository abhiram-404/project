import 'package:flutter/material.dart';

class GeneralMedicinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('General Medicine'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text('General Medicine Department'),
      ),
    );
  }
}