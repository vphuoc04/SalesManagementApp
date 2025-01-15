class User {
  final int id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String phone;

  User({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.phone
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0, 
      firstName: json['firstName'] ?? '', 
      middleName: json['middleName'] ?? '', 
      lastName: json['lastName'] ?? '', 
      email: json['email'] ?? '', 
      phone: json['phone'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'middleName': middleName, 
      'lastName': lastName, 
      'email': email,
      'phone': phone,
    };
  }
}
