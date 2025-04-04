import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../docDetails.dart';

class GeneralMedicinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('General Medicine'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('doctors')
            .where('specialization', isEqualTo: 'General Medicine')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            List<QueryDocumentSnapshot> doctors = snapshot.data!.docs;

            return GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.75, // Adjust height-to-width ratio
              ),
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                var doctor = doctors[index].data() as Map<String, dynamic>;
                var doctorId = doctors[index].id;

                return _buildDoctorCard(
                  doctor['profileImage'] ?? '',
                  doctor['name'] ?? 'Unknown Name',
                  doctor['specialization'] ?? 'No specialization',
                  doctorId,
                  context,
                );
              },
            );
          } else {
            return Center(child: Text('No General Medicine doctors found.'));
          }
        },
      ),
    );
  }

  Widget _buildDoctorCard(String profileImage, String name, String specialization, String uid, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.blue.shade100,
              child: profileImage.isNotEmpty
                  ? ClipOval(
                child: Image.network(
                  profileImage,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              )
                  : Icon(Icons.person, size: 30, color: Colors.teal),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              specialization,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the doctor details page with the uid
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DocDetails(uid: uid), // Passing uid here
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'View Details',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
