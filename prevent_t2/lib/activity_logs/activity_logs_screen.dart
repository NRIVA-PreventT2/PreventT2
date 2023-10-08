import 'package:flutter/material.dart';
import 'package:prevent_t2/models/activity_log.dart';
import 'package:prevent_t2/activity_logs/activity_detail_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prevent_t2/activity_logs/add_activity_screen.dart';

class ActivityLogsScreen extends StatefulWidget {
  @override
  _ActivityLogsScreenState createState() => _ActivityLogsScreenState();
}

class _ActivityLogsScreenState extends State<ActivityLogsScreen> {
  List<ActivityLog> _activityLogs = [];

  @override
  void initState() {
    super.initState();
    _refreshActivityLogs();
  }

  Future<List<ActivityLog>> _getActivityLogs() async {
    try {
      final response = await Supabase.instance.client
          .from('activity_log')
          .select('*')
          .eq('user', Supabase.instance.client.auth.currentUser!.id)
          .order('created_at', ascending: false);
      final logs =
          (response as List).map((e) => ActivityLog.fromMap(e)).toList();
      return logs;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error fetching activity logs: ${e.toString()}')));
      return [];
    }
  }

  void _refreshActivityLogs() async {
    final logs = await _getActivityLogs();
    setState(() {
      _activityLogs = logs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Activity Logs'),
        ),
        body: ListView.builder(
            itemCount: _activityLogs.length,
            itemBuilder: (context, index) {
              final log = _activityLogs[index];
              return ListTile(
                title: Text('${log.formattedTimestamp} - ${log.activity}'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ActivityDetailScreen(log: log)));
                },
              );
            }),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddActivityScreen()));
              _refreshActivityLogs();
            }));
  }
}
