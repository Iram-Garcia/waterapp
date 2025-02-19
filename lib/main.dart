import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ocean Drop',
      debugShowCheckedModeBanner:
          false, // Add this line to remove the debug tag
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006994), // Deep Ocean Blue
          primary: const Color(0xFF006994),
          secondary: const Color(0xFF4FB0C6), // Tropical Water Blue
          background: const Color(0xFFE6F3F8), // Light Ocean Foam
        ),
        useMaterial3: true,
      ),
      home: const WaterTrackerPage(),
    );
  }
}

class WaterTrackerPage extends StatefulWidget {
  const WaterTrackerPage({super.key});

  @override
  State<WaterTrackerPage> createState() => _WaterTrackerPageState();
}

class _WaterTrackerPageState extends State<WaterTrackerPage> {
  double _waterDrank = 0.0; // Start at zero
  double _dailyGoal = 2000.0; // Made mutable for updates
  int _selectedIndex = 0;

  void _addWater(double amount) {
    setState(() {
      _waterDrank += amount;
      if (_waterDrank > _dailyGoal) {
        _waterDrank = _dailyGoal;
      }
    });
  }

  void _resetProgress() {
    setState(() {
      _waterDrank = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F3F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6F3F8),
        elevation: 0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Image.asset(
                'assets/water.png',
                width: 64, // Adjust size as needed
                height: 64, // Adjust size as needed
                color: Color(0xFF4FB0C6),
              ),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color(0xFF006994),
              ),
              child: const Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('General Settings'),
              onTap: () async {
                final result = await Navigator.push<double>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GeneralSettingsPage(
                      initialDailyGoal: _dailyGoal,
                      onResetProgress: _resetProgress,
                    ),
                  ),
                );
                if (result != null) {
                  setState(() {
                    _dailyGoal = result;
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                // Handle the tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () {
                // Handle the tap
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Feedback'),
              onTap: () {
                // Handle the tap
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Move the text to the top left corner
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dive into Hydration',
                          style: TextStyle(
                            color: Colors.blueGrey[600],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Ocean Explorer!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF006994),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                        width: 64), // Add space to align with the menu button
                  ],
                ),
                const SizedBox(height: 24),

                // Progress section
                Row(
                  children: [
                    // Circular progress indicator with wave effect
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Stack(
                        children: [
                          // Add a light blue background to the circle
                          ClipOval(
                            child: Container(
                              color: const Color(0xFF89CFF0).withOpacity(
                                  0.2), // Light blue with transparency
                            ),
                          ),
                          ClipOval(
                            child: WaveWidget(
                              config: CustomConfig(
                                gradients: [
                                  [
                                    const Color(0xFF006994),
                                    const Color(0xFF4FB0C6)
                                  ],
                                  [
                                    const Color(0xFF4FB0C6),
                                    const Color(0xFF89CFF0)
                                  ],
                                ],
                                // Make durations 25% slower
                                durations: [
                                  6250,
                                  5000
                                ], // Changed from [5000, 4000]
                                heightPercentages: [
                                  1.0 - (_waterDrank / _dailyGoal),
                                  1.0 - (_waterDrank / _dailyGoal) + 0.03
                                ],
                                blur: const MaskFilter.blur(BlurStyle.solid, 5),
                                gradientBegin: Alignment.bottomCenter,
                                gradientEnd: Alignment.topCenter,
                              ),
                              waveAmplitude: 20,
                              size:
                                  const Size(double.infinity, double.infinity),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${_waterDrank.toInt()}ml',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Target info (update the hardcoded '2000ml' with dynamic value)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    '${(_waterDrank / _dailyGoal * 100).toInt()}%',
                                    style: TextStyle(
                                      color: Colors.blue[300],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${_waterDrank.toInt()}ml',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Target',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${_dailyGoal.toInt()}ml', // Updated to dynamic daily goal value
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Add water button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _addWater(200.0), // Add 200ml water
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006994),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.water_drop, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Add Ocean Drop (200ml)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'You\'re ${(_waterDrank / _dailyGoal * 100).toInt()}% deep into today\'s ocean goal!\nKeep swimming! 🌊',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueGrey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 24), // Added SizedBox for spacing
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GeneralSettingsPage extends StatefulWidget {
  final double initialDailyGoal;
  final VoidCallback onResetProgress;

  const GeneralSettingsPage({
    super.key,
    required this.initialDailyGoal,
    required this.onResetProgress,
  });

  @override
  State<GeneralSettingsPage> createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  late double _dailyGoal;
  bool _notifications = true;
  String _selectedUnit = 'ml';
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _dailyGoal = widget.initialDailyGoal;
  }

  void _resetProgress() {
    widget.onResetProgress();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('General Settings'),
        backgroundColor: const Color(0xFF006994),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily Water Goal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Slider(
                    value: _dailyGoal,
                    min: 1000,
                    max: 4000,
                    divisions: 30,
                    activeColor: const Color(0xFF006994),
                    label: '${_dailyGoal.round()}$_selectedUnit',
                    onChanged: (value) {
                      setState(() {
                        _dailyGoal = value;
                      });
                    },
                  ),
                  Text('Current goal: ${_dailyGoal.round()}$_selectedUnit'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Push Notifications'),
                  subtitle: const Text('Remind me to drink water'),
                  value: _notifications,
                  activeColor: const Color(0xFF006994),
                  onChanged: (bool value) {
                    setState(() {
                      _notifications = value;
                    });
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text('Measurement Unit'),
                  subtitle: Text('Current: $_selectedUnit'),
                  trailing: DropdownButton<String>(
                    value: _selectedUnit,
                    items: const [
                      DropdownMenuItem(
                          value: 'ml', child: Text('Milliliters (ml)')),
                      DropdownMenuItem(
                          value: 'oz', child: Text('Fluid Ounces (oz)')),
                    ],
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _selectedUnit = value;
                        });
                      }
                    },
                  ),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Toggle dark/light theme'),
                  value: _darkMode,
                  activeColor: const Color(0xFF006994),
                  onChanged: (bool value) {
                    setState(() {
                      _darkMode = value;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.refresh, color: Colors.orange),
                  title: const Text('Reset Today\'s Progress'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Reset Progress'),
                          content: const Text(
                              'Are you sure you want to reset today\'s progress?'),
                          actions: [
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            TextButton(
                              child: const Text('Reset'),
                              onPressed: () {
                                _resetProgress();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text('Clear All Data'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Clear All Data'),
                          content: const Text(
                              'This will permanently delete all your data. Are you sure?'),
                          actions: [
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            TextButton(
                              child: const Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                // Add delete logic here
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Return the new daily goal value to the previous screen
              Navigator.pop(context, _dailyGoal);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006994),
            ),
            child: const Text('Save Settings',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
