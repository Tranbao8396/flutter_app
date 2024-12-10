import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'database.dart';
import 'home.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});
  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

Future checkLogin(String email, String password) async {
  MySqlConnection conn = await database();
  var result = await conn.query("SELECT * FROM users WHERE user_email = '$email' and user_pass = '$password'");

  if (result.isNotEmpty) {
    return result;
  } else {
    return null;
  }
}

class _LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Login to Management App'),
      ),
      body: Center(
        child: SizedBox(
          height: 400,
          child: Card(
            margin: const EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(('Welcome to Management app').toUpperCase()),
                Padding(
                    padding: const EdgeInsets.all(15),
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your email',
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your password',
                    ),
                  ),
                ),
                ElevatedButton(
                  child: Text('Login'),
                  onPressed: () async {
                    var email = emailController.text;
                    var password = passwordController.text;

                    if (email != "" || password != "") {
                      var authed = await checkLogin(email, password);
                      if (authed != null) {
                        if(context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => MyHomePage()),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('Invalid email or password'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        }
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Please enter email and password'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
