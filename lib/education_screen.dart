import 'package:flutter/material.dart';

class EducationScreen extends StatelessWidget {
  final List<RecyclingCategory> categories = [
    RecyclingCategory(
      title: "Electronics",
      icon: Icons.computer,
      color: Colors.blue,
      items: [
        "Never throw in regular trash",
        "Remove batteries before recycling",
        "Use certified e-waste recyclers",
        "Wipe data from devices",
      ],
    ),
    RecyclingCategory(
      title: "Plastics",
      icon: Icons.local_drink,
      color: Colors.green,
      items: [
        "Check resin codes (1-7)",
        "Rinse containers before recycling",
        "Remove caps and labels",
        "No plastic bags in curbside bins",
      ],
    ),
    RecyclingCategory(
      title: "Paper",
      icon: Icons.description,
      color: Colors.brown,
      items: [
        "Keep dry and clean",
        "Remove plastic windows from envelopes",
        "Flatten cardboard boxes",
        "No greasy pizza boxes",
      ],
    ),
    RecyclingCategory(
      title: "Metals",
      icon: Icons.kitchen,
      color: Colors.orange,
      items: [
        "Separate aluminum and steel",
        "Rinse food containers",
        "Remove plastic components",
        "Recycle aerosol cans when empty",
      ],
    ),
  ];

  EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycling Education'),
        backgroundColor: Colors.green,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Learn Proper Recycling Methods',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Discover how to recycle different materials correctly',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            // Recycling Categories
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryCard(context, categories[index]);
              },
            ),
            const SizedBox(height: 24),
            
            // Did You Know Section
            _buildDidYouKnowCard(),
            const SizedBox(height: 24),
            
            // Recycling Tips
            const Text(
              'Essential Recycling Tips',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTipsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, RecyclingCategory category) {
    return GestureDetector(
      onTap: () {
        _showCategoryDetails(context, category);
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                category.color.withOpacity(0.2),
                category.color.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(category.icon, size: 40, color: category.color),
              const SizedBox(height: 12),
              Text(
                category.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: category.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDidYouKnowCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.green[700]),
                const SizedBox(width: 8),
                const Text(
                  'Did You Know?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Recycling one aluminum can saves enough energy to run a TV for 3 hours! '
              'In Pakistan, proper e-waste recycling can recover valuable metals and '
              'prevent environmental contamination.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsList() {
    final List<String> tips = [
      "Always check local recycling guidelines",
      "Clean items before recycling",
      "Break down cardboard boxes",
      "Keep recyclables loose (no plastic bags)",
      "Learn Pakistan's recycling symbols",
      "Support local recycling initiatives"
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tips.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.recycling, color: Colors.green),
          title: Text(tips[index]),
        );
      },
    );
  }

  void _showCategoryDetails(BuildContext context, RecyclingCategory category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              ...category.items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle, color: category.color, size: 20),
                    const SizedBox(width: 12),
                    Expanded(child: Text(item)),
                  ],
                ),
              )),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: category.color,
                  ),
                  child: const Text('Got It!'),
                ),
                
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Recycling Guides'),
          content: TextField(
            decoration: const InputDecoration(
              hintText: 'Search for materials...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (query) {
              // Implement search functionality
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle search
                Navigator.pop(context);
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }
}

class RecyclingCategory {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> items;

  RecyclingCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });
}