import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/user_service.dart';

class WorkHoursSettingsScreen extends StatefulWidget {
  const WorkHoursSettingsScreen({super.key});

  @override
  State<WorkHoursSettingsScreen> createState() => _WorkHoursSettingsScreenState();
}

class _WorkHoursSettingsScreenState extends State<WorkHoursSettingsScreen> {
  TimeOfDay? _workStartTime;
  TimeOfDay? _workEndTime;
  final List<bool> _workDays = List.filled(7, true);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    _workStartTime = _parseTimeString(user?.workStartTime ?? '09:00');
    _workEndTime = _parseTimeString(user?.workEndTime ?? '17:00');
    _workDays.setAll(0, user?.workDays ?? List.filled(7, true));
  }

  TimeOfDay? _parseTimeString(String time) {
    try {
      final parts = time.split(':');
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    } catch (e) {
      return null;
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _workStartTime! : _workEndTime!,
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _workStartTime = picked;
        } else {
          _workEndTime = picked;
        }
      });
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);

    try {
      final userProvider = context.read<UserProvider>();
      final userService = UserService();

      await userService.updateUser(userProvider.user!.id, {
        'workStartTime': _formatTimeOfDay(_workStartTime!),
        'workEndTime': _formatTimeOfDay(_workEndTime!),
        'workDays': _workDays,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Work hours updated')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating work hours: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work Hours'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Work days
          const Text(
            'Work Days',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('S')),
              ButtonSegment(value: 1, label: Text('M')),
              ButtonSegment(value: 2, label: Text('T')),
              ButtonSegment(value: 3, label: Text('W')),
              ButtonSegment(value: 4, label: Text('T')),
              ButtonSegment(value: 5, label: Text('F')),
              ButtonSegment(value: 6, label: Text('S')),
            ],
            selected: _workDays
                .asMap()
                .entries
                .where((entry) => entry.value)
                .map((entry) => entry.key)
                .toSet(),
            onSelectionChanged: (Set<int> selected) {
              setState(() {
                for (var i = 0; i < _workDays.length; i++) {
                  _workDays[i] = selected.contains(i);
                }
              });
            },
            multiSelectionEnabled: true,
          ),
          const SizedBox(height: 32),

          // Work hours
          const Text(
            'Work Hours',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Start Time'),
            trailing: Text(
              _workStartTime != null ? _formatTimeOfDay(_workStartTime!) : '--:--',
              style: const TextStyle(fontSize: 16),
            ),
            onTap: () => _selectTime(context, true),
          ),
          ListTile(
            title: const Text('End Time'),
            trailing: Text(
              _workEndTime != null ? _formatTimeOfDay(_workEndTime!) : '--:--',
              style: const TextStyle(fontSize: 16),
            ),
            onTap: () => _selectTime(context, false),
          ),
          const SizedBox(height: 32),

          FilledButton(
            onPressed: _isLoading ? null : _saveSettings,
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
