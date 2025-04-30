import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Eco-Friendly Buddy'),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(),
            const SizedBox(height: 24),
            
            // Quick Stats Section
            _buildStatsSection(),
            const SizedBox(height: 24),
            
            // Today's Tasks Section
            _buildTasksSection(),
            const SizedBox(height: 24),
            
            // Main Actions Section
            _buildMainActionsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to EWasteRecycling!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start your eco-friendly journey today by recycling responsibly',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Builder(
      builder: (context) => Row(
        children: [
          Expanded(
            child: _buildStatCard(
              title: 'Recycling Tips',
              count: '7',
              icon: Icons.lightbulb_outline,
              onTap: (context) {
                // Navigate to tips screen
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              title: 'Find Recycling Centers',
              count: '16',
              icon: Icons.location_on,
              onTap: (context) {
                Navigator.pushNamed(context, '/search');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today's Tasks",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTaskCard(
                title: 'Navigate Virtual Tour',
                icon: Icons.videocam,
                color: Colors.blue[100]!,
                onTap: () {
                  // Handle virtual tour
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTaskCard(
                title: 'Join Event',
                icon: Icons.event,
                color: Colors.orange[100]!,
                onTap: () {
                  // Handle join event
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainActionsSection() {
    return Builder(
      builder: (context) => Column(
        children: [
          _buildActionCard(
            title: 'FIND RECYCLER',
            subtitle: 'Locate Nearest Center',
            icon: Icons.map,
            color: Colors.green,
            onTap: () {
              Navigator.pushNamed(context, '/geolocation');
            },
          ),
          const SizedBox(height: 16),
          _buildActionCard(
            title: 'RECYCLING DICTIONARY',
            subtitle: 'Learn Recycling Terms',
            icon: Icons.book,
            color: Colors.purple,
            onTap: () {
              Navigator.pushNamed(context, '/education');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String count,
    required IconData icon,
    required Function(BuildContext) onTap,
  }) {
    return Builder(
      builder: (context) => InkWell(
        onTap: () => onTap(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.green, size: 24),
              const SizedBox(height: 8),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }
}