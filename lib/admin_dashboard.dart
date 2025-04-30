import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // Sample data for demonstration
  final List<RecyclingData> _weeklyData = [
    RecyclingData('Mon', 45),
    RecyclingData('Tue', 68),
    RecyclingData('Wed', 72),
    RecyclingData('Thu', 89),
    RecyclingData('Fri', 94),
    RecyclingData('Sat', 112),
    RecyclingData('Sun', 85),
  ];

  final List<CenterData> _recyclingCenters = [
    CenterData('Islamabad E-Waste Center', 'Active', 142),
    CenterData('Lahore Recycling Hub', 'Active', 98),
    CenterData('Karachi Green Point', 'Maintenance', 76),
    CenterData('Peshawar Scrap Yard', 'Active', 53),
    CenterData('Faisalabad Eco Station', 'Inactive', 0),
  ];

  final List<UserReport> _recentReports = [
    UserReport('Ahmed R.', 'Battery disposal query', 'Pending'),
    UserReport('Sara K.', 'Broken device pickup', 'Resolved'),
    UserReport('Usman T.', 'Plastic category confusion', 'Pending'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.green[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showNotifications(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshData(),
          ),
        ],
      ),
      drawer: _buildAdminDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Stats Row
            _buildQuickStats(),
            const SizedBox(height: 24),
            
            // Weekly Collection Chart
            _buildCollectionChart(),
            const SizedBox(height: 24),
            
            // Recycling Centers Section
            _buildCentersSection(),
            const SizedBox(height: 24),
            
            // Recent User Reports
            _buildReportsSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewCenter(),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildQuickStats() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _StatCard(title: 'Total Users', value: '1,842', icon: Icons.people),
        _StatCard(title: 'Active Centers', value: '14', icon: Icons.location_on),
        _StatCard(title: 'Today\'s Collections', value: '89', icon: Icons.recycling),
      ],
    );
  }

  Widget _buildCollectionChart() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Collection (kg)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries>[
                  ColumnSeries<RecyclingData, String>(
                    dataSource: _weeklyData,
                    xValueMapper: (RecyclingData data, _) => data.day,
                    yValueMapper: (RecyclingData data, _) => data.amount,
                    color: Colors.green,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCentersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recycling Centers',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Collections')),
                DataColumn(label: Text('Actions')),
              ],
              rows: _recyclingCenters.map((center) {
                return DataRow(cells: [
                  DataCell(Text(center.name)),
                  DataCell(
                    Chip(
                      label: Text(center.status),
                      backgroundColor: center.status == 'Active'
                          ? Colors.green[100]
                          : center.status == 'Maintenance'
                              ? Colors.orange[100]
                              : Colors.red[100],
                    ),
                  ),
                  DataCell(Text(center.collections.toString())),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      onPressed: () => _editCenter(center),
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReportsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent User Reports',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 3,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _recentReports.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final report = _recentReports[index];
              return ListTile(
                title: Text(report.userName),
                subtitle: Text(report.issue),
                trailing: Chip(
                  label: Text(report.status),
                  backgroundColor: report.status == 'Resolved'
                      ? Colors.green[100]
                      : Colors.orange[100],
                ),
                onTap: () => _viewReportDetails(report),
              );
            },
          ),
        ),
      ],
    );
  }

  Drawer _buildAdminDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.green[800]),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.green),
                ),
                SizedBox(height: 16),
                Text(
                  'Admin User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'admin@ewaste.pk',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          _drawerItem(Icons.dashboard, 'Dashboard', () {}),
          _drawerItem(Icons.verified_user, 'Verify Centers', () {}),
          _drawerItem(Icons.analytics, 'Analytics', () {}),
          _drawerItem(Icons.settings, 'Settings', () {}),
          const Divider(),
          _drawerItem(Icons.logout, 'Logout', () {
            Navigator.pushReplacementNamed(context, '/login');
          }),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title),
      onTap: onTap,
    );
  }

  // Action Methods
  void _showNotifications() {
    // Implement notifications view
  }

  void _refreshData() {
    // Implement data refresh
  }

  void _addNewCenter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Recycling Center'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(labelText: 'Center Name')),
            TextField(decoration: InputDecoration(labelText: 'Location')),
            TextField(decoration: InputDecoration(labelText: 'Capacity (kg/day)')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Add center logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Center added successfully')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editCenter(CenterData center) {
    // Implement edit functionality
  }

  void _viewReportDetails(UserReport report) {
    // Implement report viewing
  }
}

// Data Models
class RecyclingData {
  final String day;
  final int amount;

  RecyclingData(this.day, this.amount);
}

class CenterData {
  final String name;
  final String status;
  final int collections;

  CenterData(this.name, this.status, this.collections);
}

class UserReport {
  final String userName;
  final String issue;
  final String status;

  UserReport(this.userName, this.issue, this.status);
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Icon(icon, size: 16, color: Colors.green),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}