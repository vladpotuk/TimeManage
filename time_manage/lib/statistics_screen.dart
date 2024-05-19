import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int noteCount = 0;
  int taskCount = 0;
  int reminderCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Статистика'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ваша статистика',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildStatisticItem('Загальна кількість нотаток', noteCount.toString()),
            _buildStatisticItem('Загальна кількість завдань', taskCount.toString()),
            _buildStatisticItem('Загальна кількість нагадувань', reminderCount.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticItem(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Методи для оновлення статистики
  void updateNoteCount(int count) {
    setState(() {
      noteCount = count;
    });
  }

  void updateTaskCount(int count) {
    setState(() {
      taskCount = count;
    });
  }

  void updateReminderCount(int count) {
    setState(() {
      reminderCount = count;
    });
  }
}
