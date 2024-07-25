import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socials/presentation/manager/auth/auth.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controllerEmail = TextEditingController();
  String? errorMessage = '';

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    return value.isNotEmpty && !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : 'Something went wrong: $errorMessage',
      style: TextStyle(color: Colors.red),
    );
  }

  void _resetPassword(BuildContext context) {
    if (formKey.currentState!.validate()) {
      try {
        Auth()
            .resetPassword(email: controllerEmail.text)
            .then((_) => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('We have sent you an email.')),
                ));
        controllerEmail.clear();
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TextFormField(
                  controller: controllerEmail,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: validateEmail,
                ),
                SizedBox(
                  height: 20,
                ),
                FilledButton(
                  onPressed: () {
                    _resetPassword(context);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white
                  ),
                  child: const Text('Submit'),
                ),
                _errorMessage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
