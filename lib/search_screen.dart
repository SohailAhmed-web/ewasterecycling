import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find recycling centers nearby'),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            _buildSearchBar(),
            const SizedBox(height: 24),
            
            // Recent Searches Section
            _buildSectionTitle('Recent recycling searches'),
            const SizedBox(height: 12),
            _buildRecentSearches(),
            const SizedBox(height: 16),
            _buildShowMoreButton(),
            const SizedBox(height: 24),
            
            // Popular Recyclables Section
            _buildSectionTitle('Popular recyclables'),
            const SizedBox(height: 12),
            _buildPopularRecyclables(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search for recycling centers...',
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12, horizontal: 16),
      ),
      onChanged: (value) {
        // Handle search
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildRecentSearches() {
    final recentItems = [
      'Plastic', 'Metal', 'Glass', 
      'Paper', 'Electronic', 'Battery'
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: recentItems.map((item) {
        return Chip(
          label: Text(item),
          backgroundColor: Colors.green[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onDeleted: () {
            // Remove from recent searches
          },
          deleteIcon: const Icon(Icons.close, size: 18),
        );
      }).toList(),
    );
  }

  Widget _buildShowMoreButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: () {
          // Show more recent searches
        },
        icon: const Icon(Icons.expand_more, size: 18),
        label: const Text('Show more'),
        style: TextButton.styleFrom(
          foregroundColor: Colors.green,
        ),
      ),
    );
  }

  Widget _buildPopularRecyclables() {
    final popularItems = [
      'Recyclable', 'Biodegradable', 'Compostable',
      'Non-recyclable', 'Reusable', 'Sustainable'
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3,
      ),
      itemCount: popularItems.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: _getCategoryColor(popularItems[index]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              popularItems[index],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Recyclable':
        return Colors.green;
      case 'Biodegradable':
        return Colors.blue;
      case 'Compostable':
        return Colors.brown;
      case 'Non-recyclable':
        return Colors.red;
      case 'Reusable':
        return Colors.orange;
      case 'Sustainable':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}