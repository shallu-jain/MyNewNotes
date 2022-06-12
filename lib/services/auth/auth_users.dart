import 'package:firebase_auth/firebase_auth.dart' show User;
// import 'package:firebase_auth/firebase_auth.dart' as Firebase show User; // we can also write the above line like these

class AuthUser {
  final bool isEmailVerified;

  const AuthUser(this.isEmailVerified);

  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
  
}
