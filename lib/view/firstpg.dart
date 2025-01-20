import 'package:flutter/material.dart';

import 'Doc/logindoc.dart';
import 'Pat/loginpat.dart';

class FirstPg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purpleAccent.shade400, Colors.deepPurpleAccent.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('asset/psy.png'), // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Welcome Text
            Text(
              'Welcome to DoctorConnect',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),

            // Tiles for Doctor and Patient
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTile(
                  title: 'Doctor',
                  subtitle: 'Manage Appointments',
                  color1: Colors.blue,
                  color2: Colors.blueAccent,
                  icon: Icons.local_hospital,
                  context: context,
                  page: LoginDoc(), // Replace with your actual DoctorPage
                ),
                SizedBox(width: 20),
                _buildTile(
                  title: 'Patient',
                  subtitle: 'Book an \nAppointment',
                  color1: Colors.green,
                  color2: Colors.greenAccent,
                  icon: Icons.person,
                  context: context,
                  page: LoginPat(), // Replace with your actual PatientPage
                ),
              ],
            ),

            SizedBox(height: 40),

            // Footer Quote
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Connecting doctors and patients seamlessly for better healthcare.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile({
    required String title,
    required String subtitle,
    required Color color1,
    required Color color2,
    required IconData icon,
    required BuildContext context, // Add context as parameter
    required Widget page, // Add the page to navigate to as parameter
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page), // Navigate to the page
        );
      },
      child: Container(
        width: 140,
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color1, color2]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}