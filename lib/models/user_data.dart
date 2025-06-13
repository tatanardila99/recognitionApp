class UserData {
  final int? id;
  final String? name;
  final String? email;
  final String? profileImageUrl;

  UserData({this.id, this.name, this.email, this.profileImageUrl});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImageUrl: json['profile_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image_url': profileImageUrl,
    };
  }


  UserData copyWith({String? name, String? email, String? profileImageUrl}) {
    return UserData(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}

