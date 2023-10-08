class LifestyleCoachLog {
  final String? id; // nullable so we can use this when creating new logs
  final int minutes;
  final int currentWeight;
  final DateTime timestamp;
  final Attendance attendance;

  LifestyleCoachLog({
    this.id,
    required this.minutes,
    required this.currentWeight,
    required this.attendance,
    required this.timestamp, // use Datetime.now() when creating new logs
  });

  String get formattedTimestamp {
    return '${timestamp.month}/${timestamp.day}/${timestamp.year}';
  }

  String get formattedAttendance {
    return attendance.toString().split('.')[1];
  }

  LifestyleCoachLog.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        minutes = map['minutes'],
        currentWeight = map['current_weight'],
        attendance = Attendance.values.firstWhere(
            (element) => element.toString().split('.')[1] == map['attendance']),
        timestamp = DateTime.parse(map['created_at']);
}

enum Attendance { yes, no, online }
