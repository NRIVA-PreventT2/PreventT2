import 'package:flutter/material.dart';
import 'package:prevent_t2/models/lifestyle_coach_log.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddLifestyleCoachLogScreen extends StatefulWidget {
  @override
  _AddLifestyleCoachLogScreenState createState() =>
      _AddLifestyleCoachLogScreenState();
}

class _AddLifestyleCoachLogScreenState
    extends State<AddLifestyleCoachLogScreen> {
  TextEditingController _minutesController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  Attendance selectedAttendance = Attendance.yes;

  _addLog() async {
    // logic for uploading log to Supabase
    try {
      await Supabase.instance.client.from('lifestyle_coach_log').insert({
        'user': Supabase.instance.client.auth.currentUser!.id,
        'minutes': int.parse(_minutesController.text),
        'current_weight': int.parse(_weightController.text),
        'attendance': selectedAttendance.toString().split('.')[1],
      }).select();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding log: ${e.toString()}')));
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Add Lifestyle Coach Log')),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              TextField(
                controller: _minutesController,
                decoration: const InputDecoration(
                    labelText: 'Minutes Exercised This Week'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Current Weight'),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<Attendance>(
                  value: selectedAttendance,
                  onChanged: (Attendance? newValue) {
                    setState(() {
                      selectedAttendance = newValue!;
                    });
                  },
                  items: Attendance.values.map<DropdownMenuItem<Attendance>>(
                      (Attendance attendance) {
                    return DropdownMenuItem<Attendance>(
                      value: attendance,
                      child: Text(attendance.toString().split('.')[1]),
                    );
                  }).toList()),
              ElevatedButton(
                onPressed: _addLog,
                child: const Text('Add Lifestyle Coach Log'),
              ),
            ])));
  }
}
