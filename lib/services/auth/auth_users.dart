import 'package:firebase_auth/firebase_auth.dart' show User;
// import 'package:firebase_auth/firebase_auth.dart' as Firebase show User; // we can also write the above line like these

class AuthUser {
  final bool isEmailVerified;
  final String ?email;

  const AuthUser({required this.email, required this.isEmailVerified});

  factory AuthUser.fromFirebase(User user) =>
      AuthUser(email: user.email, isEmailVerified: user.emailVerified);

  // void testing() {
  //   AuthUser(isEmailVerified: true, email: '');
  // }
}
