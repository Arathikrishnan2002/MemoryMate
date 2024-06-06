import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ReminderPage extends StatefulWidget {
  String? get patientReferralId => null;

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _remindersCollection;
  late User _user;
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
    _remindersCollection = FirebaseFirestore.instance.collection('userreminder');
  
    _user = FirebaseAuth.instance.currentUser!;
    _calendarFormat = CalendarFormat.month;
    _initializeLocalNotifications();
    _loadReminders(_user.uid);
  }

  @override
  void dispose() {
    _saveReminders(_user.uid);
    super.dispose();
  }

  void _initializeLocalNotifications() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

 Future<void> _loadReminders(String userUID) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _remindersCollection.doc(userUID).get() as DocumentSnapshot<Map<String, dynamic>>;

    if (snapshot.exists) {
      List<Map<String, dynamic>> reminderDataList =
          List<Map<String, dynamic>>.from(snapshot.data()!['reminders']);

      setState(() {
        reminders = reminderDataList
            .map((reminderData) => Reminder.fromJson(reminderData))
            .toList();
      });
    } else {
      print('No reminders found for user $userUID');
    }
  } catch (e) {
    print('Error loading reminders: $e');
  }
}


  Future<void> _saveReminders(String userUID) async {
    try {
      List<Map<String, dynamic>> reminderDataList = reminders.map((reminder) {
        return reminder.toJson();
      }).toList();

      await _remindersCollection.doc(userUID).set({
        'reminders': reminderDataList,
      });
    } catch (e) {
      print('Error saving reminders: $e');
    }
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
               focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 145, 149, 246)),
    ),
            ),
            cursorColor: Color.fromARGB(255, 145, 149, 246),
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
    _saveReminders(_user.uid);
  }

  Future<void> _scheduleNotification(String reminderText) async {
    var scheduledNotificationDateTime = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

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
        title: Text('Reminder: Beacon of Productivity'),
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
                return Dismissible(
                  key: Key(reminders[index].dateTime.toString()),
                  onDismissed: (direction) {
                    setState(() {
                      reminders.removeAt(index);
                    });
                    _saveReminders(_user.uid);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Reminder deleted")),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: ListTile(
                    title: Row(
                      children: [
                        Switch(
                          value: reminders[index].isOn,
                          onChanged: (value) {
                            setState(() {
                              reminders[index].isOn = value;
                            });
                            _saveReminders(_user.uid);
                          },
                          activeColor: Color.fromARGB(255, 145, 149, 246),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reminders[index].text,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Date: ${DateFormat('yyyy-MM-dd').format(reminders[index].dateTime)}',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                'Time: ${reminders[index].timeOfDay.format(context)}',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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