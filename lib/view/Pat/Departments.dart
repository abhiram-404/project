import 'package:flutter/material.dart';

import 'PatHomepg.dart';
import 'departments/Cardiology.dart';
import 'departments/Dentist.dart';
import 'departments/Dermatology.dart';
import 'departments/ENT.dart';
import 'departments/GenralMedicine.dart';
import 'departments/Gynecology.dart';
import 'departments/Neurology.dart';
import 'departments/Ophthalmology.dart';
import 'departments/Orthopedics.dart';
import 'departments/Pediatrics.dart';


class Departments extends StatelessWidget {
  final List<Map<String, dynamic>> departments = [
    {'name': 'Cardiology', 'icon': 'asset/icon/heart.png', 'page': CardiologyPage()},
    {'name': 'Dentist', 'icon': 'asset/icon/tooth.png', 'page': DentistPage()},
    {'name': 'Dermatology', 'icon': 'asset/icon/dermatology.png', 'page': DermatologyPage()},
    {'name': 'ENT', 'icon': 'asset/icon/ent.png', 'page': ENTPage()},
    {'name': 'General Medicine', 'icon': 'asset/icon/general_medicine.png', 'page': GeneralMedicinePage()},
    {'name': 'Gynecology', 'icon': 'asset/icon/gynecology.png', 'page': GynecologyPage()},
    {'name': 'Neurology', 'icon': 'asset/icon/neurology.png', 'page': NeurologyPage()},
    {'name': 'Ophthalmology', 'icon': 'asset/icon/ophthalmology.png', 'page': OphthalmologyPage()},
    {'name': 'Orthopedics', 'icon': 'asset/icon/bone.png', 'page': OrthopedicsPage()},
    {'name': 'Pediatrics', 'icon': 'asset/icon/pediatrics.png', 'page': PediatricsPage()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PatHomePg()),
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: departments.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Increased vertical margin
            elevation: 6, // Slightly higher elevation for a pronounced look
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Slightly larger border radius
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16), // Increased padding
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: Image.asset(
                  departments[index]['icon']!,
                  width: 40, // Larger icon size
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
              title: Text(
                departments[index]['name']!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600), // Larger font size
              ),
              trailing: Icon(Icons.arrow_forward, color: Colors.teal, size: 24), // Slightly larger icon
              onTap: () {
                // Navigate to the specific department page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => departments[index]['page']),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
