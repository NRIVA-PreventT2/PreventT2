import 'package:flutter/material.dart';
import 'package:prevent_t2/models/lifestyle_coach_log.dart';

class LifestyleCoachDetailScreen extends StatelessWidget {
  final LifestyleCoachLog log;

  const LifestyleCoachDetailScreen({required this.log});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Lifestyle Coach Log Details')),
        body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${log.formattedTimestamp}'),
                Text('Attendance: ${log.formattedAttendance}'),
                Text('Current Weight: ${log.currentWeight}'),
                Text('Minutes Exercised: ${log.minutes}')
              ],
            )));
  }
}
