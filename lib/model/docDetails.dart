class Doctor {
  String name;
  String phone;
  String password;

  Doctor({
    required this.name,
    required this.phone,
    required this.password,
  });

  // Convert the object to a map to store in a database
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'password': password,
    };
  }

  // Create a Doctor instance from a map (e.g., from Firestore)
  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      name: map['name'],
      phone: map['phone'],
      password: map['password'],
    );
  }
}
