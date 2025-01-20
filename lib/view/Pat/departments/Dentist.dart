import 'package:flutter/material.dart';

class DentistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dentist'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text('Dentist Department'),
      ),
    );
  }
}