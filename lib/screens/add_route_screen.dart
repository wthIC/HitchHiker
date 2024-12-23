import 'package:flutter/material.dart';
import 'package:travelproject/components/custom_rounded_button.dart';
import 'package:travelproject/firestore_service.dart';
import 'package:travelproject/screens/main_screen.dart';

class AddRouteScreen extends StatefulWidget {
  const AddRouteScreen({super.key});

  @override
  State<AddRouteScreen> createState() => _AddRouteScreenState();
}

class _AddRouteScreenState extends State<AddRouteScreen> {
  final List<String> cities = ['Baku', 'Lankaran', 'Salyan', 'Absheron'];

  List<String> selectedValues = [
    'Baku',
  ];

  List<String> selectedTimes = [
    "00:00",
  ];

  DateTime routeDate = DateTime.now();
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> routeCities = [];
    for (int i = 0; i < selectedValues.length; i++) {
      routeCities.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: DropdownButtonFormField(
              value: selectedValues[i],
              items: cities.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (item) {
                selectedValues[i] = item ?? "Baku";
                setState(() {});
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          InkWell(
            onTap: () async {
              TimeOfDay selectedTime = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return TimePickerDialog(
                    initialTime: TimeOfDay(
                      hour: int.parse(selectedTimes[i].split(":")[0]),
                      minute: int.parse(selectedTimes[i].split(":")[1]),
                    ),
                    cancelText: "Cancel",
                    confirmText: "Confirm",
                  );
                },
              );
              selectedTimes[i] =
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
              child: Text(selectedTimes[i]),
            ),
          ),
          IconButton(
            onPressed: () {
              if (routeCities.length == 2) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("You cannot have an empty route!"),
                  ),
                );
              } else {
                selectedValues.removeAt(i ~/ 2);
                selectedTimes.removeAt(i ~/ 2);
                setState(() {});
              }
            },
            icon: const Icon(Icons.remove_circle),
          ),
        ],
      ));
      routeCities.add(const SizedBox(height: 16.0));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MainScreen(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Add route details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(16.0),
                  onTap: () async {
                    routeDate = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DatePickerDialog(
                          initialDate: routeDate,
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
                    child: Text(
                        "${routeDate.year}/${routeDate.month}/${routeDate.day}"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: routeCities,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                selectedValues.add("Baku");
                selectedTimes.add("00:00");
                setState(() {});
              },
              child: const Text("Add city"),
            ),
            CustomRoundedButton(
              text: "Add Route",
              onPressed: pressed
                  ? null
                  : () async {
                      if (routeCities.length <= 2) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "You need to have at least 2 cities in your route",
                            ),
                          ),
                        );
                      } else {
                        pressed = true;
                        setState(() {});
                        await FirestoreService()
                            .addRoute(
                          routeDate,
                          selectedValues,
                          selectedTimes,
                        )
                            .then(
                          (result) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result)),
                            );
                            pressed = false;
                            setState(() {});

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainScreen(),
                              ),
                            );
                          },
                        );
                      }
                    },
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
