import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory/pages/login_page.dart';

Future<String?> signUp(
    {required String email, required String password}) async {
  try {
    final UserCredential credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    credential.user!.sendEmailVerification();
    return null;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      return 'The account already exists for that email.';
    }
    return e.message;
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
    if (!credential.user!.emailVerified) {
      await credential.user!.sendEmailVerification();
      FirebaseAuth.instance.signOut();
      return "Please check your email inbox to verify your email address";
    }
    return null;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return "No user found for that email.";
    } else if (e.code == 'wrong-password') {
      return 'Wrong password provided for that user.';
    }
    return e.message;
  } catch (e) {
    print(e);
    return e.toString();
  }
  return 'Something went wrong, please try again later';
}

Future<void> logoutAccount(BuildContext context) async {
  await FirebaseAuth.instance.signOut().then((value) => Navigator.of(context)
      .pushNamedAndRemoveUntil(LoginPage.route, (route) => false));
}

Future<String?> resetPassword({required String email}) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
    );
    return null;
  } on FirebaseAuthException catch (e) {
    return e.message;
  } catch (e) {
    return e.toString();
  }
  return 'Something went wrong, please try again later';
}
