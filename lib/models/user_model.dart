class UserModel {
  final String id;
  final String name;
  final String? email;
  final String phone;
  final String? location;
  final List<String> selectedCategories;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    required this.phone,
    this.location,
    required this.selectedCategories,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      location: json['location'],
      selectedCategories: List<String>.from(json['selectedCategories']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'selectedCategories': selectedCategories,
    };
  }
}