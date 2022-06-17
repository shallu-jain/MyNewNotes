import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/utilities/dialogs/error_dialog.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Column(
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
                // await FirebaseAuth.instance.signInWithEmailAndPassword(
                //     email: email, password: password);
              await  AuthService.firebase().logIn(email: email, password: password);

                // final user = FirebaseAuth.instance.currentUser; // these is for firebase
                final user = AuthService.firebase().currentUser;  // these is for AuthService
                if (user?.isEmailVerified ?? false) {
                  // user email is verified
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(notesRoute, (route) => false);
                }
                else
                  {
                    // user email is not verified
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false);
                  }
                // devtools.log(userCredential.toString());

                // print(userCredential);
              }
              on UserNotFoundAuthException{
                await showErrorDialog(context, "User Not Found");
              }
              on WrongPasswordAuthException{
                await showErrorDialog(context, "Wrong Password Credential");
              }
              on GenericAuthException{
                await showErrorDialog(context, 'Authentication Error');
              }


              // on FirebaseAuthException catch (e) {
              //   if (e.code == 'user-not-found') {
              //     // devtools.log("User Not Found");
              //     await showErrorDialog(context, "User Not Found");
              //     // print('User not Found');
              //   } else if (e.code == 'wrong-password') {
              //     await showErrorDialog(context, "Wrong Credential");
              //     // devtools.log('Wrong Password');
              //   } else {
              //     await showErrorDialog(context, 'Error:${e.code}');
              //   }
              // } catch (e)
              // {
              //   await showErrorDialog(
              //     context,
              //     e.toString(),
              //   );
              // }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text("Not Registered Yet? Register Here!"),
          )
        ],
      ), // these we can scaffold
    );
  }
}
