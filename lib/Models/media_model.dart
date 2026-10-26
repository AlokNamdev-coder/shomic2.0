class MediaModel {
  final int id;
  final String title;
  final String artist;
  final String album;
  final int duration;
  final int size;

  const MediaModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.size,
  });

  factory MediaModel.fromMap(Map<dynamic, dynamic> map) {
    return MediaModel(
      id: map["id"],
      title: map["title"],
      artist: map["artist"],
      album: map["album"],
      duration: map["duration"],
      size: map["size"],
    );
  }
}
