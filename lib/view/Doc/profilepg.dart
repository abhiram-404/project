import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../controller/session.dart';
import 'editprofile.dart';
import 'dochomepg.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);
  @override
  State<Profile> createState() => _ProfileState();

}

class _ProfileState extends State<Profile> {
  Map<String, dynamic>? doctorDetails;

  String name = '';
  // String email = '';
  String phone = '';
  String specialization = '';
  bool isLoadingName = true;
  // bool isLoadingEmail = true;
  bool isLoadingPhone = true;
  bool isLoadingSpecialization = true;
  String? uid;

  @override
  void initState() {
    super.initState();
    // Fetching uid and email from session
    uid = SessionManager().getUserId();

    // Fetch doctor details only if uid is available
    if (uid != null) {
      fetchDoctorDetails(uid!);
    }
  }

  Future<void> fetchDoctorDetails(String uid) async {
    try {
      // Fetch doctor details from Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(uid)
          .get();  // Using the uid from session manager

      if (snapshot.exists) {
        setState(() {
          name = snapshot['name'] ?? 'N/A';
          // email = snapshot['email'] ?? 'N/A';
          phone = snapshot['phone'] ?? 'N/A';
          specialization = snapshot['specialization'] ?? 'N/A';
          isLoadingName = false;
          // isLoadingEmail = false;
          isLoadingPhone = false;
          isLoadingSpecialization = false;
        });
      } else {
        print("Doctor not found.");
      }
    } catch (e) {
      print("Error fetching doctor details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section - Full Width
            Container(
              width: double.infinity,
              // Full width
              height: 280,
              // Increased height to accommodate the "My Profile" text
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade700,
                    Colors.blue.shade500,
                    Colors.blue.shade300
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Stack(
                children: [
                  // Back Button
                  Positioned(
                    top: 20,
                    left: 20,
                    child: IconButton(
                      icon:
                          Icon(Icons.arrow_back, color: Colors.white, size: 24),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DocHomepg(
                                  //  userDetails: {},
                                  )),
                        );
                      },
                    ),
                  ),
                  // Profile Header Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "My Profile",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Add functionality to upload a photo
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Upload Photo',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue.shade500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Profile Fields Section
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                children: [
                  buildProfileField(context, "Name", Icons.person_outline,
                      isLoadingName ? 'Loading...' : name),
                  // buildProfileField(context, "Email", Icons.email_outlined,
                  //     isLoadingEmail ? 'Loading...' : email),
                  buildProfileField(context, "Phone", Icons.phone,
                      isLoadingPhone ? 'Loading...' : phone),
                  buildProfileField(
                      context,
                      "Specialization",
                      Icons.medical_information_rounded,
                      isLoadingSpecialization ? 'Loading...' : specialization),
                  SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Edit()), // Navigate to the Edit page
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade500,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileField(
      BuildContext context, String heading, IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 75,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // Shadow position
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: Icon(icon, color: Colors.grey.shade700, size: 24),
            title: Text(
              heading,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
