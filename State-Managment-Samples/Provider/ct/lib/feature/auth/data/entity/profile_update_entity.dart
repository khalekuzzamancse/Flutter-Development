import 'dart:convert';

class EditProfileEntity {
  final String firstName;
  final String lastName;
  final String? bio;
  final String? website;
  final String? address;
  final  int? imageId;

  EditProfileEntity( {
    required this.firstName,
    required this.lastName,
    this.bio,
    this.website,
    this.address,
    this.imageId,
  });
  EditProfileEntity copyWith({
    String? firstName,
    String? lastName,
    String? bio,
    String? website,
    String? address,
    int? imageId
  }) {
    return EditProfileEntity(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      bio: bio ?? this.bio,
      website: website ?? this.website,
      address: address ?? this.address,
      imageId: imageId??this.imageId
    );
  }


  @override
  String toString() {
    return 'EditProfileEntity{firstName: $firstName, lastName: $lastName,'
        ' bio: $bio, website: $website, address: $address,imageLink:$imageId}';
  }

  String json()=>jsonEncode(toJson());


  Map<String, dynamic> toJson() {
    final map =<String,dynamic> {
      'first_name': firstName,
      'last_name': lastName,
    };

    if (bio != null) map['bio'] = bio!;
    if (website != null) map['website'] = website!;
    if (address != null) map['address'] = address!;
    if (imageId != null) map['image'] = imageId!;

    return map;
  }

}
