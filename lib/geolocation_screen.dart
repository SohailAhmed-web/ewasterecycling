import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'dart:async';

// Model for recycling center data
class RecyclingCenter {
  final String name;
  final LatLng position;
  final String type;
  final String address;
  final double distance;

  RecyclingCenter({
    required this.name,
    required this.position,
    required this.type,
    required this.address,
    required this.distance,
  });
}

// Service for interacting with location APIs
class RecyclingCenterService {
  // Using Pakistan's open data APIs or Google Places API
  static Future<List<RecyclingCenter>> getNearbyRecyclingCenters(LatLng position) async {
    try {
      // Using Google Places API to search for recycling centers
      // Note: In a production app, you would use your own API key and proper configuration
      final String apiKey = 'YOUR_API_KEY';  // Replace with actual API key in production
      final radius = 10000; // 10km radius
      
      // For demonstration, we're using a simplified call
      // In production, this would call an actual API endpoint
      final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
          'location=${position.latitude},${position.longitude}'
          '&radius=$radius'
          '&keyword=recycling,ewaste,electronic waste'
          '&key=$apiKey';
          
      // For development purposes only, we'll use mock data instead of making actual API calls
      // In production, you would uncomment and use the HTTP request below
      
      /* 
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<RecyclingCenter> centers = [];
        
        for (var place in data['results']) {
          final lat = place['geometry']['location']['lat'];
          final lng = place['geometry']['location']['lng'];
          
          double distanceInMeters = Geolocator.distanceBetween(
            position.latitude, 
            position.longitude, 
            lat, 
            lng
          );
          
          centers.add(RecyclingCenter(
            name: place['name'],
            position: LatLng(lat, lng),
            type: place['types'].contains('electronics_store') ? 'Electronics' : 'General',
            address: place['vicinity'] ?? '',
            distance: distanceInMeters / 1000, // convert to km
          ));
        }
        
        // Sort centers by distance
        centers.sort((a, b) => a.distance.compareTo(b.distance));
        return centers;
      } else {
        throw Exception('Failed to load recycling centers');
      }
      */
      
      // Mock data for development - replace with actual API call in production
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay
      return _getMockRecyclingCenters(position);
    } catch (e) {
      print('Error fetching recycling centers: $e');
      return _getMockRecyclingCenters(position); // Fallback to mock data
    }
  }
  
  // Mock data for development and testing purposes
  static List<RecyclingCenter> _getMockRecyclingCenters(LatLng position) {
    final List<Map<String, dynamic>> centers = [
      {
        'name': 'Islamabad E-Waste Center',
        'position': LatLng(33.6844, 73.0479),
        'type': 'Electronics',
        'address': 'F-8 Markaz, Islamabad'
      },
      {
        'name': 'Lahore Recycling Facility',
        'position': LatLng(31.5204, 74.3587),
        'type': 'General',
        'address': 'Gulberg III, Lahore'
      },
      {
        'name': 'Karachi E-Waste Management',
        'position': LatLng(24.8607, 67.0011),
        'type': 'Electronics',
        'address': 'Clifton, Karachi'
      },
      {
        'name': 'Peshawar Scrap Center',
        'position': LatLng(34.0151, 71.5249),
        'type': 'Metal',
        'address': 'University Town, Peshawar'
      },
      {
        'name': 'Rawalpindi Tech Recyclers',
        'position': LatLng(33.5651, 73.0169),
        'type': 'Electronics',
        'address': 'Saddar, Rawalpindi'
      },
      {
        'name': 'Faisalabad Green Waste',
        'position': LatLng(31.4504, 73.1350),
        'type': 'General',
        'address': 'D Ground, Faisalabad'
      },
    ];

    List<RecyclingCenter> result = [];
    
    for (var center in centers) {
      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        center['position'].latitude,
        center['position'].longitude
      );
      
      result.add(
        RecyclingCenter(
          name: center['name'],
          position: center['position'],
          type: center['type'],
          address: center['address'],
          distance: distanceInMeters / 1000, // Convert to km
        ),
      );
    }
    
