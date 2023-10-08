import 'package:flutter/material.dart';
import 'package:prevent_t2/models/activity_log.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddActivityScreen extends StatefulWidget {
  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  TextEditingController _activityController = TextEditingController();
  TextEditingController _minutesController = TextEditingController();
  Difficulty selectedDifficulty = Difficulty.easy;

  _addActivity() async {
    // logic for uploading activity log to Supabase
    try {
      final newActivity = ActivityLog(
        activity: _activityController.text,
        minutes: int.parse(_minutesController.text),
        difficulty: selectedDifficulty,
        timestamp: DateTime.now(),
      );

      final response =
          await Supabase.instance.client.from('activity_log').insert({
        'minutes': newActivity.minutes,
        'activity': newActivity.activity,
        'difficulty': newActivity.difficulty.toString().split('.')[1],
        'user': Supabase.instance.client.auth.currentUser!.id,
      }).select();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding activity: ${e.toString()}')));
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add Activity')),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _activityController,
                decoration: InputDecoration(labelText: 'Activity'),
              ),
              TextField(
                controller: _minutesController,
                decoration: InputDecoration(labelText: 'Minutes'),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<Difficulty>(
                value: selectedDifficulty,
                onChanged: (Difficulty? newValue) {
                  setState(() {
                    selectedDifficulty = newValue!;
                  });
                },
                items: Difficulty.values
                    .map<DropdownMenuItem<Difficulty>>((Difficulty difficulty) {
                  return DropdownMenuItem<Difficulty>(
                    value: difficulty,
                    child: Text(difficulty.toString().split('.')[1]),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: _addActivity,
                child: const Text('Add Activity'),
              ),
            ],
          ),
        ));
  }
}
