import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EWasteRecycling'),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Information
            const Center(
              child: Text(
                'contact@ewasterecycle.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Update Profile Section
            const Text(
              'Update Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.green),
              title: const Text('Edit Profile Information'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to edit profile
              },
            ),
            const Divider(),
            
            // Recycle Reminders Section
            const Text(
              'Recycle Reminders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Reminders'),
              value: true,
              onChanged: (value) {},
              secondary: const Icon(Icons.notifications, color: Colors.green),
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.green),
              title: const Text('Share App Link'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _shareAppLink();
              },
            ),
            const Divider(),
            
            // Refer Friends Section
            const Text(
              'Refer Friends',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.group, color: Colors.green),
              title: const Text('Share with Friends'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _shareAppLink();
              },
            ),
            // Add language toggle
  ListTile(
  leading: const Icon(Icons.language),
  title: const Text('Language'),
  trailing: const Text('English/اردو'),
  onTap: () {
    // Implement language change
  },
),
            const Divider(height: 40),
            
            // Sign Out Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Sign out'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareAppLink() async {
    await Share.share(
      'Check out EWasteRecycling app - helping Pakistan recycle e-waste responsibly!\nhttps://ewasterecycle.com/download',
      subject: 'Join EWasteRecycling',
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacementNamed(context, '/welcome');
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}