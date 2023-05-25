import 'dart:async';

import 'package:client/core/supabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool _isRedirecting = false;

  late final StreamSubscription<AuthState> _authStateSubscription;

  @override
  void initState() {
    _authStateSubscription = supabase.auth.onAuthStateChange.listen(
      (event) {
        if (_isRedirecting) return;
        final session = event.session;
        if (session != null) {
          _isRedirecting = true;
          context.go("/");
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "let's sign in",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FormBuilderTextField(
                    name: "email",
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ],
                    ),
                    decoration: const InputDecoration(
                      labelText: "email address",
                      hintText: "enter your email address",
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FormBuilderTextField(
                    name: "password",
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(),
                      ],
                    ),
                    decoration: const InputDecoration(
                      labelText: "password",
                      hintText: "enter your password",
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final state = _formKey.currentState!;

                      if (state.saveAndValidate()) {
                        try {
                          await supabase.auth.signInWithPassword(
                            password: state.value["password"],
                            email: state.value["email"],
                          );
                        } on AuthException catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error.message),
                            ),
                          );
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("unexpected error occured"),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      "sign in",
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    child: const Text("don't have an account?"),
                    onTap: () {
                      context.go("/signup");
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
