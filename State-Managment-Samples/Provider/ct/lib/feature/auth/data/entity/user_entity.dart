class UserEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String image;
  final String imageUrl;
  final String bio;
  final String? website;
  final String? address;
  final bool isOnline;

  UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.image,
    required this.imageUrl,
    required this.bio,
    this.website,
    this.address,
    required this.isOnline,
  });

  // fromJson constructor
  factory UserEntity.fromJsonOrThrow(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      mobile: json['mobile'],
      image: json['image'].toString(),  // Assuming image is an ID or URL as a string
      imageUrl: json['image_url'] ?? '',
      bio: json['bio'] ?? '',
      website: json['website'],
      address: json['address'],
      isOnline: json['is_online'] ?? false,
    );
  }

  // toString method for easy debugging/logging
  @override
  String toString() {
    return 'UserEntity(id: $id, firstName: $firstName, lastName: $lastName, email: $email, mobile: $mobile, image: $image, imageUrl: $imageUrl, bio: $bio, website: $website, address: $address, isOnline: $isOnline)';
  }
}
