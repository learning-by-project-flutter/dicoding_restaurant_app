import 'package:dicoding_restaurant_app/provider/reminder_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_restaurant_app/provider/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
          Consumer<ReminderProvider>(
            builder: (context, reminderProvider, child) {
              return SwitchListTile(
                title: Text("Daily Reminder"),
                subtitle: Text(
                    "Aktifkan untuk mendapatkan pengingat makan siang setiap hari"),
                value: reminderProvider.isReminderOn,
                onChanged: (value) {
                  reminderProvider.toggleReminder(value);
                },
              );
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _triggerTestNotification(context);
            },
            child: Text("Test Notification"),
          ),
        ],
      ),
    );
  }

  void _triggerTestNotification(BuildContext context) {
    final reminderProvider =
        Provider.of<ReminderProvider>(context, listen: false);

    reminderProvider.triggerTestNotification();
  }
}
