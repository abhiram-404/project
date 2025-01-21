import 'package:dr_connect/view/Doc/phoneVerification.dart';
import 'package:dr_connect/view/Doc/specialization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dr_connect/view/Doc/logindoc.dart';

class RegDoc extends StatefulWidget {
  const RegDoc({Key? key}) : super(key: key);

  @override
  _RegDocState createState() => _RegDocState();
}

class _RegDocState extends State<RegDoc> {
  final _formKey = GlobalKey<FormState>();
  //final passwordrgx = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
  final phonergr = RegExp(r"^(?:(?:\+|0{0,2})91(\s*[\-]\s*)?|[0]?)?[6789]\d{9}$");
  bool _isPasswordHidden = true;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  // final passwordController = TextEditingController();
  // final conpasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = '';
  late String smsCode;

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person_add,
                        size: 40,
                        color: Color(0xFF2575FC),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Sign up to get started!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 30),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: _inputDecoration(
                              label: 'Name',
                              hint: 'Enter your Name',
                              icon: Icons.person,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter your Name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
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
                          SizedBox(height: 10),
                          // TextFormField(
                          //   controller: passwordController,
                          //   obscureText: _isPasswordHidden,
                          //   decoration: _inputDecoration(
                          //     label: 'Password',
                          //     hint: 'Enter your Password',
                          //     icon: Icons.lock,
                          //   ).copyWith(
                          //     suffixIcon: IconButton(
                          //       icon: Icon(
                          //         _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                          //         color: Color(0xFF2575FC),
                          //       ),
                          //       onPressed: () {
                          //         setState(() {
                          //           _isPasswordHidden = !_isPasswordHidden;
                          //         });
                          //       },
                          //     ),
                          //   ),
                          //   validator: (value) => value!.isEmpty ? 'Enter your password' : null,
                          // ),
                          // SizedBox(height: 10),
                          // TextFormField(
                          //   controller: conpasswordController,
                          //   obscureText: _isPasswordHidden,
                          //   decoration: _inputDecoration(
                          //     label: 'Confirm Password',
                          //     hint: 'ReEnter your Password',
                          //     icon: Icons.lock,
                          //   ).copyWith(
                          //     suffixIcon: IconButton(
                          //       icon: Icon(
                          //         _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                          //         color: Color(0xFF2575FC),
                          //       ),
                          //       onPressed: () {
                          //         setState(() {
                          //           _isPasswordHidden = !_isPasswordHidden;
                          //         });
                          //       },
                          //     ),
                          //   ),
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Please confirm your password';
                          //     }
                          //     if (value != passwordController.text) {
                          //       return 'Passwords do not match';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: () => _verifyPhone(),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color(0xFF2575FC),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Center(child: Text('Verify Phone Number')),
                          ),

                          SizedBox(height: 40),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginDoc()),
                              );
                            },
                            child: Text(
                              'Already have an account?\nLogin',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
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
            ),
          ),
        ),
      ),
    );
  }

  void _verifyPhone() {
    if (_formKey.currentState?.validate() ?? false) {
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${phoneController.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Special(
                userData: {
                  'name': nameController.text,
                  'phone': phoneController.text,
                  // 'password': passwordController.text,
                },
              ),
            ),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Verification failed: ${e.message}'),
              backgroundColor: Colors.red,
            ),
          );
        },
        codeSent: (String verId, int? resendToken) {
          setState(() {
            verificationId = verId;
          });
          // Navigate to the OTP verification screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationPage(
                verificationId: verificationId,
                phoneNumber: phoneController.text,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verId) {},
      );
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
