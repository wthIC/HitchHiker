import 'package:flutter/material.dart';
import 'package:travelproject/components/custom_text_field.dart';
import 'package:travelproject/components/custom_rounded_button.dart';
import 'package:travelproject/auth_service.dart';
import 'package:travelproject/screens/main_screen.dart';
import 'package:travelproject/screens/sign_in_screen.dart';

class SignUpData {
  final TextEditingController emailController;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  bool isDriver;

  SignUpData(
      {String? email,
      String? name,
      String? phone,
      String? password,
      String? confirm,
      this.isDriver = false})
      : emailController = TextEditingController(text: email),
        nameController = TextEditingController(text: name),
        phoneController = TextEditingController(text: phone),
        passwordController = TextEditingController(text: password),
        confirmController = TextEditingController(text: confirm);

  void dispose() {
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmController.dispose();
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late SignUpData formData;
  final authService = AuthService();
  bool pressed = false;

  @override
  void initState() {
    super.initState();
    formData = SignUpData();
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
          child: SingleChildScrollView(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Are you a driver?",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .bodyLarge!
                                .copyWith(color: Colors.black),
                          ),
                          Checkbox(
                            value: formData.isDriver,
                            onChanged: (newValue) {
                              setState(() {
                                formData.isDriver = newValue!;
                              });
                            },
                          ),
                        ],
                      ),
                      if (formData.isDriver)
                        Text(
                          "You need to add your car and personal details before adding routes!",
                          textAlign: TextAlign.left,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .labelMedium!
                              .copyWith(color: Colors.red),
                        ),
                      const SizedBox(height: 16.0),
                      CustomTextField(
                        controller: formData.emailController,
                        label: "Email",
                        hint: "Enter your email",
                      ),
                      const SizedBox(height: 16.0),
                      CustomTextField(
                        controller: formData.nameController,
                        label: "Name",
                        hint: "Enter your full name",
                      ),
                      const SizedBox(height: 16.0),
                      CustomTextField(
                        controller: formData.phoneController,
                        label: "Phone Number",
                        hint: "Enter your phone number",
                      ),
                      const SizedBox(height: 16.0),
                      CustomTextField(
                        controller: formData.passwordController,
                        label: "Password",
                        hint: "Enter your password",
                        obscure: true,
                      ),
                      const SizedBox(height: 16.0),
                      CustomTextField(
                        controller: formData.confirmController,
                        label: "Confirm Password",
                        hint: "Enter your password again",
                        obscure: true,
                      ),
                      const SizedBox(height: 16.0),
                      CustomRoundedButton(
                        text: "Sign Up",
                        onPressed: pressed
                            ? null
                            : () async {
                                pressed = true;
                                setState(() {});
                                await authService
                                    .registerWithEmailAndPassword(
                                  formData.emailController.text,
                                  formData.passwordController.text,
                                  formData.isDriver,
                                  formData.nameController.text,
                                  formData.phoneController.text,
                                )
                                    .then(
                                  (result) {
                                    if (result != null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                    const Text("Already have an account?"),
                    const SizedBox(width: 8.0),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()),
                        );
                      },
                      child: const Text("Sign In"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
