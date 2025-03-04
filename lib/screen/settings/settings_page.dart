import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dicoding_restaurant_app/provider/theme_provider.dart';
import 'package:dicoding_restaurant_app/service/notification_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _toggleDailyReminder(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_reminder', value);

    final notificationService = NotificationService();
    if (value) {
      await notificationService.scheduleDailyNotification();
    } else {
      await notificationService.cancelNotification();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Dark Mode'),
                  trailing: Switch(
                    value: themeProvider.themeMode == ThemeMode.dark,
                    onChanged: (bool value) {
                      themeProvider.setTheme(
                        value ? ThemeMode.dark : ThemeMode.light,
                      );
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Gunakan Tema Sistem'),
                  trailing: Switch(
                    value: themeProvider.themeMode == ThemeMode.system,
                    onChanged: (bool value) {
                      themeProvider.setTheme(
                        value ? ThemeMode.system : ThemeMode.light,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Card(
            child: FutureBuilder<bool>(
              future: SharedPreferences.getInstance()
                  .then((prefs) => prefs.getBool('daily_reminder') ?? false),
              builder: (context, snapshot) {
                final isReminderEnabled = snapshot.data ?? false;

                return ListTile(
                  title: const Text('Daily Reminder'),
                  subtitle:
                      const Text('Ingatkan makan siang setiap pukul 11:00 AM'),
                  trailing: Switch(
                    value: isReminderEnabled,
                    onChanged: _toggleDailyReminder,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
