import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_erpnext/auth/auth_token.dart';
import 'package:flutter_erpnext/screens/home.dart';
import 'package:flutter_erpnext/screens/tabs.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
                title: const Text('Invalid Input'),
                content: const Text(
                    'Please make sure a valid email and password entered'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text('Okay'),
                  )
                ],
              ));
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Please enter your password'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
          backgroundColor: Theme.of(context).colorScheme.onError,
        ),
      );
    }
  }

  String? extractSidFromCookie(String setCookieValue) {
    final RegExp regex = RegExp(r'sid=([^;]+)');
    final Match? match = regex.firstMatch(setCookieValue);
    return match?.group(1); // This will return null if there is no match
  }

  void loginValidation() async {
    final _email = emailController.text;
    final _password = passwordController.text;

    bool isValid = EmailValidator.validate(_email);

    print(isValid);

    if (!isValid) {
      if (Platform.isIOS) {
        showCupertinoDialog(
            context: context,
            builder: (ctx) => CupertinoAlertDialog(
                  title: const Text('Invalid Input'),
                  content: const Text('Please make sure a valid email entered'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text('Okay'),
                    )
                  ],
                ));
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Invalid Input'),
            content: const Text('Please make sure a valid email entered'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      }
      return;
    }

    if (_password.trim().isEmpty) {
      _showDialog();
      return;
    }

    print(_email);
    print(_password);

    final response = await http.post(
      Uri.parse('https://st-erp.frappe.cloud/api/method/login'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'usr': _email,
        'pwd': _password,
      }),
    );

    print(response.body);
    if (!mounted) return;
    if (response.statusCode == 200) {
      print(response.headers);
      String? setCookieValue = response.headers['set-cookie'];
      if (setCookieValue != null) {
        String? sid = extractSidFromCookie(setCookieValue);
        print(sid);
        if (sid != null && sid.isNotEmpty) {
          await AuthStorage.saveAuthToken(sid);
        } else {
          print('sid not found');
        }
      } else {
        print('set cookie');
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } else {
      print('unsuccess');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 246, 1),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 209, 207, 207),
                offset: Offset(
                  5.0,
                  5.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ), //BoxShadow
              BoxShadow(
                color: Colors.white,
                offset: Offset(0.0, 0.0),
                blurRadius: 0.0,
                spreadRadius: 0.0,
              ), //BoxShadow
            ],
          ),
          height: 450,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Image.asset(
                  'assets/images/erpnext_logo.png',
                  height: 40,
                  width: 40,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    label: Text(
                      'Email',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  maxLength: 40,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    label: Text(
                      'Password',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  maxLength: 20,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton.icon(
                  onPressed: () {
                    loginValidation();
                  },
                  icon: const Icon(
                    Icons.login,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromRGBO(43, 137, 255, 1),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
