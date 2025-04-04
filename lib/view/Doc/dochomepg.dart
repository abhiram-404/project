import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_connect/view/Doc/Settings.dart';
import 'package:dr_connect/view/Doc/profilepg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../controller/session.dart';
import 'AboutUs.dart';
import 'logindoc.dart';

class DocHomepg extends StatefulWidget {
  DocHomepg({Key? key}) : super(key: key);

  @override
  State<DocHomepg> createState() => _DocHomepgState();
}

class _DocHomepgState extends State<DocHomepg> {
  bool isTimeIn = false;
  String username = 'Fetching...';
  String depart = 'Loading..';
  String? uid;
  String? email;

  @override
  void initState() {
    super.initState();
    // Fetching uid and email from session
    uid = SessionManager().getUserId();
    email = SessionManager().getEmail();

    // If uid is available, fetch the user details
    if (uid != null && uid!.isNotEmpty) {
      fetchUserDetails(uid!);
    }
  }

  Future<void> fetchUserDetails(String uid) async {
    if (uid.isEmpty) return;

    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('doctors').doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          username = userDoc['name'] ?? 'No Name Available';
          depart = userDoc['specialization'] ?? 'No Department Available';
        });
      } else {
        setState(() {
          username = 'User Not Found';
          depart = 'Department Not Found';
          isTimeIn = userDoc['roomStatus'] == 'in';
        });
      }
    } catch (e) {
      setState(() {
        username = 'Error Fetching Name';
        depart = 'Error Fetching Department';
      });
      print('Error fetching user details: $e');
    }
  }

  Future<void> toggleTimeStatus() async {
    if (uid == null) return;

    String newStatus = isTimeIn ? 'out' : 'in';
    DateTime now = DateTime.now();

    try {
      // 1. Update roomStatus in main doctor doc
      await FirebaseFirestore.instance.collection('doctors').doc(uid).update({
        'roomStatus': newStatus,
      });

      // 2. Add entry to punchHistory subcollection
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(uid)
          .collection('punchHistory')
          .add({
        'status': newStatus,
        'timestamp': now,
      });

      // 3. Update local state
      setState(() {
        isTimeIn = !isTimeIn;
      });
    } catch (e) {
      print("Error updating time status: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    final displayedEmail = email ?? 'No Email Provided';

    return Container(
      // Gradient Background Covering the Entire Screen
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade500,
            Colors.blue.shade300,
            Colors.blue.shade100
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // Makes Scaffold Background Transparent
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.blue.shade500,
          // AppBar background color
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.white, // Change the drawer icon (3 lines) color
            size: 28, // Adjust the size if needed
          ),
          title: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'WELCOME',
                textStyle: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                speed: const Duration(milliseconds: 200), // Typing speed
              ),
            ],
            isRepeatingAnimation: true,
            repeatForever: true,
          ),
          centerTitle: true, // Center align the title
        ),
        drawer: Drawer(
          child: Column(
            children: [
              // Profile Header
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(),
                    ),
                  );
                },
                child: UserAccountsDrawerHeader(
                  accountName: Text(
                    username,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text(
                    displayedEmail,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  currentAccountPicture: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue.shade400,
                    child: const Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(25)),
                  ),
                ),
              ),
              // Drawer Items as Tiles
              Expanded(
                child: ListView(
                  children: [
                    _buildTile(
                        icon: Icons.settings,
                        title: 'Settings',
                        color: Colors.blue.shade100,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Settingspage()),
                          );
                        }),
                    _buildTile(
                      icon: Icons.report,
                      title: 'About us',
                      color: Colors.blue.shade100,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => About()),
                        );
                      },
                    ),
                    // _buildTile(
                    //   icon: Icons.lock_outlined,
                    //   title: 'Change password',
                    //   color: Colors.blue.shade100,
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => Password()),
                    //     );
                    //   },
                    // ),
                    Divider(),
                    _buildTile(
                      icon: Icons.exit_to_app,
                      title: 'Logout',
                      color: Colors.red.shade500,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm Logout'),
                              content:
                                  const Text('Do you really want to logout?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the alert dialog
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Navigate to the login screen after confirming logout
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginDoc()),
                                    );
                                  },
                                  child: const Text('Logout'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: kToolbarHeight + 12),
                // Doctor's Tile
                Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade300,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dr. $username",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              depart,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Status: ${isTimeIn ? 'IN' : 'OUT'}',
                              style: TextStyle(
                                color: isTimeIn ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            Text(
                              'Location: Floor 3, Room 24',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: toggleTimeStatus,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isTimeIn ? Colors.red : Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          isTimeIn ? 'Time Out' : 'Time In',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )

                    ],
                  ),
                ),
                SizedBox(height: 10),
               // Adjusted space between "Patient Bookings" and next section
                 // Section for Patient Bookings
                const Text(
                  'Patient Bookings',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.green.shade100,
                            child: Icon(
                              Icons.assignment_rounded,
                              size: 30,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Patient: John Smith',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Date: 12 Dec 2024, Time: 10:00 AM',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right,
                              color: Colors.grey.shade600),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                // Additional space to push the health tips section higher
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dashboardTile(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 30, color: iconColor),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerTile(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade700),
      title: Text(title,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87)),
      onTap: onTap,
    );
  }
}

Widget _buildTile({
  required IconData icon,
  required String title,
  required Color color,
  required VoidCallback onTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    child: Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, size: 30, color: Colors.blue.shade700),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onTap: onTap,
      ),
    ),
  );
}
