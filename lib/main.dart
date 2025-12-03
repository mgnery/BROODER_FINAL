import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'theme/app_colors.dart';
import 'utils/pdf_generator.dart';
import 'models/models.dart';
import 'views/monitoring_view.dart';
import 'views/dashboard_view.dart';
import 'views/notifications_view.dart';
import 'views/guide_view.dart';

void main() {
  runApp(const BrooderApp());
}

class BrooderApp extends StatelessWidget {
  const BrooderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brooder System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        primaryColor: AppColors.pastelYellow,
        scaffoldBackgroundColor: AppColors.warmGray,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Navigation State
  int _currentIndex = 0;

  // Sensor State
  String _dateStarted = 'December 1, 2025';
  double _temperature = 32.0;
  double _targetTemperature = 30.0;
  double _humidity = 65.0;
  String _lightStatus = 'on'; // 'on' | 'off'
  String _lightMode = 'manual'; // 'manual' | 'automatic'

  // Data
  List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      type: 'warning',
      title: 'High Temperature Alert',
      message: 'Temperature has exceeded target by 3°C. Current: 33°C, Target: 30°C',
      timestamp: '2 hours ago',
    ),
    NotificationItem(
      id: '2',
      type: 'info',
      title: 'Light Mode Changed',
      message: 'Light control switched to automatic mode',
      timestamp: '5 hours ago',
      read: true,
    ),
  ];

  final List<WeekData> _weeklyData = [
    WeekData(week: 'Week 1', avgTemp: 29, avgHumidity: 62, targetTemp: 30),
    WeekData(week: 'Week 2', avgTemp: 30, avgHumidity: 64, targetTemp: 30),
    WeekData(week: 'Week 3', avgTemp: 31, avgHumidity: 63, targetTemp: 30),
    WeekData(week: 'Week 4', avgTemp: 30, avgHumidity: 65, targetTemp: 30),
    WeekData(week: 'Week 5', avgTemp: 32, avgHumidity: 66, targetTemp: 30),
  ];

  Timer? _simulationTimer;

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }

  void _startSimulation() {
    _simulationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;

      setState(() {
        // Random fluctuations
        double tempChange = (Random().nextDouble() - 0.5) * 2;
        double newTemp = (_temperature + tempChange).clamp(20.0, 40.0);
        _temperature = double.parse(newTemp.toStringAsFixed(1));

        double humChange = (Random().nextDouble() - 0.5) * 3;
        double newHumidity = (_humidity + humChange).clamp(0.0, 100.0);
        _humidity = double.parse(newHumidity.toStringAsFixed(0));

        _checkThresholds();
        _checkAutomaticLight();
      });
    });
  }

  void _checkThresholds() {
    // Temperature Check
    if ((_temperature - _targetTemperature).abs() > 3) {
      bool exists = _notifications.any((n) => n.title == 'Temperature Threshold Alert' && !n.read);
      if (!exists) {
        String status = _temperature > _targetTemperature ? 'above' : 'below';
        double diff = (_temperature - _targetTemperature).abs();
        
        _notifications.insert(0, NotificationItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'warning',
          title: 'Temperature Threshold Alert',
          message: 'Temperature is $status target by ${diff.toStringAsFixed(1)}°C',
          timestamp: 'Just now',
        ));
      }
    }

    // Humidity Check
    if (_humidity > 75 || _humidity < 45) {
      bool exists = _notifications.any((n) => n.title == 'Humidity Threshold Alert' && !n.read);
      if (!exists) {
        String status = _humidity > 75 ? 'too high' : 'too low';
        _notifications.insert(0, NotificationItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'warning',
          title: 'Humidity Threshold Alert',
          message: 'Humidity is $status at ${_humidity.toInt()}%',
          timestamp: 'Just now',
        ));
      }
    }
  }

  void _checkAutomaticLight() {
    if (_lightMode == 'automatic') {
      int hour = DateTime.now().hour;
      bool shouldBeOn = hour >= 6 && hour < 20;
      _lightStatus = shouldBeOn ? 'on' : 'off';
    }
  }

  void _handleLightToggle() {
    if (_lightMode == 'manual') {
      setState(() {
        _lightStatus = _lightStatus == 'on' ? 'off' : 'on';
      });
    }
  }

  void _handleLightModeToggle() {
    setState(() {
      String newMode = _lightMode == 'manual' ? 'automatic' : 'manual';
      _lightMode = newMode;

      _notifications.insert(0, NotificationItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'info',
        title: 'Light Mode Changed',
        message: 'Light control switched to $newMode mode',
        timestamp: 'Just now',
      ));
    });
  }

  // --- New Brooder Logic ---

  Future<void> _handleNewBrooder() async {
    // Capture state before async gap
    final currentHistory = List<WeekData>.from(_weeklyData);
    final currentStartDate = _dateStarted;
    
    // Parse start date safely
    String durationText = '0 days';
    try {
      final start = DateFormat('MMMM d, y').parse(_dateStarted);
      final days = DateTime.now().difference(start).inDays;
      durationText = '$days days';
    } catch (e) {
      debugPrint('Error parsing date: $e');
    }

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('New Brooder Session'),
        content: const Text(
          'You are about to start a new brooder session.\n\n'
          'Would you like to save a PDF report of the current history before resetting?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _resetData();
            },
            child: const Text('Reset Only'),
          ),
          FilledButton.icon(
            icon: const Icon(Icons.save_alt, size: 16),
            label: const Text('Save Report & Reset'),
            style: FilledButton.styleFrom(backgroundColor: AppColors.darkText),
            onPressed: () async {
              Navigator.pop(ctx); // Close dialog
              
              // Generate PDF
              await PdfGenerator.generateAndShowReport(
                history: currentHistory,
                dateStarted: currentStartDate,
                sessionDuration: durationText,
              );

              // Check if widget is still in tree before using context/setState
              // The widget might have been disposed if the user navigated away quickly.
              if (!mounted) return;

              // Reset Data
              _resetData();
            },
          ),
        ],
      ),
    );
  }

  void _resetData() {
    setState(() {
      _dateStarted = DateFormat('MMMM d, y').format(DateTime.now());
      _temperature = 25.0;
      _targetTemperature = 30.0;
      _humidity = 60.0;
      _lightStatus = 'off';
      _lightMode = 'manual';
      
      _notifications = [
        NotificationItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'success',
          title: 'New Brooder Started',
          message: 'Monitoring has been reset for a new brooder session',
          timestamp: 'Just now',
        )
      ];
      
      _weeklyData.clear(); // Clear the data after saving the report
      _currentIndex = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Brooder session reset successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    int unreadCount = _notifications.where((n) => !n.read).length;

    Widget currentView;
    switch (_currentIndex) {
      case 0:
        currentView = MonitoringView(
          dateStarted: _dateStarted,
          temperature: _temperature,
          targetTemperature: _targetTemperature,
          humidity: _humidity,
          lightStatus: _lightStatus,
          lightMode: _lightMode,
          onTemperatureChange: (val) => setState(() => _targetTemperature = val),
          onLightToggle: _handleLightToggle,
          onLightModeToggle: _handleLightModeToggle,
        );
        break;
      case 1:
        currentView = DashboardView(data: _weeklyData);
        break;
      case 2:
        currentView = NotificationsView(
          notifications: _notifications,
          onDismiss: (id) => setState(() => _notifications.removeWhere((n) => n.id == id)),
          onMarkAsRead: (id) => setState(() {
            final index = _notifications.indexWhere((n) => n.id == id);
            if (index != -1) _notifications[index].read = true;
          }),
        );
        break;
      case 3:
        currentView = const GuideView();
        break;
      default:
        currentView = Container();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pastelYellow,
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Brooder Monitor',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Text(
              'Smart Poultry Care',
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.grey),
                onPressed: _handleNewBrooder,
                tooltip: 'New Brooder',
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: currentView,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[200]!, width: 2)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey[400],
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home, color: Colors.black),
              label: 'Monitor',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.notifications_outlined),
                  if (unreadCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: AppColors.danger,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                        child: Text(
                          '$unreadCount',
                          style: const TextStyle(color: Colors.white, fontSize: 8),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              activeIcon: Stack(
                children: [
                  const Icon(Icons.notifications, color: Colors.black),
                  if (unreadCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: AppColors.danger,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                        child: Text(
                          '$unreadCount',
                          style: const TextStyle(color: Colors.white, fontSize: 8),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              // The 'Alerts' label is for the notifications view.
              label: 'Alerts',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book, color: Colors.black),
              label: 'Guide',
            ),
          ],
        ),
      ),
    );
  }
}