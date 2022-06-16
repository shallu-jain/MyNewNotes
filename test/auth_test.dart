// import 'package:flutter_test/flutter_test.dart';
// import 'package:my_notes/services/auth/auth_exceptions.dart';
// import 'package:my_notes/services/auth/auth_provider.dart';
// import 'package:my_notes/services/auth/auth_users.dart';
//
// void main() {
//   group('Mock Authentication', () {
//     final provider = MockAuthProvider();
//     test('Should not be initialized to begin with', () {
//       expect(provider._isInitialized, false);
//     });
//     test('Cannot log out if not initialized', () {
//       expect(
//           provider.logOut(), throwsA(TypeMatcher<NotInitializedException>()));
//     });
//     test('Should be able to initialized', () async {
//       await provider.initialize();
//       expect(provider.isInitialized, true);
//     });
//     test('User should be null after initialization', () {
//       expect(provider.currentUser, null);
//     });
//     test('Should be able to initialize in less than 2 second', () async {
//       await provider.initialize();
//       expect(provider.isInitialized, true);
//     }, timeout: Timeout(Duration(seconds: 2)));
//
//     test('Create user should delegate to login function', () async {
//       final badEmailUser =  provider.createUser(
//           email: "foobar@gmail.com", password: "anypassword");
//       expect(badEmailUser, throwsA(TypeMatcher<UserNotFoundAuthException>()));
//
//       final badPasswordUser =
//           provider.createUser(email: "someone@gmail.com", password: "foobar");
//       expect(
//           badPasswordUser, throwsA(TypeMatcher<WrongPasswordAuthException>()));
//       final user = await provider.createUser(email: 'foo', password: 'bar');
//       expect(provider.currentUser, user);
//       expect(user.isEmailVerified, false);
//     });
//     test("logged in user should be able to get verified", () {
//       provider.sendEmailVerification();
//       final user = provider.currentUser;
//       expect(user, isNotNull);
//       expect(user!.isEmailVerified, true);
//     });
//     test("Should be able to log out and log in again", () async {
//       await provider.logOut();
//       await provider.logIn(email: "email", password: 'password');
//       final user = provider.currentUser;
//       expect(user, isNotNull);
//     });
//   });
// }
//
// class NotInitializedException implements Exception {}
//
// class MockAuthProvider implements AuthProvider {
//   var _isInitialized = false;
//   AuthUser? _user;
//
//   bool get isInitialized => _isInitialized;
//
//   @override
//   Future<AuthUser> createUser(
//       {required String email, required String password}) async {
//     if (!isInitialized) {
//       throw NotInitializedException();
//     }
//     await Future.delayed(const Duration(seconds: 1));
//     return logIn(email: email, password: password);
//   }
//
//   @override
//   // TODO: implement currentUser
//   AuthUser? get currentUser => _user;
//
//   @override
//   Future<void> initialize() async {
//     await Future.delayed(const Duration(seconds: 1));
//     _isInitialized = true;
//   }
//
//   @override
//   Future<AuthUser> logIn({required String email, required String password}) {
//     if (!isInitialized) {
//       throw NotInitializedException();
//     }
//     if (email == "foo@bar.com") {
//       throw UserNotFoundAuthException();
//     }
//     if (password == "foobar") {
//       throw WrongPasswordAuthException();
//     }
//     const user = AuthUser(isEmailVerified: false, email: '');
//     _user = user;
//     return Future.value(user);
//   }
//
//   @override
//   Future<void> logOut() async {
//     if (!isInitialized) {
//       throw NotInitializedException();
//     }
//     if (_user == null) {
//       throw UserNotFoundAuthException();
//     }
//     await Future.delayed(const Duration(seconds: 1));
//     _user = null;
//   }
//
//   @override
//   Future<void> sendEmailVerification() async {
//     if (!isInitialized) {
//       throw NotInitializedException();
//     }
//     final user = _user;
//     if (user == null) {
//       throw UserNotFoundAuthException();
//     }
//     const newUser = AuthUser(isEmailVerified: true, email: '');
//     _user = newUser;
//   }
// }
