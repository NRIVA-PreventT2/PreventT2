import 'package:flutter/material.dart';
import 'package:prevent_t2/activity_logs/activity_detail_screen.dart';
import 'package:prevent_t2/lifestyle_coach_logs/lifestyle_coach_detail_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prevent_t2/activity_logs/activity_logs_screen.dart';
import 'package:prevent_t2/activity_logs/add_activity_screen.dart';
import 'package:prevent_t2/lifestyle_coach_logs/add_lifestyle_coach_log_screen.dart';
import 'package:prevent_t2/lifestyle_coach_logs/lifestyle_coach_logs_screen.dart';
import 'package:prevent_t2/models/activity_log.dart';
import 'package:prevent_t2/models/lifestyle_coach_log.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ActivityLog> _recentActivityLogs = [];
  List<LifestyleCoachLog> _recentLifestyleCoachLogs = [];

  /**
   * Initializes the state of the home screen.
   * Should fetch most recent activity logs and lifestyle coach logs on load
   */
  @override
  void initState() {
    super.initState();
    _getRecentActivityLogs();
    _getRecentLifestyleCoachLogs();
  }

  /**
   * Fetches the 3 most recent activity logs for a user.
   */
  Future<void> _getRecentActivityLogs() async {
    try {
      final response = await Supabase.instance.client
          .from('activity_log')
          .select('*')
          .eq('user', Supabase.instance.client.auth.currentUser!.id)
          .order('created_at', ascending: false)
          .limit(3);
      final logs =
          (response as List).map((e) => ActivityLog.fromMap(e)).toList();
      mounted
          ? (() {
              _recentActivityLogs = logs;
            })
          : null;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Error fetching recent activity logs: ${e.toString()}')));
      return;
    }
  }

  /**
   * Fetches the 3 most recent lifestyle coaching logs for a user.
   */
  Future<void> _getRecentLifestyleCoachLogs() async {
    try {
      final response = await Supabase.instance.client
          .from('lifestyle_coach_log')
          .select('*')
          .eq('user', Supabase.instance.client.auth.currentUser!.id)
          .order('created_at', ascending: false)
          .limit(3);
      final logs =
          (response as List).map((e) => LifestyleCoachLog.fromMap(e)).toList();
      print(logs);
      mounted
          ? setState(() {
              _recentLifestyleCoachLogs = logs;
            })
          : null;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Error fetching recent lifestyle coach logs: ${e.toString()}')));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              'Welcome, ${Supabase.instance.client.auth.currentUser!.email}!'),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
                Navigator.of(context).pushReplacementNamed('/');
              },
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Divider(),

              // activity logs section
              Row(children: [
                const Text('Activity Logs'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.view_list_outlined),
                  onPressed: () {
                    Navigator.pushNamed(context, '/activity_logs');
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ActivityLogsScreen()));
                  },
                  tooltip: 'View Activity Logs',
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddActivityScreen()));
                  },
                  tooltip: 'Add Activity Log',
                )
              ]),
              ListView.builder(
                // repeating this a lot, templatize?
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _recentActivityLogs.length,
                itemBuilder: (context, index) {
                  final log = _recentActivityLogs[index];
                  return ListTile(
                      title:
                          Text('${log.formattedTimestamp} - ${log.activity}'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ActivityDetailScreen(log: log)));
                      });
                },
              ),

              // lifestyle coach logs section
              Row(
                children: [
                  const Text('Lifestyle Coach Logs'),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.view_list_outlined),
                    onPressed: () {
                      Navigator.pushNamed(context, '/lifestyle_coach_logs');
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             LifestyleCoachLogsScreen()));
                    },
                    tooltip: 'View Lifestyle Coach Logs',
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddLifestyleCoachLogScreen()));
                    },
                    tooltip: 'Add Lifestyle Coach Log',
                  )
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _recentLifestyleCoachLogs.length,
                itemBuilder: (context, index) {
                  final log = _recentLifestyleCoachLogs[index];
                  return ListTile(
                      title: Text(
                          '${log.formattedTimestamp} - ${log.formattedAttendance}'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LifestyleCoachDetailScreen(log: log)));
                      });
                },
              ),
            ])));
  }
}
