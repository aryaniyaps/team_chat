import 'package:client/core/supabase.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("welcome to team chat"),
            Text(supabase.auth.currentUser!.id),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await supabase.auth.signOut();
              },
              child: const Text("logout"),
            ),
          ],
        ),
      ),
    );
  }
}
