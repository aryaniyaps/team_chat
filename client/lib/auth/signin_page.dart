import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool _isLoading = false;

  Future<void> signin() async {
    setState(() {
      _isLoading = true;
    });

    final state = _formKey.currentState!;

    if (state.saveAndValidate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: state.value["email"],
          password: state.value["password"],
        );
      } catch (_) {
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
        title: const Text("sign in"),
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
                      ],
                    ),
                    decoration: const InputDecoration(
                      labelText: "password",
                      hintText: "enter your password",
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    child: const Text("forgot password?"),
                    onTap: () {
                      context.push("/reset-password");
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : signin,
                    child: const Text(
                      "sign in",
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    child: const Text(
                      "don't have an account?",
                    ),
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
