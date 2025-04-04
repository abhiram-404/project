/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'departments/Cardiology.dart';
import 'departments/Dentist.dart';
import 'departments/Orthopedics.dart';
import 'Departments.dart';
import 'TopDocs.dart';

class HomeScreen extends StatelessWidget {
  final String cardiologistIcon = 'asset/icon/heart.png';
  final String orthopedicIcon = 'asset/icon/bone.png';
  final String dentistIcon = 'asset/icon/tooth.png';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade700, Colors.teal.shade500, Colors.teal.shade300],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  "Find your desired",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  "Doctor Right Now!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Departments()),
                        );
                      },
                      child: Text(
                        'See all',
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CardiologyPage()),
                        );
                      },
                      child: _buildCategoryItem(cardiologistIcon, 'Cardiologist'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OrthopedicsPage()),
                        );
                      },
                      child: _buildCategoryItem(orthopedicIcon, 'Orthopedic'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DentistPage()),
                        );
                      },
                      child: _buildCategoryItem(dentistIcon, 'Dentist'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Doctors',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TopDocs()),
                        );
                      },
                      child: Text(
                        'See all',
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection('doctors').get(), // Fetch doctors from Firestore
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      List<QueryDocumentSnapshot> doctors = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: doctors.length,
                        itemBuilder: (context, index) {
                          var doctor = doctors[index].data() as Map<String, dynamic>;
                          return _buildDoctorCard(
                            doctor['name'],
                            doctor['specialization'],
                            doctor['profileImage'], // Assuming profile image is stored
                          );
                        },
                      );
                    } else {
                      return Center(child: Text('No doctors found.'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String iconPath, String title) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.teal.shade50,
          child: Image.asset(
            iconPath,
            width: 30,
            height: 30,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildDoctorCard(String name, String specialization, String profileImage) {
    return GestureDetector(
      onTap: () {
        print('Doctor tapped: $name');

      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.teal.shade200,
                child: profileImage.isNotEmpty
                    ? Image.network(profileImage, width: 60, height: 60, fit: BoxFit.cover)
                    : Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(specialization),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Departments.dart';
import 'TopDocs.dart';
import 'departments/Cardiology.dart';
import 'departments/Dentist.dart';
import 'departments/Orthopedics.dart';
import 'docDetails.dart';

class HomeScreen extends StatelessWidget {
  final String cardiologistIcon = 'asset/icon/heart.png';
  final String orthopedicIcon = 'asset/icon/bone.png';
  final String dentistIcon = 'asset/icon/tooth.png';

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal.shade700,
              Colors.teal.shade500,
              Colors.teal.shade300
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Find your desired",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Text(
                "Doctor Right Now!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Expanded(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Departments()),
                    );
                  },
                  child: Text(
                    'See all',
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CardiologyPage()),
                    );
                  },
                  child: _buildCategoryItem(cardiologistIcon, 'Cardiologist'),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrthopedicsPage()),
                    );
                  },
                  child: _buildCategoryItem(orthopedicIcon, 'Orthopedic'),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DentistPage()),
                    );
                  },
                  child: _buildCategoryItem(dentistIcon, 'Dentist'),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Doctors',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TopDocs()),
                    );
                  },
                  child: Text(
                    'See all',
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('doctors').get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<QueryDocumentSnapshot> doctors = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      var doctor =
                          doctors[index].data() as Map<String, dynamic>;
                      var doctorId =
                          doctors[index].id; // Getting the uid of the doctor
                      return _buildDoctorCard(
                        context, // Pass context here
                        doctorId, // Passing uid as parameter
                        doctor['name'],
                        doctor['specialization'],
                        doctor['profileImage'],
                        doctor['roomStatus'] ?? 'Unknown',
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No doctors found.'));
                }
              },
            ),
          ),
        ],
      ))
    ]);
  }

  Widget _buildCategoryItem(String iconPath, String title) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.teal.shade50,
          child: Image.asset(
            iconPath,
            width: 30,
            height: 30,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildDoctorCard(BuildContext context, String uid, String name,
      String specialization, String profileImage,  String roomStatus,) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DocDetails(uid: uid), // Passing uid to the next page
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.teal.shade200,
                child: profileImage.isNotEmpty
                    ? Image.network(profileImage,
                        width: 60, height: 60, fit: BoxFit.cover)
                    : Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(specialization),
                  Row(
                    children: [
                      Icon(Icons.circle, color: roomStatus == 'Available' ? Colors.green : Colors.red, size: 10),
                      SizedBox(width: 5),
                      Text(
                        roomStatus,
                        style: TextStyle(
                          fontSize: 12,
                          color: roomStatus == 'Available' ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
