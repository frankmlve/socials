import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socials/presentation/manager/auth/auth.dart';
import 'package:socials/presentation/pages/auth/register_page.dart';
import 'package:socials/presentation/pages/auth/reset_password.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool _obscurePasswordText = true;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isLoading = true;
        });
        await Auth().signInWithEmailAndPassword(
            email: _controllerEmail.text, password: _controllerPassword.text);
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _title() {
    return const Text('Login');
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
    bool obscureText,
    IconButton? icon,
    String? Function(String?) validator,
  ) {
    return TextFormField(
      controller: controller,
      decoration:
          InputDecoration(labelText: title.toUpperCase(), suffixIcon: icon),
      obscureText: obscureText,
      validator: validator,
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : 'Something went wrong: $errorMessage',
      style: TextStyle(color: Colors.red),
    );
  }

  Widget _submitButton() {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ElevatedButton(
            onPressed: signInWithEmailAndPassword,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, foregroundColor: Colors.white),
            child: Text('Login'),
          );
  }

  TextButton _buildRegisterButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RegisterPage()));
        },
        style: TextButton.styleFrom(foregroundColor: Colors.purple,
        textStyle: const TextStyle(fontWeight: FontWeight.bold,
        fontSize: 17)),
        child: Text('Or click here to register.'));
  }

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

  String? validatePassword(String? value) {
    const pattern = r'^(?=.*[A-Z])(?=.*[a-zA-Z]{6,})(?=.*\d{3,})[a-zA-Z0-9.]*$';
    final regex = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (value.isNotEmpty && !regex.hasMatch(value)) {
      return 'Enter a valid password, do not use spaces \nor special characters like !@#\$%^&*()\n'
          'Use at least 3 numbers and 1 uppercase letters';
    }
    return null;
  }

  Widget _forgetPasswordButton(BuildContext context) {
    return FilledButton(
      onPressed: () {
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => ResetPassword()));
        },
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.purple
      ),
      child: Text('Forgot Password ?'),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              _entryField(
                  'email', _controllerEmail, false, null, validateEmail),
              _entryField(
                  'password',
                  _controllerPassword,
                  _obscurePasswordText,
                  IconButton(
                    icon: Icon(
                      _obscurePasswordText
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.purple,
                    ),
                    onPressed: () => setState(() {
                      _obscurePasswordText = !_obscurePasswordText;
                    }),
                  ),
                  validatePassword),
              _errorMessage(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _submitButton(),
                  _forgetPasswordButton(context),
                ],
              ),
              _buildRegisterButton(context),
            ])),
      ),
    );
  }
}
