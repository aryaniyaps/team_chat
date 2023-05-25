import 'package:client/core/supabase.dart';

class AuthRepository {
  Future<void> signup({
    required String email,
    required String password,
    required String fullName,
    required String redirectURL,
  }) async {
    await supabase.auth.signUp(
      password: password,
      email: email,
      emailRedirectTo: redirectURL,
      data: {
        "full_name": fullName,
      },
    );
  }

  Future<void> signin({
    required String email,
    required String password,
  }) async {
    await supabase.auth.signInWithPassword(
      password: password,
      email: email,
    );
  }

  Future<void> signout() async {
    await supabase.auth.signOut();
  }
}
