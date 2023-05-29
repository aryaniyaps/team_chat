import 'package:client/core/supabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool _isLoading = false;

  Future<void> recoverPassword() async {
    setState(() {
      _isLoading = true;
    });
    final state = _formKey.currentState!;

    if (state.saveAndValidate()) {
      try {
        await supabase.auth.updateUser(
          UserAttributes(
            password: state.value["password"],
          ),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "successfully updated password",
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
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("update password"),
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
                  FormBuilderTextField(
                    name: "password",
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(12),
                      ],
                    ),
                    decoration: const InputDecoration(
                      labelText: "new password",
                      hintText: "enter your new password",
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : recoverPassword,
                    child: const Text(
                      "update password",
                    ),
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
