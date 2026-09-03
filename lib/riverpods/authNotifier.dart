import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:ride_booking/Models/user_model.dart';

class LoginNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async => '';

  Future<String?> _submit(User user, String url) async {
    state = const AsyncLoading();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      final res = response.body;
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(res);
      }

      state = AsyncData(res);
      return res;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return null;
    }
  }

  Future<String?> login(User user, String url) => _submit(user, url);

  Future<String?> register(User user, String url) => _submit(user, url);
}
