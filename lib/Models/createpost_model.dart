class CreatePostRequest {
  final String id;
  final String userId;
  final String caption;
  final String mediaUrl;
  final String thumbnailUrl;
  final String mediaType;
  final String location;

  CreatePostRequest({
    required this.id,
    required this.userId,
    required this.caption,
    required this.mediaUrl,
    required this.thumbnailUrl,
    required this.mediaType,
    required this.location,
  });

  factory CreatePostRequest.fromJson(Map<String, dynamic> json) {
    return CreatePostRequest(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      caption: json['caption'] ?? '',
      mediaUrl: json['media_url'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      mediaType: json['media_type'] ?? '',
      location: json['location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'caption': caption,
      'media_url': mediaUrl,
      'thumbnail_url': thumbnailUrl,
      'media_type': mediaType,
      'location': location,
    };
  }
}