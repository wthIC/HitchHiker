import 'package:flutter/material.dart';
import 'package:travelproject/auth_service.dart';
import 'package:travelproject/components/route_card.dart';
import 'package:travelproject/screens/add_route_screen.dart';
import 'package:travelproject/screens/sign_in_screen.dart';

class DriverScaffold extends StatefulWidget {
  const DriverScaffold({
    super.key,
    required this.name,
    required this.routes,
  });

  final String name;
  final List<String> routes;

  @override
  State<DriverScaffold> createState() => _DriverScaffoldState();
}

class _DriverScaffoldState extends State<DriverScaffold> {
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
      body: tab == 0
          ? _RoutesBody(routes: widget.routes)
          : _ProfileBody(name: widget.name),
      floatingActionButton: tab == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddRouteScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
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

class _RoutesBody extends StatelessWidget {
  const _RoutesBody({
    super.key,
    required this.routes,
  });

  final List<String> routes;

  @override
  Widget build(BuildContext context) {
    return routes.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "You do not have any routes added yet.",
                style: Theme.of(context)
                    .primaryTextTheme
                    .bodyLarge!
                    .copyWith(color: Colors.black),
              ),
            ),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  for (int i = 0; i < routes.length; i++)
                    Column(
                      children: [
                        RouteCard(
                          routeId: routes[i],
                        ),
                        const SizedBox(height: 24.0),
                      ],
                    ),
                ],
              ),
            ),
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 64.0,
                width: 64.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.0),
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
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
                  const Text("Driver"),
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
            leading: const Icon(Icons.drive_eta_outlined),
            title: const Text("Car Details"),
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
