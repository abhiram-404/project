import 'package:flutter/material.dart';
import '../../controller/doctor_service.dart';
import '../test.dart';
import 'dochomepg.dart';
import 'logindoc.dart';

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
            fontSize:25,color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 2,
                color: Colors.black26,
              ),
            ],
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade500, Colors.blue.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade500, Colors.blue.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: specializations.length,
                itemBuilder: (context, index) {
                  final specialization = specializations[index];
                  final isSelected = specialization == selectedSpecialization;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSpecialization =
                        isSelected ? null : specialization;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade50 : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Colors.blue.shade700
                              : Colors.grey.shade300,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            specialization,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Colors.blue.shade700
                                  : Colors.black87,
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: Colors.blue.shade700,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (selectedSpecialization == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a specialization.'),
                      ),
                    );
                    return;
                  }

                  final data = {
                    ...widget.userData,
                    'specialization': selectedSpecialization,
                  };
                  print("Registering doctor with data: ${widget.userData}");
                  print("Registering doctor with data: $data");
                  await DoctorService().registerDoctor(data);



                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Doctor Registered')),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginDoc(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  minimumSize: const Size.fromHeight(56), // Full-width button
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}