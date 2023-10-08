class ActivityLog {
  final String? id; // nullable so we can use this when creating new logs
  final String activity;
  final int minutes;
  final Difficulty difficulty;
  final DateTime timestamp;

  ActivityLog({
    this.id,
    required this.activity,
    required this.minutes,
    required this.difficulty,
    required this.timestamp, // use Datetime.now() when creating new logs
  });

  String get formattedTimestamp {
    return '${timestamp.month}/${timestamp.day}/${timestamp.year}';
  }

  ActivityLog.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        activity = map['activity'],
        minutes = map['minutes'],
        difficulty = Difficulty.values.firstWhere(
            (element) => element.toString().split('.')[1] == map['difficulty']),
        timestamp = DateTime.parse(map['created_at']);
}

enum Difficulty {
  easy,
  medium,
  hard,
}
