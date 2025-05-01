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
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshData();
          return Future.delayed(const Duration(milliseconds: 1500));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
              // Add bottom padding to avoid FAB overlap
              const SizedBox(height: 80),
            ],
          ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Check if screen is narrow
        if (constraints.maxWidth < 600) {
          // For small screens, show stats in a column
          return Column(
            children: const [
              _StatCard(title: 'Total Users', value: '1,842', icon: Icons.people),
              SizedBox(height: 8),
              _StatCard(title: 'Active Centers', value: '14', icon: Icons.location_on),
              SizedBox(height: 8),
              _StatCard(title: 'Today\'s Collections', value: '89', icon: Icons.recycling),
            ],
          );
        }
        // For wider screens, show stats in a row
        return const Row(
          children: [
            Expanded(child: _StatCard(title: 'Total Users', value: '1,842', icon: Icons.people)),
            SizedBox(width: 8),
            Expanded(child: _StatCard(title: 'Active Centers', value: '14', icon: Icons.location_on)),
            SizedBox(width: 8),
            Expanded(child: _StatCard(title: 'Today\'s Collections', value: '89', icon: Icons.recycling)),
          ],
        );
      }
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
                margin: const EdgeInsets.all(0),
                primaryXAxis: CategoryAxis(),
                // Add tooltips for better user experience
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries>[
                  ColumnSeries<RecyclingData, String>(
                    dataSource: _weeklyData,
                    xValueMapper: (RecyclingData data, _) => data.day,
                    yValueMapper: (RecyclingData data, _) => data.amount,
                    color: Colors.green,
                    // Add data labels
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recycling Centers',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add New'),
              onPressed: () => _addNewCenter(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 3,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: () => _editCenter(center),
                            tooltip: 'Edit',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                            onPressed: () => _deleteCenter(center),
                            tooltip: 'Delete',
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _deleteCenter(CenterData center) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${center.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Delete center logic would go here
                setState(() {
                  _recyclingCenters.remove(center);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${center.name} deleted')),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
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
          _drawerItem(Icons.dashboard, 'Dashboard', () {
            Navigator.pop(context); // Close drawer first
            // No navigation needed as we're already on dashboard
          }),
          _drawerItem(Icons.verified_user, 'Verify Centers', () {
            Navigator.pop(context);
            // Navigate to verify centers screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Verify Centers - Coming Soon')),
            );
          }),
          _drawerItem(Icons.analytics, 'Analytics', () {
            Navigator.pop(context);
            // Navigate to analytics screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Analytics - Coming Soon')),
            );
          }),
          _drawerItem(Icons.settings, 'Settings', () {
            Navigator.pop(context);
            // Navigate to settings screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Settings - Coming Soon')),
            );
          }),
          const Divider(),
          _drawerItem(Icons.logout, 'Logout', () {
            // Handle logout with confirmation
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirm Logout'),
                content: const Text('Are you sure you want to log out?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Close drawer
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: const [
              ListTile(
                leading: Icon(Icons.notification_important, color: Colors.red),
                title: Text('New center request'),
                subtitle: Text('Rawalpindi area - 10 minutes ago'),
              ),
              ListTile(
                leading: Icon(Icons.warning, color: Colors.orange),
                title: Text('Capacity warning'),
                subtitle: Text('Lahore center at 85% - 2 hours ago'),
              ),
              ListTile(
                leading: Icon(Icons.info, color: Colors.blue),
                title: Text('System update available'),
                subtitle: Text('Version 2.1 ready - 1 day ago'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications cleared')),
              );
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
    );
  }

  void _refreshData() {
    // In a real app, you'd fetch fresh data here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refreshing data...')),
    );
    
    // Simulate loading delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        // Update with new data
      });
    });
  }

  void _addNewCenter() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    final capacityController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Recycling Center'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Center Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter center name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: capacityController,
                decoration: const InputDecoration(labelText: 'Capacity (kg/day)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter capacity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // Add center logic
                setState(() {
                  _recyclingCenters.add(
                    CenterData(
                      nameController.text,
                      'Active',
                      0, // Initial collections
                    ),
                  );
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${nameController.text} added successfully')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editCenter(CenterData center) {
    final nameController = TextEditingController(text: center.name);
    final statusOptions = ['Active', 'Maintenance', 'Inactive'];
    String selectedStatus = center.status;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text('Edit Recycling Center'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Center Name'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: statusOptions.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedStatus = value;
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Update center data
                  final int index = _recyclingCenters.indexOf(center);
                  if (index != -1) {
                    this.setState(() {
                      _recyclingCenters[index] = CenterData(
                        nameController.text,
                        selectedStatus,
                        center.collections,
                      );
                    });
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Center updated successfully')),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _viewReportDetails(UserReport report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report from ${report.userName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Issue: ${report.issue}'),
            const SizedBox(height: 8),
            Text('Status: ${report.status}'),
            const SizedBox(height: 16),
            const Text(
              'Additional Details:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'User reported this issue on May 1, 2025. They attached 2 photos showing their recycling questions.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (report.status != 'Resolved')
            TextButton(
              onPressed: () {
                // Mark as resolved
                final int index = _recentReports.indexOf(report);
                if (index != -1) {
                  setState(() {
                    _recentReports[index] = UserReport(
                      report.userName,
                      report.issue,
                      'Resolved',
                    );
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Mark as Resolved'),
            ),
        ],
      ),
    );
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