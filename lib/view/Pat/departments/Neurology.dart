import 'package:flutter/material.dart';

class NeurologyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neurology'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text('Neurology Department'),
      ),
    );
  }
}