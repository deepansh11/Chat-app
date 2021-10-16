import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(String email, String username, String password,
      File image, bool isLogin, BuildContext context) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userPass = '';
  var _userName = '';
  File _userImage = File('');

  void _pickedImage(File image) {
    _userImage = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState;
    if (isValid != null) {
      var f = isValid.validate();
      FocusScope.of(context).unfocus();

      if (_userImage == File('') && !_isLogin) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please pick an Image'),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        return;
      }

      if (f) {
        isValid.save();
        widget.submitFn(
          _userEmail.trim(),
          _userName.trim(),
          _userPass.trim(),
          _userImage,
          _isLogin,
          context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (!_isLogin)
                      UserImage(
                        imagePickFn: _pickedImage,
                      ),
                    TextFormField(
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      key: const ValueKey('email'),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(label: Text('Email address')),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) {
                        _userEmail = value!;
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: const ValueKey('username'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return 'Please enter a valid username';
                          }
                        },
                        onSaved: (value) {
                          _userName = value!;
                        },
                        decoration:
                            const InputDecoration(label: Text('Username')),
                      ),
                    TextFormField(
                      key: const ValueKey('password'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 7) {
                          return 'Please enter a valid password';
                        }
                      },
                      onSaved: (value) {
                        _userPass = value!;
                      },
                      obscureText: true,
                      decoration:
                          const InputDecoration(label: Text('Password')),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    if (widget.isLoading) const CircularProgressIndicator(),
                    if (!widget.isLoading)
                      ElevatedButton(
                        onPressed: _trySubmit,
                        child: Text(_isLogin ? 'Login' : 'Sign Up'),
                      ),
                    if (!widget.isLoading)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? 'Create a new account'
                            : 'Already have an account?'),
                      ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
