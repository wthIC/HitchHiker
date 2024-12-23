import 'package:flutter/material.dart';
import 'package:travelproject/firestore_service.dart';

class PassengerRouteCard extends StatefulWidget {
  const PassengerRouteCard({
    super.key,
    required this.routeId,
    required this.fromCity,
    required this.toCity,
    required this.date,
    required this.time,
  });

  final String routeId;
  final String fromCity;
  final String toCity;
  final DateTime date;
  final String time;

  @override
  State<PassengerRouteCard> createState() => _PassengerRouteCardState();
}

class _PassengerRouteCardState extends State<PassengerRouteCard> {
  bool expanded = false;
  String phone = "Error";
  DateTime date = DateTime.now();
  List<dynamic> cities = [];
  List<dynamic> times = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirestoreService().getRouteData(widget.routeId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Has Error"));
        } else if (snapshot.hasData) {
          phone = snapshot.data!['phone'];
          date = snapshot.data!['date'].toDate();
          cities = snapshot.data!['selectedValues'];
          times = snapshot.data!['selectedTimes'];
          int fromIdx = cities.indexOf(widget.fromCity);
          int toIdx = cities.indexOf(widget.toCity);
          bool show = true;

          if (fromIdx == -1 || toIdx == -1) {
            show = false;
          } else if (fromIdx > toIdx) {
            show = false;
          } else if (date.year != widget.date.year ||
              date.month != widget.date.month ||
              date.day != widget.date.day) {
            show = false;
          } else {
            int hour = int.parse(widget.time.split(':')[0]);
            int minute = int.parse(widget.time.split(':')[1]);
            int hourCity = int.parse(times[toIdx].split(':')[0]);
            int minuteCity = int.parse(times[toIdx].split(':')[1]);
            if (hourCity > hour || (hourCity == hour && minuteCity > minute)) {
              show = false;
            }
          }
          return show
              ? Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      width: 1.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Baku",
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Text(
                            cities[cities.length - 1],
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Date: ${date.year}/${date.month}/${date.day}",
                      ),
                      const SizedBox(height: 8.0),
                      Text("Start Time: ${times[0]}"),
                      const SizedBox(height: 8.0),
                      Text("End Time: ${times[times.length - 1]}"),
                      const SizedBox(height: 8.0),
                      Text("Includes: ${cities.join(", ")}"),
                      const SizedBox(height: 8.0),
                      Text("Phone Number: $phone"),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              expanded = !expanded;
                              setState(() {});
                            },
                            child: Row(
                              children: [
                                Text(expanded ? "Collapse" : "Details"),
                                const SizedBox(width: 8.0),
                                Icon(expanded
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_left),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      if (expanded)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < cities.length; i++)
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(cities[i]),
                                      const Expanded(child: SizedBox()),
                                      Text(times[i]),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                ],
                              )
                          ],
                        ),
                      if (expanded) const SizedBox(height: 8.0),
                    ],
                  ),
                )
              : SizedBox.shrink();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
