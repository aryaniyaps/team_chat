import 'package:client/auth/recover_password_page.dart';
import 'package:client/auth/reset_password_page.dart';
import 'package:client/auth/signin_page.dart';
import 'package:client/auth/signup_page.dart';
import 'package:client/home/home_page.dart';
import 'package:client/splash/splash_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final router = GoRouter(
    initialLocation: "/splash",
    routes: [
      GoRoute(
        path: "/splash",
        builder: (context, state) {
          return SplashPage(
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        path: "/",
        builder: (context, state) {
          return HomePage(
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        path: "/signin",
        builder: (context, state) {
          return SignInPage(
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        path: "/signup",
        builder: (context, state) {
          return SignUpPage(
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        path: "/reset-password",
        builder: (context, state) {
          return ResetPasswordPage(
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        path: "/recover-password",
        builder: (context, state) {
          return UpdatePasswordPage(
            key: state.pageKey,
          );
        },
      )
    ],
  );

  @override
  void initState() {
    super.initState();

    setupAuth();
    setupDynamiclinks();
  }

  Future<void> setupDynamiclinks() async {
    final initialLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      final deepLink = initialLink.link;
      router.pushNamed(deepLink.path);
    }

    FirebaseDynamicLinks.instance.onLink.listen(
      (pendingDynamicLinkData) {
        final deepLink = pendingDynamicLinkData.link;
        router.pushNamed(deepLink.path);
      },
    );
  }

  void setupAuth() {
    /// Listen for authentication events and redirect to
    /// correct page when key events are detected.
    ///
    /// note: widget might not be mounted here, so avoid
    /// use of context. use router directly.
    FirebaseAuth.instance.authStateChanges().listen(
      (User? user) {
        if (user == null) {
          // user signed out
          router.replace("/signin");
        } else {
          // user signed in
          router.replace("/");
        }
      },
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'team chat',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
