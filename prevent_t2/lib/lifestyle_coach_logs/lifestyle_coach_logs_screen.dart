import 'package:flutter/material.dart';
import 'package:prevent_t2/lifestyle_coach_logs/add_lifestyle_coach_log_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prevent_t2/models/lifestyle_coach_log.dart';
import 'package:prevent_t2/lifestyle_coach_logs/lifestyle_coach_detail_screen.dart';

class LifestyleCoachLogsScreen extends StatefulWidget {
  @override
  _LifestyleCoachLogsScreenState createState() =>
      _LifestyleCoachLogsScreenState();
}

class _LifestyleCoachLogsScreenState extends State<LifestyleCoachLogsScreen> {
  List<LifestyleCoachLog> _logs = [];

  @override
  void initState() {
    super.initState();
    _refreshLogs();
  }

  Future<List<LifestyleCoachLog>> _getLogs() async {
    try {
      final response = await Supabase.instance.client
          .from('lifestyle_coach_log')
          .select('*')
          .eq('user', Supabase.instance.client.auth.currentUser!.id)
          .order('created_at', ascending: false);
      final logs =
          (response as List).map((e) => LifestyleCoachLog.fromMap(e)).toList();
      return logs;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Error fetching lifestyle coach logs: ${e.toString()}')));
      return [];
    }
  }

  void _refreshLogs() async {
    final logs = await _getLogs();
    setState(() {
      _logs = logs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lifestyle Coach Logs'),
      ),
      body: ListView.builder(
          itemCount: _logs.length,
          itemBuilder: (context, index) {
            final log = _logs[index];
            return ListTile(
              title: Text(
                  '${log.formattedTimestamp} - ${log.formattedAttendance}'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LifestyleCoachDetailScreen(log: log)));
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddLifestyleCoachLogScreen()));
          _refreshLogs();
        },
      ),
    );
  }
}
