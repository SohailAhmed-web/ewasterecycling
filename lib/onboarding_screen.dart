import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool morningReminder = false;
  bool noonReminder = false;
  bool eveningReminder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Title
              const Text(
                'Set your recycling reminders now',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              
              // Morning Reminder
              _buildReminderCard(
                time: 'Morning',
                description: 'Start your day with recycling',
                isActive: morningReminder,
                onChanged: (value) {
                  setState(() {
                    morningReminder = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              
              // Noon Reminder
              _buildReminderCard(
                time: 'Noon',
                description: 'Recycle during your lunch break',
                isActive: noonReminder,
                onChanged: (value) {
                  setState(() {
                    noonReminder = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              
              // Evening Reminder
              _buildReminderCard(
                time: 'Evening',
                description: 'End your day with recycling',
                isActive: eveningReminder,
                onChanged: (value) {
                  setState(() {
                    eveningReminder = value;
                  });
                },
              ),
              
              const Spacer(),
              
              // Bottom Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.green),
                      ),
                      child: const Text(
                        'Ignore',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Save reminder preferences
                        _saveReminderPreferences();
                        Navigator.pushNamed(context, '/home');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReminderCard({
    required String time,
    required String description,
    required bool isActive,
    required Function(bool) onChanged,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Switch(
              value: isActive,
              onChanged: onChanged,
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  void _saveReminderPreferences() {
    // Implement your logic to save reminder preferences
    // Can use SharedPreferences or your state management solution
    print('Reminders saved:');
    print('Morning: $morningReminder');
    print('Noon: $noonReminder');
    print('Evening: $eveningReminder');
  }
}