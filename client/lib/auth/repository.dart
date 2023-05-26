import 'package:client/core/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  Future<User> signup({
    required String email,
    required String password,
    required String fullName,
    required String redirectURL,
  }) async {
    final response = await supabase.auth.signUp(
      password: password,
      email: email,
      emailRedirectTo: redirectURL,
      data: {
        "full_name": fullName,
      },
    );
    return response.user!;
  }

  Future<User> signin({
    required String email,
    required String password,
  }) async {
    final response = await supabase.auth.signInWithPassword(
      password: password,
      email: email,
    );
    return response.user!;
  }

  Future<void> signout() async {
    await supabase.auth.signOut();
  }
}
