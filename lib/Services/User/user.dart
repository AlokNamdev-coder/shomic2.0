import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Models/user_models.dart';

const String baseUrl = 'http://localhost:3000';

Future<UserM?> fetchUser(String userId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return UserM.fromJson(data);
    }

    if (response.statusCode == 404) {
      print('User not found');
      return null;
    }

    print('Failed to fetch user: ${response.statusCode}');
    print(response.body);

    return null;
  } catch (e) {
    print('Error fetching user: $e');
    return null;
  }
}

Future<UserM?> createUser(UserM user) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return UserM.fromJson(data);
    }

    print('Failed to create user: ${response.statusCode}');
    print(response.body);

    return null;
  } catch (e) {
    print('Error creating user: $e');
    return null;
  }
}

Future<bool> updateUser(
    String userId,
    String field,
    dynamic value,
    ) async {
  try {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId/$field'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'value': value,
      }),
    );

    if (response.statusCode == 200) {
      print('User $field updated successfully');
      return true;
    }

    print('Failed to update user: ${response.statusCode}');
    print(response.body);

    return false;
  } catch (e) {
    print('Error updating user: $e');
    return false;
  }
}

Future<bool> deleteUser(String userId) async {
  try {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$userId'),
    );

    if (response.statusCode == 200) {
      print('User deleted successfully');
      return true;
    }

    print('Failed to delete user: ${response.statusCode}');
    print(response.body);

    return false;
  } catch (e) {
    print('Error deleting user: $e');
    return false;
  }
}