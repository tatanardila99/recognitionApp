class UserData {
  final int id;
  final String name;
  final String email;
  final String rol;
  final int status;
  final String? profileImageUrl;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.rol,
    required this.status,
    this.profileImageUrl,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      rol: json['rol'],
      status: json['status'] as int? ?? 1,
      profileImageUrl: json['profile_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'rol': rol,
      'profile_image_url': profileImageUrl,
    };
  }

  UserData copyWith({
    String? name,
    String? email,
    String? rol,
    int? status,
    String? profileImageUrl,
  }) {
    return UserData(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      rol: rol ?? this.rol,
      status: status ?? this.status,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
