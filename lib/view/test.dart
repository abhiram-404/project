import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Doc/dochomepg.dart';
import 'Doc/phoneVerification.dart'; // Ensure Firestore is set up in your project


class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final _formKey = GlobalKey<FormState>();
  final phonergr = RegExp(r"^(?:(?:\+|0{0,2})91(\s*[\-]\s*)?|[0]?)?[6789]\d{9}$");
  final phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade500, Colors.blue.shade300, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Enter your registered mobile number',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: _inputDecoration(
                          label: 'Mobile Number',
                          hint: 'Enter your Mobile Number',
                          icon: Icons.phone,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your mobile number';
                          }
                          if (!phonergr.hasMatch(value)) {
                            return 'Please enter a valid Indian phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: isLoading ? null : () => _checkAndVerifyPhone(),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF2575FC),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> _checkAndVerifyPhone() async {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //
  //     try {
  //       final phone = '+91${phoneController.text}'; // Complete phone number with country code
  //       final result = await FirebaseFirestore.instance
  //           .collection('doctors')
  //           .where('phone', isEqualTo: phone) // Compare with the actual phone value
  //           .get();
  //
  //       if (result.docs.isEmpty) {
  //         // No user found
  //         setState(() {
  //           isLoading = false;
  //         });
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('No user found with this phone number'),
  //             backgroundColor: Colors.red,
  //           ),
  //         );
  //         return;
  //       }
  //
  //       // User found, proceed to OTP verification
  //       await FirebaseAuth.instance.verifyPhoneNumber(
  //         phoneNumber: phone,
  //         verificationCompleted: (PhoneAuthCredential credential) async {
  //           await _auth.signInWithCredential(credential);
  //           // Navigate to home page after successful sign-in
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(builder: (context) => DocHomepg()),
  //           );
  //         },
  //         verificationFailed: (FirebaseAuthException e) {
  //           setState(() {
  //             isLoading = false;
  //           });
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: Text('Verification failed: ${e.message}'),
  //               backgroundColor: Colors.red,
  //             ),
  //           );
  //         },
  //         codeSent: (String verId, int? resendToken) {
  //           setState(() {
  //             isLoading = false;
  //             verificationId = verId;
  //           });
  //           // Navigate to OTP input screen
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => OtpVerificationPage(
  //                 verificationId: verificationId,
  //                 phoneNumber: phoneController.text,
  //                 onVerificationSuccess: () {
  //                   Navigator.pushReplacement(
  //                     context,
  //                     MaterialPageRoute(builder: (context) => DocHomepg()),
  //                   );
  //                 },
  //               ),
  //             ),
  //           );
  //         },
  //         codeAutoRetrievalTimeout: (String verId) {
  //           verificationId = verId;
  //         },
  //       );
  //     } catch (e) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('An error occurred: $e'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   }
  // }

  Future<void> _checkAndVerifyPhone() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      try {
        // Construct the phone number with country code
        final phone = '+91${phoneController.text}';

        // Query the Firestore collection to find a matching phone number
        final querySnapshot = await FirebaseFirestore.instance
            .collection('doctors')
            .where('phone', isEqualTo: phone)
            //.where('phone', isEqualTo: '9446389013')
            .get();

        print('Query executed for phone: $phone');
        print('Documents found: ${querySnapshot.docs.length}');

        for (var doc in querySnapshot.docs) {
          print('Doc ID: ${doc.id}');
          print('Doc Data: ${doc.data()}');
        }
    
        if (querySnapshot.docs.isEmpty) {
          print('No matching documents found.');
        }


        if (querySnapshot.docs.isEmpty) {
          // No user found
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No user found with this phone number'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // User found, proceed to OTP verification
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
            // Navigate to the home page after successful sign-in
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DocHomepg()),
            );
          },
          verificationFailed: (FirebaseAuthException e) {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Verification failed: ${e.message}'),
                backgroundColor: Colors.red,
              ),
            );
          },
          codeSent: (String verId, int? resendToken) {
            setState(() {
              isLoading = false;
              verificationId = verId;
            });
            // Navigate to OTP input screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpVerificationPage(
                  name: "Test",
                  verificationId: verificationId,
                  phone: phoneController.text,
                  onVerificationSuccess: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => DocHomepg()),
                    );
                  },
                ),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
          },
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }




  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: Color(0xFF2575FC)),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.blue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.blue),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red),
      ),
    );
  }
}

