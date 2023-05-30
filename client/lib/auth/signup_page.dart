import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool _isLoading = false;

  Future<void> signup() async {
    setState(() {
      _isLoading = true;
    });

    final state = _formKey.currentState!;

    if (state.saveAndValidate()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: state.value["email"],
          password: state.value["password"],
        );
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message.toString()),
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
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("sign up"),
        centerTitle: true,
      ),
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
                    "team chat",
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
                        FormBuilderValidators.minLength(12),
                      ],
                    ),
                    decoration: const InputDecoration(
                      labelText: "password",
                      hintText: "enter your password",
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : signup,
                    child: const Text(
                      "create account",
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    child: const Text(
                      "already have an account?",
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
