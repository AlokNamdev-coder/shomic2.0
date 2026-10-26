import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Models/search_history_model.dart';

const String baseUrl = 'http://localhost:3000';

Future<bool> createHistory(SearchHistory history) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/search/history'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(history.toJson()),
    );

    if (response.statusCode == 201) {
      print('Search history stored successfully');
      return true;
    }

    print('Failed to store search history: ${response.statusCode}');
    print(response.body);

    return false;
  } catch (e) {
    print('Error creating search history: $e');
    return false;
  }
}

Future<Map<String, dynamic>> getSearchHistory({
  required String userId,
  int limit = 20,
  String? cursorTime,
  String? cursorId,
}) async {
  try {
    final queryParameters = <String, String>{
      'limit': limit.toString(),
    };

    if (cursorTime != null && cursorId != null) {
      queryParameters['cursor_time'] = cursorTime;
      queryParameters['cursor_id'] = cursorId;
    }

    final uri = Uri.parse(
      '$baseUrl/users/$userId/search-history',
    ).replace(
      queryParameters: queryParameters,
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List<SearchHistory> history =
      (data['search_history'] as List)
          .map(
            (item) => SearchHistory.fromJson(item),
      )
          .toList();

      return {
        'search_history': history,
        'next_cursor': data['next_cursor'],
        'has_next': data['has_next'],
      };
    }

    print(
      'Failed to fetch search history: ${response.statusCode}',
    );
    print(response.body);

    return {
      'search_history': <SearchHistory>[],
      'next_cursor': null,
      'has_next': false,
    };
  } catch (e) {
    print('Error fetching search history: $e');

    return {
      'search_history': <SearchHistory>[],
      'next_cursor': null,
      'has_next': false,
    };
  }
}