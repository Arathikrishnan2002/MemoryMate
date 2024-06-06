import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderCare extends StatefulWidget {
  @override
  _ReminderCareState createState() => _ReminderCareState();
}

class _ReminderCareState extends State<ReminderCare> {
  late CalendarFormat _calendarFormat;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  TextEditingController _reminderController = TextEditingController();
  List<Reminder> reminders = [];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _initializeLocalNotifications();
    _loadReminders();
  }

  @override
  void dispose() {
    _saveReminders();
    super.dispose();
  }

  void _initializeLocalNotifications() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _loadReminders() async {
    _prefs = await SharedPreferences.getInstance();
    final String? remindersJson = _prefs.getString('reminders');
    if (remindersJson != null) {
      setState(() {
        reminders = Reminder.fromJsonList(remindersJson);
      });
    }
  }

  Future<void> _saveReminders() async {
    final String remindersJson = Reminder.toJsonList(reminders);
    await _prefs.setString('reminders', remindersJson);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: const Color.fromARGB(255, 145, 149, 246),
            ),
            textTheme: TextTheme(
              subtitle1: TextStyle(color: Colors.black),
            ),
            timePickerTheme: TimePickerThemeData(
              hourMinuteTextColor: const Color.fromARGB(255, 145, 149, 246),
              helpTextStyle: TextStyle(color: Colors.black),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });

      _showReminderPopup(context);
    }
  }

  Future<void> _showReminderPopup(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Reminder Text'),
          content: TextField(
            controller: _reminderController,
            decoration: InputDecoration(
              hintText: 'Enter your reminder text...',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _setReminder();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 145, 149, 246),
              ),
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _setReminder() {
    String reminderText = _reminderController.text;
    setState(() {
      reminders.add(Reminder(
        dateTime: _selectedDay,
        timeOfDay: _selectedTime,
        text: reminderText,
        isOn: true,
      ));
    });
    _scheduleNotification(reminderText);
    _saveReminders();
  }

  Future<void> _scheduleNotification(String reminderText) async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 5));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'Channel Name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true,
      enableVibration: true,
      styleInformation: BigTextStyleInformation(''),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.schedule(
      0,
      'Reminder',
      reminderText,
      scheduledNotificationDateTime,
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 145, 149, 246),
        title: Text('Set Reminders Here'),
      ),
      body: Column(
        children: [
          TableCalendar(
            calendarFormat: _calendarFormat,
            focusedDay: _focusedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2050),
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

              _selectTime(context);
            },
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                return Dismissible(
                  key: Key(reminder.dateTime.toString() + reminder.text),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      reminders.removeAt(index);
                      _saveReminders();
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            Switch(
                              value: reminder.isOn,
                              onChanged: (value) {
                                setState(() {
                                  reminder.isOn = value;
                                });
                                _saveReminders();
                              },
                              activeColor: Color.fromARGB(255, 145, 149, 246),
                            ),
                            SizedBox(width: 8),
                            Text(reminder.text),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 56),
                        child: Text(
                          'Date: ${reminder.dateTime.day}/${reminder.dateTime.month}/${reminder.dateTime.year}',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 56),
                        child: Text(
                          'Time: ${reminder.timeOfDay.hour}:${reminder.timeOfDay.minute}',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _selectTime(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 145, 149, 246),
      ),
    );
  }
}

class Reminder {
  final DateTime dateTime;
  final TimeOfDay timeOfDay;
  final String text;
  bool isOn;

  Reminder({
    required this.dateTime,
    required this.timeOfDay,
    required this.text,
    required this.isOn,
  });

  static List<Reminder> fromJsonList(String json) {
    final Iterable<dynamic> decoded = jsonDecode(json);
    return decoded.map((dynamic item) => Reminder.fromJson(item)).toList();
  }

  static String toJsonList(List<Reminder> reminders) {
    List<dynamic> reminderList =
        reminders.map((Reminder reminder) => reminder.toJson()).toList();
    return jsonEncode(reminderList);
  }

  Reminder.fromJson(Map<String, dynamic> json)
      : dateTime = DateTime.parse(json['dateTime']),
        timeOfDay = TimeOfDay(
          hour: int.parse(json['timeOfDay'].split(':')[0]),
          minute: int.parse(json['timeOfDay'].split(':')[1]),
        ),
        text = json['text'],
        isOn = json['isOn'];

  Map<String, dynamic> toJson() => {
        'dateTime': dateTime.toIso8601String(),
        'timeOfDay': '${timeOfDay.hour}:${timeOfDay.minute}',
        'text': text,
        'isOn': isOn,
      };
}
