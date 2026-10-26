class UserM {
  final String id;
  final String username;
  final String email;
  final String passwordHash;
  final String fullName;
  final String bio;
  final String phone;
  final String country;
  final String city;
  final DateTime birthDate;
  final String profilePictureUrl;
  final String coverPictureUrl;
  final String gender;

  final bool isVerified;
  final bool isPrivate;

  final int followersCount;
  final int followingCount;
  final int postsCount;

  final DateTime createdAt;
  final DateTime updatedAt;

  UserM({
    required this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.fullName,
    required this.bio,
    required this.phone,
    required this.country,
    required this.city,
    required this.birthDate,
    required this.profilePictureUrl,
    required this.coverPictureUrl,
    required this.gender,
    required this.isVerified,
    required this.isPrivate,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserM.fromJson(Map<String, dynamic> json) {
    return UserM(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      passwordHash: json['password_hash'] ?? '',
      fullName: json['full_name'] ?? '',
      bio: json['bio'] ?? '',
      phone: json['phone'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      birthDate: DateTime.parse(json['birth_date']),
      profilePictureUrl: json['profile_picture_url'] ?? '',
      coverPictureUrl: json['cover_picture_url'] ?? '',
      gender: json['gender'] ?? '',
      isVerified: json['is_verified'] ?? false,
      isPrivate: json['is_private'] ?? false,
      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
      postsCount: json['posts_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password_hash': passwordHash,
      'full_name': fullName,
      'bio': bio,
      'phone': phone,
      'country': country,
      'city': city,
      'birth_date': birthDate.toIso8601String(),
      'profile_picture_url': profilePictureUrl,
      'cover_picture_url': coverPictureUrl,
      'gender': gender,
      'is_verified': isVerified,
      'is_private': isPrivate,
      'followers_count': followersCount,
      'following_count': followingCount,
      'posts_count': postsCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}