import 'package:flutter/material.dart';
import 'package:travelproject/auth_service.dart';
import 'package:travelproject/components/custom_text_field.dart';
import 'package:travelproject/components/custom_rounded_button.dart';
import 'package:travelproject/screens/main_screen.dart';
import 'package:travelproject/screens/sign_in_screen_phone.dart';
import 'package:travelproject/screens/sign_up_screen.dart';

class SignInData {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  bool isDriver;

  SignInData({String? email, String? password, this.isDriver = false})
      : emailController = TextEditingController(text: email),
        passwordController = TextEditingController(text: password);

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    super.key,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late SignInData formData;
  final authService = AuthService();
  bool pressed = false;

  @override
  void initState() {
    super.initState();
    formData = SignInData();
  }

  @override
  void dispose() {
    super.dispose();
    formData.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2.0,
                    )),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextField(
                      controller: formData.emailController,
                      label: "Email",
                      hint: "Enter your email",
                    ),
                    const SizedBox(height: 16.0),
                    CustomTextField(
                      controller: formData.passwordController,
                      label: "Password",
                      hint: "Enter your password",
                      obscure: true,
                    ),
                    const SizedBox(height: 16.0),
                    CustomRoundedButton(
                      text: "Sign In",
                      onPressed: pressed
                          ? null
                          : () async {
                              pressed = true;
                              setState(() {});
                              await authService
                                  .signInWithEmailPassword(
                                formData.emailController.text,
                                formData.passwordController.text,
                              )
                                  .then(
                                (result) {
                                  if (result != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(result),
                                      ),
                                    );
                                    pressed = false;
                                    setState(() {});
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MainScreen()),
                                    );
                                  }
                                },
                              );
                            },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  const SizedBox(width: 8.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()),
                      );
                    },
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreenPhone()),
                      );
                    },
                    child: const Text("Sign In with Phone Number"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
