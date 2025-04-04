import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dr_connect/view/Doc/regdoc.dart';
import '../../controller/session.dart';
import '../Pat/loginpat.dart';
import 'dochomepg.dart';

class LoginDoc extends StatefulWidget {
  const LoginDoc({super.key});

  @override
  State<LoginDoc> createState() => _LoginDocState();
}

class _LoginDocState extends State<LoginDoc> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _secretCodeController = TextEditingController();
  bool _isLoading = false;
  bool _phoneExists = false;
  String? _savedSecretCode;

  Future<void> _checkDoctorExists() async {
    setState(() {
      _isLoading = true;
    });

    String phone = _phoneController.text.trim();

    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .where('phone', isEqualTo: phone)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        setState(() {
          _phoneExists = true;
          _savedSecretCode = doc['secretCode'];
        });
      } else {
        setState(() {
          _phoneExists = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone number not registered.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _verifySecretCode() async {
    if (_savedSecretCode != null &&
        _secretCodeController.text.trim() == _savedSecretCode) {
      // Get the document from Firestore again
      var querySnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .where('phone', isEqualTo: _phoneController.text.trim())
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        String userId = doc.id;
        String phone = doc['phone'];

        await SessionManager().setSessionManager(phone, userId);

        print("Session saved: userId = $userId, phone = $phone");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DocHomepg()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid secret code!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
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
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.login,
                        size: 40,
                        color: Color(0xFF2575FC),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Welcome back! Please log in.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Phone Number Input
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: _phoneController,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your phone number',
                              labelText: 'Phone',
                              prefixIcon:
                                  const Icon(Icons.phone, color: Colors.blue),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                                return 'Enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          _isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _checkDoctorExists();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color(0xFF2575FC),
                                  ),
                                  child: const Text('Check Phone Number'),
                                ),

                          if (_phoneExists) ...[
                            const SizedBox(height: 20),

                            // Secret Code Input
                            TextFormField(
                              controller: _secretCodeController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Enter your secret code',
                                labelText: 'Secret Code',
                                prefixIcon:
                                    const Icon(Icons.lock, color: Colors.blue),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your secret code';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            ElevatedButton(
                              onPressed: _verifySecretCode,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.green,
                              ),
                              child: const Text('Verify & Log in'),
                            ),
                          ],

                          const SizedBox(height: 30),

                          // Create Account Link
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RegDoc()),
                              );
                            },
                            child: const Text(
                              'Do not have an account?\nCreate an Account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Patient Login Button
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPat()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.teal,
                            ),
                            child: const Text("Patient Login"),
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
}
