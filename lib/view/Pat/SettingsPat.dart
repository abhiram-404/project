import 'package:flutter/material.dart';

import '../Doc/dochomepg.dart';
import 'PatHomepg.dart';


class SettingsPagePat extends StatefulWidget {
  @override
  _SettingsPagePatState createState() => _SettingsPagePatState();
}

class _SettingsPagePatState extends State<SettingsPagePat> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.teal[50],
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PatHomePg(/*userDetails: {}*/), // Replace with your target page
                  ),
                );
              },
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal[800]!, Colors.teal[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            centerTitle: true,
            title: Text('Settings'),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              SwitchListTile(
                title: Text(
                  'Notifications',
                  style: TextStyle(fontSize: 16, color: Colors.teal[800]),
                ),
                subtitle: Text(
                  _notificationsEnabled
                      ? 'Notifications are enabled'
                      : 'Notifications are disabled',
                  style: TextStyle(color: Colors.teal[600]),
                ),
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                secondary: Icon(
                  _notificationsEnabled
                      ? Icons.notifications_active
                      : Icons.notifications_off,
                  color: _notificationsEnabled ? Colors.teal : Colors.grey,
                ),
              ),
              Divider(color: Colors.teal),

            ],
          ),
        ),
      ),
    );
  }
}