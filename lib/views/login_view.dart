import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    //  implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      appBar: AppBar(title:const Text('Login Page'),),
      body:
      Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: " Enter your Email here",
            ),
          ),
          TextField(
            obscureText: true,
            controller: _password,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: " Enter your Password here",
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              // FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
              try {
                await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: password);
                // devtools.log(userCredential.toString());
                Navigator.of(context).pushNamedAndRemoveUntil( '/notes/', (route) => false);
                // print(userCredential);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  devtools.log("User Not Found");
                  // print('User not Found');
                } else if (e.code == 'wrong-password') {
                  devtools.log('Wrong Password');
                }
              }
            },
            child:const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/register/', (route) => false);
            },
            child:const Text("Not Registered Yet? Register Here!"),
          )
        ],
      ), // these we can scaffold
    );
  }
}
