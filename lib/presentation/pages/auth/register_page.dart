import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socials/domain/repository/user_repository.dart';
import 'package:socials/presentation/manager/auth/auth.dart';
import 'package:socials/presentation/model/new_user.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {

  String? errorMessage = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPasswordConfirm =
      TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final UserRepository _userRepository = UserRepository();
  bool _obscurePasswordText = true;
  bool _isLoading = false;

  Future<void> registerWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final UserCredential user = await Auth().createUserWithEmailAndPassword(
            email: _controllerEmail.text, password: _controllerPassword.text);
        NewUser user0 = NewUser(
          id: user.user!.uid,
          name: _controllerName.text,
          email: _controllerEmail.text,

        );
        _userRepository.createUser(user0).then((value) => Navigator.pop(context));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          setState(() {
            errorMessage = 'The password provided is too weak.';
          });
        } else if (e.code == 'email-already-in-use') {
          setState(() {
            errorMessage = 'The account already exists for that email.';
          });
        }
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _entryField(String title, TextEditingController controller,
      String? Function(String?) validator, bool obscureText, IconButton? icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: title, suffixIcon: icon),
      validator: validator,
      obscureText: obscureText,

    );
  }

  Widget _errorMessage() {
    return  Text(
        errorMessage == '' ? '' : 'Something went wrong: $errorMessage',
        style: const TextStyle(color: Colors.red));
  }

  Widget _submitButton() {
    return !_isLoading ? ElevatedButton(
      onPressed: registerWithEmailAndPassword,
      style:ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white
      ),
      child: Text('Register'),
    ) :
    Center(child: CircularProgressIndicator());
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

  String? validateUsername(String? value) {
    const pattern = r'^[a-zA-Z0-9._]{6,12}$';
    final regex = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    if (value.length < 6) {
      return 'Username must be at least 6 characters';
    }
    if (value.length > 12) {
      return 'Username must be at most 12 characters';
    }
    if (value.isNotEmpty && !regex.hasMatch(value)) {
      return 'Enter a valid Username, use only letters, numbers, . and _';
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _entryField('Username', _controllerName, validateUsername, false, null),
              _entryField('Email', _controllerEmail, validateEmail, false, null),
              _entryField(
                  'Password',
                  _controllerPassword,
                  validatePassword,
                  _obscurePasswordText,
                  IconButton(
                    icon: Icon(_obscurePasswordText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.purple,),
                    onPressed: () => setState(() {
                      _obscurePasswordText = !_obscurePasswordText;
                    }),
                  )),
              _entryField('Confirm Password', _controllerPasswordConfirm,
                  (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if (value != _controllerPassword.text) {
                  return 'Passwords do not match';
                }
                return null;
              }, true, null),
              _errorMessage(),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }
}
