import 'package:dicoding_restaurant_app/provider/reminder_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_restaurant_app/provider/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
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
          SizedBox(height: 20),
          _buildSectionTitle('Pengingat'),
          Consumer<ReminderProvider>(
            builder: (context, provider, _) {
              return SwitchListTile(
                title: const Text('Daily Reminder Makan Siang'),
                subtitle: const Text('Notifikasi pada pukul 11:00 AM'),
                value: provider.isReminderEnabled,
                onChanged: (value) {
                  provider.toggleReminder(value);
                },
              );
            },
          ),
          const Divider(),
          _buildSectionTitle('Daftar Reminder Aktif'),
          const PendingRemindersList(),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class PendingRemindersList extends StatefulWidget {
  const PendingRemindersList({super.key});

  @override
  State<PendingRemindersList> createState() => _PendingRemindersListState();
}

class _PendingRemindersListState extends State<PendingRemindersList> {
  List<PendingNotificationRequest> _pendingReminders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPendingReminders();
  }

  Future<void> _loadPendingReminders() async {
    final provider = Provider.of<ReminderProvider>(context, listen: false);
    final reminders = await provider.getPendingReminders();

    setState(() {
      _pendingReminders = reminders;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_pendingReminders.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Tidak ada reminder aktif saat ini',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _pendingReminders.length,
      itemBuilder: (context, index) {
        final reminder = _pendingReminders[index];
        return ListTile(
          leading: const Icon(Icons.notifications_active),
          title: Text(reminder.title ?? 'Reminder'),
          subtitle: Text(reminder.body ?? 'Notification'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final provider = Provider.of<ReminderProvider>(
                context,
                listen: false,
              );
              await provider.cancelSpecificReminder(reminder.id);
              _loadPendingReminders();
            },
          ),
        );
      },
    );
  }
}
