class SearchHistory {
  final String id;
  final String userId;
  final String query;
  final String resultType;
  final String resultId;
  final DateTime createdAt;

  SearchHistory({
    required this.id,
    required this.userId,
    required this.query,
    required this.resultType,
    required this.resultId,
    required this.createdAt,
  });

  // JSON → SearchHistory
  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      query: json['query'] ?? '',
      resultType: json['result_type'] ?? '',
      resultId: json['result_id'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // SearchHistory → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'query': query,
      'result_type': resultType,
      'result_id': resultId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}