import 'package:client/auth/recover_password_page.dart';
import 'package:client/auth/reset_password_page.dart';
import 'package:client/auth/signin_page.dart';
import 'package:client/auth/signup_page.dart';
import 'package:client/core/supabase.dart';
import 'package:client/home/home_page.dart';
import 'package:client/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: const String.fromEnvironment("SUPABASE_URL"),
      anonKey: const String.fromEnvironment("SUPABASE_ANON_KEY"),
      debug: true);

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
  final _router = GoRouter(
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
          return RecoverPasswordPage(
            key: state.pageKey,
          );
        },
      )
    ],
  );

  @override
  void initState() {
    super.initState();

    /// Listen for authentication events and redirect to
    /// correct page when key events are detected.
    ///
    /// note: widget might not be mounted here, so avoid
    /// use of context. use router directly.
    supabase.auth.onAuthStateChange.listen(
      (data) {
        switch (data.event) {
          case AuthChangeEvent.signedIn:
            _router.replace("/");
            break;

          case AuthChangeEvent.signedOut:
            _router.replace("/signin");
            break;

          case AuthChangeEvent.passwordRecovery:
            _router.replace("/recover-password");
            break;

          default:
            break;
        }
      },
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Team Chat',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData.dark(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        useMaterial3: true,
      ),
    );
  }
}
