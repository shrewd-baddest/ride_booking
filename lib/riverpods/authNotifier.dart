import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:ride_booking/Models/user_model.dart';
import 'package:ride_booking/Models/login_model.dart';

class AuthNotifier extends AsyncNotifier<LoginResponse?> {
  @override
  Future<LoginResponse?> build() async => null;

  Future<LoginResponse?> _submit(User user, String url) async {
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

      state = AsyncData(LoginResponse.fromJson(jsonDecode(res)));
      return LoginResponse.fromJson(jsonDecode(res));
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return null;
    }
  }

  Future<LoginResponse?> login(User user, String url) => _submit(user, url);

  Future<LoginResponse?> register(User user, String url) => _submit(user, url);
}
