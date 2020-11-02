import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/main_backend/mainArea.dart';

class AuthenticationService {
  final FirebaseAuth fbAuth;

  AuthenticationService(this.fbAuth);

  Stream<User> get authStateChanges => fbAuth.authStateChanges();

  Future<String> signInAnon() async {
    try {
      await fbAuth.signInAnonymously();
      return "Signed in as guest!";
    }
    on FirebaseAuthException catch(e) {
      return e.message;
    }
  }

  Future<String> signIn({String email, String password}) async{
    try {
      await fbAuth.signInWithEmailAndPassword(email: email, password: password);
      User fbUser = FirebaseAuth.instance.currentUser;
      return "Signed in!";
    }
    on FirebaseAuthException catch(e) {
      return e.message;
    }
  }

  Future<String> signUp({String email, String password}) async{
    try {
      await fbAuth.createUserWithEmailAndPassword(email: email, password: password);
      return "Signed up!";
    }
    on FirebaseAuthException catch(e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    print("user: " + fbUser.uid);
    await fbAuth.signOut();
  }

}