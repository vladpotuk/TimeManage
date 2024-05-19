import 'package:flutter/material.dart';

class RemindersScreen extends StatefulWidget {
  @override
  _RemindersScreenState createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  List<Reminder> scheduledNotifications = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Нагадування'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final selectedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (selectedTime != null) {
              _promptForMessage(selectedTime);
            }
          },
          child: Text('Запланувати нагадування'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showScheduledNotifications();
        },
        child: Icon(Icons.notifications),
      ),
    );
  }

  Future<void> _promptForMessage(TimeOfDay selectedTime) async {
    final messageController = TextEditingController();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Повідомлення'),
          content: TextField(
            controller: messageController,
            decoration: InputDecoration(labelText: 'Введіть повідомлення'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Скасувати'),
            ),
            TextButton(
              onPressed: () {
                final message = messageController.text;
                if (message.isNotEmpty) {
                  _scheduleNotification(selectedTime, message);
                  Navigator.of(context).pop();
                }
              },
              child: Text('ОК'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _scheduleNotification(TimeOfDay selectedTime, String message) async {
    final now = DateTime.now();
    final scheduledDateTime = DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
    final durationUntilNotification = scheduledDateTime.difference(now);
    await Future.delayed(durationUntilNotification, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Нагадування'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Закрити'),
              ),
            ],
          );
        },
      );
    });
  }

  void _showScheduledNotifications() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Заплановані нагадування'),
          content: ListView.builder(
            itemCount: scheduledNotifications.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  '${scheduledNotifications[index].time.toString()} - ${scheduledNotifications[index].message}',
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Закрити'),
            ),
          ],
        );
      },
    );
  }
}

class Reminder {
  final DateTime time;
  final String message;

  Reminder({required this.time, required this.message});
}
