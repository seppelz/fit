import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../models/user_model.dart';

class PreferencesStep extends StatefulWidget {
  const PreferencesStep({super.key});

  @override
  _PreferencesStepState createState() => _PreferencesStepState();
}

class _PreferencesStepState extends State<PreferencesStep> {
  bool _hasTheraband = false;
  bool _allowStandingExercises = true;
  bool _allowSittingExercises = true;
  bool _allowStrengthening = true;
  bool _allowMobilisation = true;
  bool _notificationsEnabled = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    final userSettings = await context.read<UserProvider>().user;
    if (userSettings != null) {
      // Load preferences from user settings
      // This will be implemented when we add user settings to the model
    }
  }

  Future<void> _saveAndFinish() async {
    setState(() => _isLoading = true);

    try {
      // Save preferences to user settings
      // This will be implemented when we add the settings service

      if (mounted) {
        // Navigate to home screen
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildPreferenceSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Customize Your Experience',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Set your exercise preferences to get personalized recommendations.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              children: [
                _buildPreferenceSwitch(
                  title: 'Theraband Exercises',
                  subtitle: 'I have a resistance band for exercises',
                  value: _hasTheraband,
                  onChanged: (value) => setState(() => _hasTheraband = value),
                ),
                const SizedBox(height: 8),
                _buildPreferenceSwitch(
                  title: 'Standing Exercises',
                  subtitle: 'Include exercises that require standing',
                  value: _allowStandingExercises,
                  onChanged: (value) =>
                      setState(() => _allowStandingExercises = value),
                ),
                const SizedBox(height: 8),
                _buildPreferenceSwitch(
                  title: 'Sitting Exercises',
                  subtitle: 'Include exercises that can be done while seated',
                  value: _allowSittingExercises,
                  onChanged: (value) =>
                      setState(() => _allowSittingExercises = value),
                ),
                const SizedBox(height: 8),
                _buildPreferenceSwitch(
                  title: 'Strengthening Exercises',
                  subtitle: 'Include exercises that build strength',
                  value: _allowStrengthening,
                  onChanged: (value) =>
                      setState(() => _allowStrengthening = value),
                ),
                const SizedBox(height: 8),
                _buildPreferenceSwitch(
                  title: 'Mobility Exercises',
                  subtitle: 'Include exercises that improve flexibility',
                  value: _allowMobilisation,
                  onChanged: (value) =>
                      setState(() => _allowMobilisation = value),
                ),
                const SizedBox(height: 8),
                _buildPreferenceSwitch(
                  title: 'Exercise Reminders',
                  subtitle: 'Receive notifications for exercise breaks',
                  value: _notificationsEnabled,
                  onChanged: (value) =>
                      setState(() => _notificationsEnabled = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isLoading ? null : _saveAndFinish,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Finish Setup'),
          ),
        ],
      ),
    );
  }
}
