
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_connect/view/Doc/regdoc.dart';
import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';
import '../../controller/session.dart';
import '../Pat/loginpat.dart';
import 'ForgotPassLogin.dart';
import 'dochomepg.dart';

class LoginDoc extends StatefulWidget {
  const LoginDoc({super.key});

  @override
  State<LoginDoc> createState() => _MyAppState();
}

class _MyAppState extends State<LoginDoc> {
  final _formKey = GlobalKey<FormState>();
  final emailAddress =
  RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  final passwordrgx =
  RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
  bool _isPasswordHidden = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Simulated hashed password (from database)
  // Example: The hash below represents "MySecurePassword123!"
  final String storedHashedPassword =
      r'$2a$10$dXJ/sN1O1cH9hl0/pTcTTu8Jx8M7q5TQ8oe9I1BbLQjglFSowQD.u'; // This should come from your database.

 Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final String email = _emailController.text.trim();
        final String password = _passwordController.text.trim();

        // Query Firestore for the user
        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('doctors')
            .where('email', isEqualTo: email)
            .get();

        if (querySnapshot.docs.isEmpty) {
          // Email not found
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user found with this email.')),
          );
          return;
        }

        final DocumentSnapshot userDoc = querySnapshot.docs.first;
        final String storedHashedPassword = userDoc['password'];

        if (_formKey.currentState?.validate() ?? false) {
      final enteredPassword = password;

      // Compare hashed password with stored password
      final bool isPasswordCorrect = BCrypt.checkpw(enteredPassword, storedHashedPassword);

      if(isPasswordCorrect){
        // Store the user data in the SessionManager
        SessionManager().setUserData(userDoc.id, userDoc['email']);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DocHomepg(
           /*   userDetails: {
                'email': userDoc['email'],
                'uid': userDoc.id,
                'name' : userDoc['name'],
              },*/
            ),
          ),
        );
      }
      }else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid email or password.')),
          );
    }
  } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
          child: Stack(
            children: [
              Center(
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
                          // Logo or Icon
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.login,
                              size: 40,
                              color: Color(0xFF2575FC),
                            ),
                          ),
                          SizedBox(height: 20),

                          // Title
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.blue.shade800,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Welcome back! Please log in.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 40),

                          // Form
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Email Field
                                TextFormField(
                                  keyboardType: TextInputType.phone,
                                  controller: _emailController,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Enter your phone number',
                                    labelText: 'Phone',
                                    labelStyle: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.phone,
                                      color: Colors.blue,
                                    ),
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
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!emailAddress.hasMatch(value)) {
                                      return 'Enter a valid email address';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),

                                // Password Field
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _isPasswordHidden,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Enter your Password',
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.blue,
                                    ),
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
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordHidden
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Color(0xFF2575FC),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordHidden =
                                          !_isPasswordHidden;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    if (!passwordrgx.hasMatch(value)) {
                                      return 'Password must be at least 8 characters long and include an uppercase letter, lowercase letter and number';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 30),

                                // Login Button
                                ElevatedButton(
                                  onPressed: login,

                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Color(0xFF2575FC),
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Center(child: Text('Log in')),
                                ),

                                SizedBox(height: 10),

                                // Forgot Password Button
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPassLogin()),
                                    );
                                  },
                                  child: Text(
                                    'Forgot Password ?',
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 30),

                                // Create Account Navigation
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RegDoc()),
                                    );
                                  },
                                  child: Text(
                                    'Do not have an account?\nCreate an Account',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPat()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.teal,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text("Patient Login"),
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
            ],
          ),
        ),
      ),
    );
  }
}
