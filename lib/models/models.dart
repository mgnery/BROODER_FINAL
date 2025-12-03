class NotificationItem {
  final String id;
  final String type; // 'warning', 'success', 'info'
  final String title;
  final String message;
  final String timestamp;
  bool read;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.read = false,
  });
}

class WeekData {
  final String week;
  final double avgTemp;
  final double avgHumidity;
  final double targetTemp;

  WeekData({
    required this.week,
    required this.avgTemp,
    required this.avgHumidity,
    required this.targetTemp,
  });
}

class GuideItem {
  final int week;
  final String temperature;
  final String humidity;
  final String lightHours;
  final List<String> tips;

  GuideItem({
    required this.week,
    required this.temperature,
    required this.humidity,
    required this.lightHours,
    required this.tips,
  });
}