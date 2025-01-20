/*
import 'package:flutter/material.dart';
import '../../model/doctor.dart';

class DoctorDetailsPage extends StatelessWidget {
  final Doctor doctor; // Use the Doctor model to pass data

  DoctorDetailsPage({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${doctor.name} - Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                doctor.profileImage ??
                    'https://firebasestorage.googleapis.com/v0/b/skillshare-1204d.firebasestorage.app/o/profile%2Fprofile.png?alt=media&token=bd6851ba-051c-454c-b300-290b8897a916', // default image
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Name: ${doctor.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${doctor.email}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Phone: ${doctor.phone}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Specialization: ${doctor.specialization}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Password: ${doctor.password}', // Avoid showing this in real apps
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Logic to book the appointment (can be implemented based on your requirement)
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Book Appointment'),
                    content: Text('Appointment with Dr. ${doctor.name} has been booked successfully!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Book Appointment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoctorDetailsPage extends StatelessWidget {
  final String uid;

  DoctorDetailsPage({required this.uid});  // Accept uid as parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Details'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('doctors').doc(uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var doctor = snapshot.data!.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(doctor['profileImage']),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Name: ${doctor['name']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Email: ${doctor['email']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Phone: ${doctor['phone']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Specialization: ${doctor['specialization']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  // Add other doctor details here
                ],
              ),
            );
          } else {
            return Center(child: Text('Doctor not found.'));
          }
        },
      ),
    );
  }
}
