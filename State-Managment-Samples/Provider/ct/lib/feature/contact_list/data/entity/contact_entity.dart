
///Do not parsing with unused value such as last seen, created at because they might be null or schema can be change in backend
///so unnecessary coupling with them may  causes exception or break working app feature if something changed in back-end
class ContactEntity {
  // For some reason this a field may be null or not present so to avoid hidden bug ,
  // crash better  or parsing exception to use nullable
  final int id;
  final String firstName;
  final String lastName;
  final String mobile;
  final String email;
  final String? imageUrl;
  final bool? isOnline;
  final String? lastSeen;

  ContactEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.email,
    required this.imageUrl,
    required this.isOnline,
    required this.lastSeen,
  });

  // From JSON constructor

  /// Avoid explicit type casting such  ['x'] as y   to avoid unwanted exception or bug as the backend may return a JSON
  /// with missing or null fields. Typecasting null values or using expressions can throw exceptions and cause unwanted bugs
  factory ContactEntity.fromJson(Map<String, dynamic> json) {
    return ContactEntity(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      mobile: json['mobile'],
      email: json['email'],
      imageUrl: json['image_url'],
      isOnline: json['is_online'],
      lastSeen:json['last_seen']
    );
  }


  @override
  String toString() {
    return 'ContactEntity{id: $id, firstName: $firstName, lastName: $lastName, mobile: $mobile, email: $email, imageUrl: $imageUrl,'
        ' isOnline: $isOnline,lastSeen: $lastSeen}';
  }
}

