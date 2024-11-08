import 'package:flutter/material.dart';
// import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  static void openCreateReminder(BuildContext context) {
    // showModalBottomSheet(
    //   context: context,
    //   builder: (context) {
    //     return const CreateMemoryView();
    //   });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: TextButton(onPressed: (){
        _createAlarm(7, 30);
      }, child: const Text("Create alarm")),
    );
  }


  _createAlarm(int hours, int minutes){
    // FlutterAlarmClock.createAlarm(hour: hours, minutes: minutes, title: "Create from promise app"); 
  }
} 