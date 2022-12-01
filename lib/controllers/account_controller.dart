import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<String?> signUp(
    {required String email, required String password}) async {
  try {
    final UserCredential credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return null;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      return 'The account already exists for that email.';
    }
  } catch (e) {
    return e.toString();
  }
  return 'Something went wrong, please try again later';
}

Future<String?> loginAccount(
    {required String email, required String password}) async {
  try {
    final UserCredential credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return null;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return "No user found for that email.";
    } else if (e.code == 'wrong-password') {
      return 'Wrong password provided for that user.';
    }
  } catch (e) {
    return e.toString();
  }
  return 'Something went wrong, please try again later';
}

Future<void> logoutAccount(BuildContext context) async {
  await FirebaseAuth.instance.signOut().then((value) =>
      Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false));
}
