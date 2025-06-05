import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> defaultOptions = [
    'Discharge Line Temp',
    'Suction Line Temp',
    'Return Air Temp',
    'Supply Air Temp',
    'Outdoor Temp',
    'Compressor Temp',
    'Ambient Temp',
    'Water Inlet Temp',
    'Water Outlet Temp',
    'Room Temp',
  ];
  final int sensorCount = 4;
  final Map<int, List<String>> dropdownOptions = {};
  final Map<int, String?> selectedValues = {};
  final Map<int, TextEditingController> controllers = {};
  final Map<int, bool> sensorStatus = {};
  final Map<int, double> sensorTemps = {1: 24, 2: 22, 3: 26, 4: 23};

  @override
  void initState() {
    super.initState();
    for (int i = 1; i <= sensorCount; i++) {
      dropdownOptions[i] = List.from(defaultOptions);
      selectedValues[i] = defaultOptions.first;
      controllers[i] = TextEditingController();
      sensorStatus[i] = true;
    }
  }

  Widget buildSensorCard(int sensorId) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Sensor $sensorId',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${sensorTemps[sensorId]!.toInt()}°C',
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                ),
                Switch(
                  value: sensorStatus[sensorId]!,
                  onChanged: (val) {
                    setState(() {
                      sensorStatus[sensorId] = val;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedValues[sensorId],
              items:
                  dropdownOptions[sensorId]!
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (val) {
                setState(() {
                  selectedValues[sensorId] = val;
                });
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controllers[sensorId],
                    decoration: InputDecoration(hintText: 'Add new option...'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newOption = controllers[sensorId]!.text.trim();
                    if (newOption.isNotEmpty &&
                        !dropdownOptions[sensorId]!.contains(newOption)) {
                      setState(() {
                        dropdownOptions[sensorId]!.add(newOption);
                        controllers[sensorId]!.clear();
                      });
                    }
                  },
                  child: Text('+ Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Configuration Panel'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              'Select and configure your sensors. All selections are saved automatically.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 1,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: List.generate(
                  sensorCount,
                  (i) => buildSensorCard(i + 1),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              ),
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Configuration saved')));
              },
              child: Text('Save Configuration'),
            ),
          ],
        ),
      ),
    );
  }
}
