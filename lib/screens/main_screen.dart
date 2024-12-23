import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travelproject/firestore_service.dart';
import 'package:travelproject/screens/driver_scaffold.dart';
import 'package:travelproject/screens/passenger_scaffold.dart';
import 'package:travelproject/screens/sign_in_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String name = "none";
    bool isDriver = false;
    String email = "none";
    String phone = "none";
    List<dynamic> routes = [];

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return Scaffold(
              body: Center(
                child: Column(
                  children: [
                    const Text("An error has occurred!"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()),
                        );
                      },
                      child: const Text("Sign Out"),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return FutureBuilder(
              future: FirestoreService().getUserData(user.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Scaffold(
                      body: Center(child: Text("Has Error")),
                    ),
                  );
                } else if (snapshot.hasData) {
                  name = snapshot.data!['name'];
                  email = snapshot.data!['email'];
                  phone = snapshot.data!['phone'];
                  isDriver = snapshot.data!['isDriver'];
                  routes = snapshot.data!['routes'] as List<dynamic>;
                  if (isDriver) {
                    return DriverScaffold(
                      name: name,
                      routes: routes.cast<String>(),
                    );
                  } else {
                    return PassengerScaffold(
                      name: name,
                      routes: routes.cast<String>(),
                    );
                  }
                } else {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
