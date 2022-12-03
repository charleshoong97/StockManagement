import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory/constants/colors.dart';
import 'package:inventory/controllers/account_controller.dart';
import 'package:inventory/pages/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static const route = "/signup";

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  final ValueNotifier<String> errorMessage = ValueNotifier<String>("");
  final ValueNotifier<bool> isSubmitting = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isSuccess = ValueNotifier<bool>(false);

  Future<bool> signUpAccount() async {
    FocusManager.instance.primaryFocus!.unfocus();
    isSuccess.value = false;
    errorMessage.value = '';
    if (_formKey.currentState!.validate()) {
      isSubmitting.value = true;
      String? result = await signUp(email: email.text, password: password.text);
      isSubmitting.value = false;
      if (result != null) {
        errorMessage.value = result;
      } else {
        FirebaseAuth.instance.signOut();
        isSuccess.value = true;
        await Future.delayed(const Duration(seconds: 6));
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.27,
                left: 30,
                right: 30,
                bottom: MediaQuery.of(context).viewInsets.bottom + 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Register now !!!",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ValueListenableBuilder<bool>(
                      valueListenable: isSubmitting,
                      builder: ((context, bool submitting, child) =>
                          TextFormField(
                            enabled: !submitting,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: submitting
                                    ? Colors.grey.shade100
                                    : Colors.white,
                                label: const Text("Email Address"),
                                // contentPadding: ,
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 0.5),
                                )),
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email address cannot be empty";
                              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return "Invalid email address";
                              }
                              return null;
                            },
                          ))),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: ValueListenableBuilder<bool>(
                      valueListenable: isSubmitting,
                      builder: ((context, bool submitting, child) =>
                          TextFormField(
                            enabled: !submitting,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: submitting
                                    ? Colors.grey.shade100
                                    : Colors.white,
                                label: const Text("Password"),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 0.5),
                                )),
                            controller: password,
                            obscureText: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r' '))
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password cannot be empty";
                              } else if (value.length < 6) {
                                return "Invalid password";
                              }
                              return null;
                            },
                          ))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: ValueListenableBuilder<bool>(
                      valueListenable: isSubmitting,
                      builder: ((context, bool submitting, child) =>
                          TextFormField(
                            enabled: !submitting,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: submitting
                                    ? Colors.grey.shade100
                                    : Colors.white,
                                label: const Text("Re-enter Password"),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 0.5),
                                )),
                            controller: confirmPassword,
                            obscureText: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r' '))
                            ],
                            onFieldSubmitted: (value) async {
                              if (!submitting &&
                                  await signUpAccount() &&
                                  mounted) {
                                Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '${LoginPage.route}${email.text}',
                                    (route) => route.settings.name == '/');
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Re-enter password cannot be empty";
                              } else if (value != password.text) {
                                return "Re-enter password is not matched";
                              }
                              return null;
                            },
                          ))),
                ),
                Align(
                  alignment: Alignment.center,
                  child: ValueListenableBuilder<bool>(
                      valueListenable: isSubmitting,
                      builder:
                          ((context, bool submitting, child) => ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    textStyle: MaterialStateProperty.resolveWith(
                                        (states) =>
                                            states.contains(MaterialState.pressed)
                                                ? const TextStyle(
                                                    fontSize: 19,
                                                    fontWeight: FontWeight.w300,
                                                    letterSpacing: 2.5)
                                                : const TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 2.5)),
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10)),
                                    enableFeedback: submitting ? false : true,
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => submitting ? disabledButtonColor : appColor)),
                                onPressed: submitting
                                    ? null
                                    : () async {
                                        if (!submitting &&
                                            await signUpAccount() &&
                                            mounted) {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              '${LoginPage.route}${email.text}',
                                              (route) =>
                                                  route.settings.name == '/');
                                        }
                                      },
                                child: Text(
                                  submitting ? "Loading..." : "Register",
                                ),
                              ))),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ValueListenableBuilder(
                        valueListenable: isSuccess,
                        builder: ((context, bool value, child) => Visibility(
                              visible: value,
                              child: const Text(
                                "Sign Up Successfully.\nPlease check your inbox to verify your email address",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                            ))),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ValueListenableBuilder(
                        valueListenable: errorMessage,
                        builder: ((context, String value, child) => Text(
                              value,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Already have an account?",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