    // Sort by distance
    result.sort((a, b) => a.distance.compareTo(b.distance));
    return result;
  }
}

class GeoLocationScreen extends StatefulWidget {
  const GeoLocationScreen({super.key});

  @override
  State<GeoLocationScreen> createState() => _GeoLocationScreenState();
}

class _GeoLocationScreenState extends State<GeoLocationScreen> {
  late GoogleMapController mapController;
  LatLng? _currentPosition;
  Set<Marker> _markers = {};
  bool _loading = true;
  String _searchAddress = '';
  TextEditingController _searchController = TextEditingController();
  List<RecyclingCenter> _nearbyCenters = [];
  bool _showList = false;
  
  // Default to Pakistan coordinates (Islamabad)
  static const LatLng _pakistanCenter = LatLng(33.6844, 73.0479);
  static const double _initialZoom = 12.0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _loading = true;
    });
    
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services not enabled
        _showLocationServiceDisabledError();
        setState(() {
          _currentPosition = _pakistanCenter;
          _loading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions denied
          _showLocationPermissionDeniedError();
          setState(() {
            _currentPosition = _pakistanCenter;
            _loading = false;
          });
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      final LatLng userLocation = LatLng(position.latitude, position.longitude);
      
      setState(() {
        _currentPosition = userLocation;
      });
      
      // After getting location, search for nearby recycling centers
      await _searchNearbyCenters(userLocation);
    } catch (e) {
      print('Error getting location: $e');
      // Fallback to Pakistan center
      setState(() {
        _currentPosition = _pakistanCenter;
        _loading = false;
      });
    }
  }

  Future<void> _searchNearbyCenters(LatLng position) async {
    try {
      setState(() {
        _loading = true;
      });
      
      // Get recycling centers from service
      final centers = await RecyclingCenterService.getNearbyRecyclingCenters(position);
      
      // Update markers
      _updateMarkers(centers);
      
      setState(() {
        _nearbyCenters = centers;
        _loading = false;
      });
      
      // Move camera to current position
      if (mapController != null && _currentPosition != null) {
        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(_currentPosition!, _initialZoom),
        );
      }
    } catch (e) {
      print('Error searching centers: $e');
      setState(() {
        _loading = false;
      });
    }
  }
  
  void _updateMarkers(List<RecyclingCenter> centers) {
    Set<Marker> markers = {};
    
    // Add user's current position
    if (_currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentPosition!,
          infoWindow: const InfoWindow(
            title: 'Your Location',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
    }
    
    // Add recycling centers
    for (var center in centers) {
      markers.add(
        Marker(
          markerId: MarkerId(center.name),
          position: center.position,
          infoWindow: InfoWindow(
            title: center.name,
            snippet: '${center.type} • ${center.distance.toStringAsFixed(1)}km away',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            center.type == 'Electronics'
                ? BitmapDescriptor.hueBlue
                : center.type == 'Metal'
                    ? BitmapDescriptor.hueOrange
                    : BitmapDescriptor.hueGreen,
          ),
        ),
      );
    }
    
    setState(() {
      _markers = markers;
    });
  }
  
  Future<void> _searchByAddress() async {
    if (_searchAddress.isEmpty) return;
    
    setState(() {
      _loading = true;
    });
    
    try {
      List<Location> locations = await locationFromAddress(_searchAddress + ', Pakistan');
      if (locations.isNotEmpty) {
        final location = locations.first;
        final LatLng searchedLocation = LatLng(location.latitude, location.longitude);
        
        setState(() {
          _currentPosition = searchedLocation;
        });
        
        if (mapController != null) {
          mapController.animateCamera(
            CameraUpdate.newLatLngZoom(searchedLocation, _initialZoom),
          );
        }
        
        await _searchNearbyCenters(searchedLocation);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location not found, please try a different search')),
        );
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      print('Error searching address: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error searching location')),
      );
      setState(() {
        _loading = false;
      });
    }
  }
  
  void _showLocationServiceDisabledError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location services are disabled. Please enable them in settings.'),
        duration: Duration(seconds: 3),
      ),
    );
  }
  
  void _showLocationPermissionDeniedError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location permission denied. Some features may not work.'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycle Electronics - Locate Nearest'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(_showList ? Icons.map : Icons.list),
            onPressed: () {
              setState(() {
                _showList = !_showList;
              });
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search by city, area or address',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchAddress = value;
                            });
                          },
                          onSubmitted: (_) => _searchByAddress(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _searchByAddress,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Search'),
                      ),
                    ],
                  ),
                ),
                
                // Main content - Map or List view
                Expanded(
                  child: _showList 
                      ? _buildRecyclingCentersList()
                      : _buildGoogleMap(),
                ),
              ],
            ),
      floatingActionButton: !_showList ? FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          _getCurrentLocation();
        },
        child: const Icon(Icons.my_location),
      ) : null,
    );
  }
  
  Widget _buildGoogleMap() {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _currentPosition ?? _pakistanCenter,
            zoom: _initialZoom,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: (controller) {
            setState(() {
              mapController = controller;
            });
          },
        ),
        
        // Filter chips at the top
        Positioned(
          top: 10,
          left: 10,
          right: 10,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All'),
                const SizedBox(width: 8),
                _buildFilterChip('Electronics'),
                const SizedBox(width: 8),
                _buildFilterChip('Metal'),
                const SizedBox(width: 8),
                _buildFilterChip('General'),
                const SizedBox(width: 8),
                _buildFilterChip('Nearest'),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildFilterChip(String label) {
    return FilterChip(
      label: Text(label),
      backgroundColor: Colors.white,
      selected: false,
      onSelected: (bool selected) {
        // Filter logic would go here
        if (label == 'Nearest') {
          _sortCentersByDistance();
        } else if (label != 'All') {
          _filterCentersByType(label);
        } else {
          _resetFilters();
        }
      },
    );
  }
  
  void _sortCentersByDistance() {
    // Already sorted by default, but you could refresh the sort here
    setState(() {
      _nearbyCenters.sort((a, b) => a.distance.compareTo(b.distance));
      _updateMarkers(_nearbyCenters);
    });
  }
  
  void _filterCentersByType(String type) {
    setState(() {
      List<RecyclingCenter> filteredCenters = _nearbyCenters
          .where((center) => center.type == type)
          .toList();
      _updateMarkers(filteredCenters);
    });
  }
  
  void _resetFilters() {
    setState(() {
      _searchNearbyCenters(_currentPosition ?? _pakistanCenter);
    });
  }
  
  Widget _buildRecyclingCentersList() {
    return _nearbyCenters.isEmpty
        ? const Center(child: Text('No recycling centers found nearby'))
        : ListView.builder(
            itemCount: _nearbyCenters.length,
            itemBuilder: (context, index) {
              final center = _nearbyCenters[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: center.type == 'Electronics'
                        ? Colors.blue
                        : center.type == 'Metal'
                            ? Colors.orange
                            : Colors.green,
                    child: Icon(
                      center.type == 'Electronics'
                          ? Icons.devices
                          : center.type == 'Metal'
                              ? Icons.hardware
                              : Icons.recycling,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(center.name),
                  subtitle: Text('${center.address}\n${center.type} • ${center.distance.toStringAsFixed(1)}km away'),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.directions),
                    onPressed: () {
                      // Navigate to this center on map
                      setState(() {
                        _showList = false;
                      });
                      
                      Future.delayed(Duration.zero, () {
                        mapController.animateCamera(
                          CameraUpdate.newLatLngZoom(center.position, 15),
                        );
                      });
                    },
                  ),
                  onTap: () {
                    // Show more details or navigate to this center
                    setState(() {
                      _showList = false;
                    });
                    
                    Future.delayed(Duration.zero, () {
                      mapController.animateCamera(
                        CameraUpdate.newLatLngZoom(center.position, 15),
                      );
                    });
                  },
                ),
              );
            },
          );
  }
}