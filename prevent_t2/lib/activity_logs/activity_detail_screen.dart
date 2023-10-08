import 'package:flutter/material.dart';
import 'package:prevent_t2/models/activity_log.dart';

class ActivityDetailScreen extends StatelessWidget {
  final ActivityLog log;

  const ActivityDetailScreen({required this.log});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Activity Details')),
        body: Padding(
            padding: EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Activity: ${log.activity}'),
              Text('Timestamp: ${log.formattedTimestamp}'),
              Text('Minutes: ${log.minutes}'),
              Text('Difficulty: ${log.difficulty}'),
            ])));
  }
}
