import 'dart:convert';

import 'package:boca_raton_gpt/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String siteUrl =
    'https://pd6xmmpkbf.execute-api.us-east-1.amazonaws.com/v1';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Widget loginInputButton = Text('Login');
  Widget loadingAnim = CupertinoActivityIndicator(color: Colors.white);
  bool _obscurePassword = true;
  bool isLoading = false;

  void setLoading(bool state) {
    setState(() {
      isLoading = state;
      if (state) {
        loginInputButton = loadingAnim;
      } else {
        loginInputButton = const Text('Login');
      }
    });
  }

  Future<void> attemptLogin(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    final url = Uri.parse('$siteUrl/chat');

    try {
      setLoading(true);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': 'none'}),
      );
      //{'email: $email, password: $password'}
      if (response.statusCode == 200) {
        //save user data locally here
        final data = jsonDecode(response.body);
        print(data['response']);
        //prefs.setString('userId', data._id);
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => TabNavigator()),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error Logging In: $e");
      }
    } finally {
      setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Login')),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoTextField(
                controller: _emailController,
                placeholder: 'Email',
                keyboardType: TextInputType.emailAddress,
                padding: const EdgeInsets.all(16),
              ),
              const SizedBox(height: 20),
              CupertinoTextField(
                controller: _passwordController,
                placeholder: 'Password',
                obscureText: _obscurePassword,
                padding: const EdgeInsets.all(16),
                suffix: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  child: Icon(
                    _obscurePassword
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              CupertinoButton.filled(
                child: loginInputButton,
                onPressed:
                    () =>
                        isLoading
                            ? null
                            : attemptLogin(
                              _emailController.text,
                              _passwordController.text,
                            ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
