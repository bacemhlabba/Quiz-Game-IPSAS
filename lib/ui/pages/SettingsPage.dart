import 'package:flutter/material.dart';
import 'package:opentrivia/ui/widgets/notification_service.dart';

class SettingsPage extends StatefulWidget {
  final Function(bool) onSoundChanged;
  final Function(bool) onNotificationChanged;
  final bool isSoundEnabled;
  final bool isNotificationEnabled;

  SettingsPage({
    Key? key,
    required this.onSoundChanged,
    required this.onNotificationChanged,
    required this.isSoundEnabled,
    required this.isNotificationEnabled,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _isSoundEnabled;
  late bool _isNotificationEnabled;

  @override
  void initState() {
    super.initState();
    _isSoundEnabled = widget.isSoundEnabled;
    _isNotificationEnabled = widget.isNotificationEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Section Son
            SwitchListTile(
              title: Text("Enable Sound"),
              value: _isSoundEnabled,
              onChanged: (bool value) {
                setState(() {
                  _isSoundEnabled = value;
                });
                widget.onSoundChanged(value);
              },
            ),
            Divider(),

            // Section Notifications
            SwitchListTile(
              title: Text("Enable Notifications"),
              value: _isNotificationEnabled,
              onChanged: (bool value) {
                setState(() {
                  _isNotificationEnabled = value;
                });
                widget.onNotificationChanged(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
