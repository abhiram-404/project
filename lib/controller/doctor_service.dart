import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorService {
  final CollectionReference _doctorCollection =
  FirebaseFirestore.instance.collection('doctors');

  // Function to register a doctor with all fields
  Future<void> registerDoctor(Map<String, dynamic> data) async {
    try {
      print("Doctor data received: ${data['name']}");

      String profileImage = data['profileImage'] ??
          'https://firebasestorage.googleapis.com/v0/b/skillshare-1204d.firebasestorage.app/o/profile%2Fprofile.png?alt=media&token=bd6851ba-051c-454c-b300-290b8897a916';
      await _doctorCollection.add({
        'name':data['name'] ?? 'Unknown',
        'secretCode':"1234",
        'phone': data['phone'],
        'profileImage':profileImage,
        'roomStatus':'out',
        'specialization': data['specialization'],
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to register doctor: $e');
    }
  }
}
