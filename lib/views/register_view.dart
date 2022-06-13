// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/utilities/show_error_dialog.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    //  implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register View'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Enter your Email here",
            ),
          ),
          TextField(
            obscureText: true,
            controller: _password,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter your Password here",
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                // final userCredential =
               await AuthService.firebase().createUser(email: email, password: password);
                // await FirebaseAuth.instance.createUserWithEmailAndPassword(
                //     email: email, password: password);
                // final user = FirebaseAuth.instance.currentUser; // these is for firebase
                // await user?.sendEmailVerification(); // these is for firebase

              AuthService.firebase().sendEmailVerification(); // these is for AuthService

                // devtools.log(userCredential.toString());
                Navigator.of(context)
                    .pushNamed(verifyEmailRoute); // Verify EmailRoute
              }

              on EmailAlreadyInUseAuthException{
                await showErrorDialog(context, 'Email Already In Used');
              }
              on WeakPasswordAuthException{
                await showErrorDialog(context, 'Weak Password');
              }
              on InvalidEmailAuthException{
                await showErrorDialog(context, 'Invalid Email');
              }
              on GenericAuthException{
                await showErrorDialog(context, 'Failed To Register');
              }

              // on FirebaseAuthException catch (e) {
              //   if (e.code == 'email-already-in-use') {
              //     // devtools.log('Email Already Used')
              //     await showErrorDialog(context, 'Email Already used');
              //   } else if (e.code == 'weak-password') {
              //     // devtools.log('WEAK PASSWORD');
              //     await showErrorDialog(context, 'Weak Password');
              //   } else if (e.code == 'invalid-email') {
              //     // devtools.log('INVALID EMAIL');
              //     await showErrorDialog(context, 'Invalid Email');
              //   } else {
              //     await showErrorDialog(context, 'Error:${e.code}');
              //   }
              // } catch (e) {
              //   await showErrorDialog(
              //     context,
              //     e.toString(),
              //   );
              // }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Already Registered? Login Here!'),
          )
        ],
      ),
    );
  }
}
