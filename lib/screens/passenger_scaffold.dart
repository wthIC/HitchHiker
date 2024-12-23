import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:travelproject/auth_service.dart';
import 'package:travelproject/components/passenger_route_card.dart';
import 'package:travelproject/components/route_card.dart';
import 'package:travelproject/screens/sign_in_screen.dart';

class PassengerScaffold extends StatefulWidget {
  const PassengerScaffold({
    super.key,
    required this.name,
    required this.routes,
  });

  final String name;
  final List<String> routes;

  @override
  State<PassengerScaffold> createState() => _PassengerScaffoldState();
}

class _PassengerScaffoldState extends State<PassengerScaffold> {
  int tab = 0;

  void onItemTapped(int index) {
    tab = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: tab == 0
          ? AppBar(
              title: Text("Hi, ${widget.name}"),
              automaticallyImplyLeading: false,
            )
          : null,
      body: tab == 0 ? _RoutesBody() : _ProfileBody(name: widget.name),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.drive_eta),
            label: 'Routes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: tab,
        onTap: onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }
}

class _RoutesBody extends StatefulWidget {
  const _RoutesBody({super.key});

  @override
  State<_RoutesBody> createState() => _RoutesBodyState();
}

class _RoutesBodyState extends State<_RoutesBody> {
  final List<String> cities = ['Baku', 'Lankaran', 'Salyan', 'Absheron'];
  String fromCity = "Baku", toCity = "Absheron";
  String time = "00:00";
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('routes').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Error"),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "No routes available.",
                style: Theme.of(context)
                    .primaryTextTheme
                    .bodyLarge!
                    .copyWith(color: Colors.black),
              ),
            ),
          );
        } else {
          List<DocumentSnapshot> documents = snapshot.data!.docs;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("From: "),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: DropdownButtonFormField(
                        value: fromCity,
                        items: cities.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (item) {
                          fromCity = item!;
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("To:     "),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: DropdownButtonFormField(
                        value: toCity,
                        items: cities.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (item) {
                          toCity = item!;
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text("Arrive by: "),
                    InkWell(
                      onTap: () async {
                        TimeOfDay selectedTime = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return TimePickerDialog(
                              initialTime: TimeOfDay(
                                hour: int.parse(time.split(":")[0]),
                                minute: int.parse(time.split(":")[1]),
                              ),
                              cancelText: "Cancel",
                              confirmText: "Confirm",
                            );
                          },
                        );
                        time =
                            "${selectedTime.hour < 10 ? "0" : ""}${selectedTime.hour}:${selectedTime.minute < 10 ? "0" : ""}${selectedTime.minute}";
                        setState(() {});
                      },
                      borderRadius: BorderRadius.circular(16.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            width: 2.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        child: Text(time),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    InkWell(
                      borderRadius: BorderRadius.circular(16.0),
                      onTap: () async {
                        date = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DatePickerDialog(
                              initialDate: date,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2030),
                            );
                          },
                        );
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            width: 2.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        child: Text("${date.year}/${date.month}/${date.day}"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                const Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (int i = 0; i < documents.length; i++)
                          Column(
                            children: [
                              PassengerRouteCard(
                                routeId: documents[i].id,
                                fromCity: fromCity,
                                toCity: toCity,
                                date: date,
                                time: time,
                              ),
                              const SizedBox(height: 24.0),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 64.0,
        left: 16.0,
        right: 16.0,
        bottom: 16.0,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 64.0,
                width: 64.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.0),
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(width: 32.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .displaySmall!
                        .copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                  const Text("Passenger"),
                ],
              )
            ],
          ),
          const SizedBox(height: 16.0),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Personal Details"),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Sign Out"),
            onTap: () async {
              await AuthService().signOut().then((result) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInScreen(),
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
