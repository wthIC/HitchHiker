import 'package:flutter/material.dart';
import 'package:travelproject/components/custom_rounded_button.dart';
import 'package:travelproject/components/custom_text_field.dart';
import 'package:travelproject/screens/sign_in_screen.dart';
import 'package:travelproject/screens/sign_up_screen.dart';

class SignInPhoneData {
  final TextEditingController phoneController;

  SignInPhoneData({String? phone})
      : phoneController = TextEditingController(text: phone);

  void dispose() {
    phoneController.dispose();
  }
}

class SignInScreenPhone extends StatefulWidget {
  const SignInScreenPhone({super.key});

  @override
  State<SignInScreenPhone> createState() => _SignInScreenPhoneState();
}

class _SignInScreenPhoneState extends State<SignInScreenPhone> {
  late SignInPhoneData formData;

  @override
  void initState() {
    super.initState();
    formData = SignInPhoneData();
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
                      controller: formData.phoneController,
                      label: "Phone",
                      hint: "Enter your phone",
                    ),
                    const SizedBox(height: 16.0),
                    CustomRoundedButton(
                      text: "Get Code",
                      onPressed: () async {
                        // await FirebaseAuth.instance.verifyPhoneNumber(
                        //   phoneNumber: formData.phoneController.text,
                        //   verificationCompleted:
                        //       (PhoneAuthCredential credential) async {
                        //     await FirebaseAuth.instance
                        //         .signInWithCredential(credential);
                        //   },
                        //   verificationFailed: (FirebaseAuthException e) {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(
                        //         content: Text(e.code),
                        //       ),
                        //     );
                        //   },
                        //   codeSent:
                        //       (String verificationId, int? resendToken) async {
                        //     print("code sent");
                        //     // Update the UI - wait for the user to enter the SMS code
                        //     // String smsCode = 'xxxx';
                        //     //
                        //     // // Create a PhoneAuthCredential with the code
                        //     // PhoneAuthCredential credential =
                        //     //     PhoneAuthProvider.credential(
                        //     //         verificationId: verificationId,
                        //     //         smsCode: smsCode);
                        //     //
                        //     // // Sign the user in (or link) with the credential
                        //     // await auth.signInWithCredential(credential);
                        //   },
                        //   codeAutoRetrievalTimeout: (String verificationId) {
                        //     // Auto-resolution timed out...
                        //   },
                        // );
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
                            builder: (context) => const SignInScreen()),
                      );
                    },
                    child: const Text("Sign In with Email"),
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
