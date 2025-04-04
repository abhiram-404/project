import 'package:dr_connect/controller/session.dart';
import 'package:dr_connect/view/Pat/PatHomepg.dart';
import 'package:dr_connect/view/Pat/registerUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../controller/google_sign_in.dart';
import '../Doc/logindoc.dart';
import 'otp.dart';

class LoginPat extends StatefulWidget {
  const LoginPat({super.key});

  @override
  State<LoginPat> createState() => _LoginPatState();
}

class _LoginPatState extends State<LoginPat> {
  final _formKey = GlobalKey<FormState>(); // For form validation
  bool _isLoading = false; // To show loading indicator
  final phoneController = TextEditingController();
  final RegExp phonergr =
      RegExp(r"^(?:(?:\+|0{0,2})91(\s*[\-]\s*)?|[0]?)?[6789]\d{9}$");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal.shade700,
          elevation: 0,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity, // Ensures full screen height
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
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Center the content vertically
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('asset/main_logo.png'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  const Text(
                    'Log in to continue',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Phone Input
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Mobile Number',
                              hintText: 'Enter Mobile number',
                              prefixIcon: Icon(Icons.call, color: Colors.teal),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                            ),
                            style: TextStyle(color: Colors.black),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a mobile number';
                              } else if (!phonergr.hasMatch(value)) {
                                return 'Please enter a valid Indian phone number';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    setState(() => _isLoading = true);

                                    // Simulating a short delay for demo purposes
                                    Future.delayed(Duration(seconds: 2), () {
                                      setState(() => _isLoading = false);

                                      // Navigate to the OTP class
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OTP(
                                                  mobileNumber: ' ',
                                                )),
                                      );
                                    });
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                  ),
                                ),
                        ),

                        SizedBox(height: 20),
                        // Google Sign-In Button
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Google color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          icon: const Icon(
                            FontAwesomeIcons.google,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Sign in with Google',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            // Show loading indicator
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => Center(child: CircularProgressIndicator()),
                            );

                           try {
                              User? user = await GoogleSignInService().signInWithGoogle(context);
                              print("User is $user");
                              if (user != null) {
                                print("Signed in as ${user.displayName}");

                                // Save session using SessionManager
                                await SessionManager().setSessionManager(
                                  user.email!,
                                  user.uid,
                                  googleName: user.displayName,
                                );

                                // Navigate to the home page
                              /*  Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => PatHomePg()),
                                );*/
                              } else {
                                print("Sign-in failed");
                              }
                            } catch (e) {
                              Navigator.pop(context); // Close loading dialog
                              print("Error during sign-in: $e");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Sign-In failed: $e")),
                              );
                            }
                          },
                        ),

                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoginDoc()), // Navigates to Doctor Login
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text("Doctor Login"),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterScreen()),
                            );
                          },
                          child: const Text(
                            "Don't have an account? Register here",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
