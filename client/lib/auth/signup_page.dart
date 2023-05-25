import 'dart:async';

import 'package:client/core/supabase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
                    "sign up",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 30),
                  FormBuilderTextField(
                    name: "full-name",
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.maxLength(50),
                      ],
                    ),
                    decoration: const InputDecoration(
                      labelText: "full name",
                      hintText: "enter your full name",
                    ),
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
                        FormBuilderValidators.minLength(12),
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
                          await supabase.auth.signUp(
                            password: state.value["password"],
                            email: state.value["email"],
                            data: {
                              "full_name": state.value["full-name"],
                            },
                            emailRedirectTo: kIsWeb
                                ? null
                                : 'io.supabase.flutterquickstart://login-callback/',
                          );
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Check your inbox to confirm your email",
                                ),
                              ),
                            );
                          }
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
                      "create account",
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    child: Text(
                      "already have an account?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onTap: () {
                      context.go("/signin");
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
