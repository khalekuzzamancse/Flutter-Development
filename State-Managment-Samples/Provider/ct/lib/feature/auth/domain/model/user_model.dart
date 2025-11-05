class UserProfileModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String imageUrl;
  final String bio;
  final String? website;
  final String? address;
  final bool isOnline;
  final bool isVerified;
  final String? token;

  UserProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.imageUrl,
    required this.bio,
    this.website,
    this.address,
    required this.isOnline,
    required this.isVerified,
    this.token,
  });
  UserProfileModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? mobile,
    String? imageUrl,
    String? bio,
    String? website,
    String? address,
    bool? isOnline,
    bool? isVerified,
    String? token,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      imageUrl: imageUrl ?? this.imageUrl,
      bio: bio ?? this.bio,
      website: website ?? this.website,
      address: address ?? this.address,
      isOnline: isOnline ?? this.isOnline,
      isVerified: isVerified ?? this.isVerified,
      token: token ?? this.token,
    );
  }



  @override
  String toString() {
    return 'UserModel2(id: $id, firstName: $firstName, lastName: $lastName, email: $email, mobile: $mobile, imageUrl: $imageUrl, bio: $bio, website: $website, address: $address, isOnline: $isOnline, isVerified: $isVerified, token: $token)';
  }
}





class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String image;
  final bool isVerified;
  final String? token;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.image,
    required this.isVerified,
    required this.token,
  });

  // CopyWith method to allow creating a new instance with updated values for properties
  UserModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? mobile,
    String? image,
    int? gender,
    bool? isApproved,
    bool? isVerified,
    bool? isStaff,
    bool? isSuperuser,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      image: image ?? this.image,
      isVerified: isVerified ?? this.isVerified,
      token: token ?? this.token,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, firstName: $firstName, lastName: $lastName, email: $email, mobile: $mobile, image: $image, isVerified: $isVerified, token: $token)';
  }
}
