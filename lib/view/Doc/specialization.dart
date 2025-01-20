import 'package:dr_connect/view/Doc/dochomepg.dart';
import 'package:flutter/material.dart';
import '../../controller/doctor_service.dart';

class Special extends StatefulWidget {
  final Map<String, dynamic> userData;

  const Special({required this.userData, Key? key}) : super(key: key);

  @override
  _SpecialState createState() => _SpecialState();
}

class _SpecialState extends State<Special> {
  final List<String> specializations = [
    'Cardiology',
    'Dentist',
    'Dermatology',
    'ENT',
    'General Medicine',
    'Gynecology',
    'Neurology',
    'Ophthalmology',
    'Orthopedics',
    'Pediatrics',
  ];
  String? selectedSpecialization;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Specialization',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 2,
                color: Colors.black26,
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 10,
        shadowColor: Colors.black38,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade500, Colors.blue.shade300, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Card(
            //     elevation: 5,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.all(16.0),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             'Name: ${widget.userData['name']}',
            //             style: const TextStyle(
            //               fontSize: 16,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //           const SizedBox(height: 8),
            //           Text(
            //             'Email: ${widget.userData['email']}',
            //             style: const TextStyle(fontSize: 14),
            //           ),
            //           const SizedBox(height: 8),
            //           Text(
            //             'Phone: ${widget.userData['phone']}',
            //             style: const TextStyle(fontSize: 14),
            //           ),
            //           const SizedBox(height: 8),
            //           Text(
            //             'Password: ${widget.userData['password']}',
            //             style: const TextStyle(fontSize: 14),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: specializations.length,
                itemBuilder: (context, index) {
                  final specialization = specializations[index];
                  final isSelected = specialization == selectedSpecialization;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSpecialization = specialization;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade50 : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Colors.blue.shade700
                              : Colors.grey.shade300,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        specialization,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (selectedSpecialization != null)
              ElevatedButton(
                onPressed: () async {
                  final data = {
                    ...widget.userData,
                    'specialization': selectedSpecialization,
                  };
                  await DoctorService().registerDoctor(data);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Doctor Registered')),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DocHomepg(/*userDetails: {},*/)),
                  );
                },
                child: const Text('Confirm'),
              ),
          ],
        ),
      ),
    );
  }
}
