import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory/constants/colors.dart';
import 'package:inventory/constants/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventory/controllers/account_controller.dart';
import 'package:inventory/pages/home_page.dart';
import 'package:inventory/pages/reset_password_page.dart';
import 'package:inventory/pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, this.emailAddress}) : super(key: key);

  static const route = "/login/";
  final String? emailAddress;

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final ValueNotifier<String> errorMessage = ValueNotifier<String>("");

  final ValueNotifier<bool> isSubmitting = ValueNotifier<bool>(false);

  @override
  initState() {
    super.initState();
    if (widget.emailAddress != null) {
      email.text = widget.emailAddress!;
    }
  }

  Future<bool> login() async {
    FocusManager.instance.primaryFocus!.unfocus();
    errorMessage.value = '';
    if (_formKey.currentState!.validate()) {
      isSubmitting.value = true;
      FocusManager.instance.primaryFocus!.unfocus();
      String? result =
          await loginAccount(email: email.text, password: password.text);
      isSubmitting.value = false;
      if (result != null) {
        errorMessage.value = result;
      } else {
        return true;
      }
    }
    return false;
  }

  Widget _body() {
    return Material(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.20,
                left: 30,
                right: 30,
                bottom: MediaQuery.of(context).viewInsets.bottom + 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    appIcon,
                    height: 100,
                    width: 100,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Login with your credential",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
                              border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 0.5),
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
                        )),
                  ),
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
                            onFieldSubmitted: (value) async {
                              if (!submitting && await login() && mounted) {
                                Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    HomePage.route,
                                    (route) => route.settings.name == '/');
                              }
                            },
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, ResetPasswordPage.route);
                      },
                      child: const Text(
                        "Forget your password?",
                        style: TextStyle(
                          color: hyperlinkColor,
                        ),
                      ),
                    ),
                  ),
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
                                            await login() &&
                                            mounted) {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              HomePage.route,
                                              (route) =>
                                                  route.settings.name == '/');
                                        }
                                      },
                                child: Text(
                                  submitting ? "Loading..." : "Login",
                                ),
                              ))),
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
                const Divider(color: Colors.black, thickness: 0.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Or, ",
                      style: TextStyle(fontSize: 20),
                    ),
                    TextButton(
                        onPressed: () async {
                          FocusManager.instance.primaryFocus!.unfocus();
                          await Navigator.pushNamed(context, SignUpPage.route);
                          _formKey.currentState!.reset();
                        },
                        style: ButtonStyle(
                            textStyle: MaterialStateProperty.resolveWith(
                                (states) =>
                                    states.contains(MaterialState.pressed)
                                        ? const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500)
                                        : const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900)),
                            overlayColor: MaterialStateProperty.all<Color>(
                                Colors.transparent)),
                        child: const Text(
                          "Sign Up Now",
                          style: TextStyle(color: appColor),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }
}
