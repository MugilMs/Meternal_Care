import 'package:flutter/material.dart';
import '../models/hospital.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../utils/ui_helpers.dart';

class HospitalsScreen extends StatefulWidget {
  const HospitalsScreen({Key? key}) : super(key: key);

  @override
  State<HospitalsScreen> createState() => _HospitalsScreenState();
}

class _HospitalsScreenState extends State<HospitalsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = "All";
  final List<String> _filters = ["All", "Nearest", "Top Rated", "Maternity", "NICU"];

  final List<Hospital> hospitals = [
    Hospital(
      id: 1,
      name: "City General Hospital",
      address: "123 Main Street, Downtown",
      phone: "+1 (555) 123-4567",
      email: "info@citygeneralhospital.com",
      website: "www.citygeneralhospital.com",
      rating: 4.5,
      distance: 2.3,
      services: ["Maternity Ward", "NICU", "Prenatal Care", "Postnatal Care"],
      imageUrl: "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
      latitude: 37.7749,
      longitude: -122.4194,
    ),
    Hospital(
      id: 2,
      name: "Women's Health Center",
      address: "456 Oak Avenue, Midtown",
      phone: "+1 (555) 987-6543",
      email: "contact@womenshealthcenter.org",
      website: "www.womenshealthcenter.org",
      rating: 4.8,
      distance: 3.7,
      services: ["Maternity Ward", "Gynecology", "Prenatal Care", "Fertility Services"],
      imageUrl: "https://images.unsplash.com/photo-1586773860418-d37222d8fce3?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
      latitude: 37.7833,
      longitude: -122.4167,
    ),
    Hospital(
      id: 3,
      name: "Riverside Medical Center",
      address: "789 River Road, Westside",
      phone: "+1 (555) 456-7890",
      email: "info@riversidemedical.com",
      website: "www.riversidemedical.com",
      rating: 4.2,
      distance: 5.1,
      services: ["Maternity Ward", "Pediatrics", "Prenatal Care", "Emergency Services"],
      imageUrl: "https://images.unsplash.com/photo-1587351021759-3e566b3db4fa?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
      latitude: 37.7691,
      longitude: -122.4449,
    ),
    Hospital(
      id: 4,
      name: "Sunshine Children's Hospital",
      address: "101 Sunshine Blvd, Eastside",
      phone: "+1 (555) 234-5678",
      email: "contact@sunshinehospital.org",
      website: "www.sunshinehospital.org",
      rating: 4.9,
      distance: 4.5,
      services: ["NICU", "Pediatrics", "Child Birth", "Family Care"],
      imageUrl: "https://images.unsplash.com/photo-1538108149393-fbbd81895907?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
      latitude: 37.7858,
      longitude: -122.4008,
    ),
  ];

  List<Hospital> get filteredHospitals {
    if (_selectedFilter == "All") {
      return hospitals;
    } else if (_selectedFilter == "Nearest") {
      return List.from(hospitals)..sort((a, b) => a.distance.compareTo(b.distance));
    } else if (_selectedFilter == "Top Rated") {
      return List.from(hospitals)..sort((a, b) => b.rating.compareTo(a.rating));
    } else {
      return hospitals.where((hospital) => 
        hospital.services.any((service) => 
          service.toLowerCase().contains(_selectedFilter.toLowerCase())
        )
      ).toList();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppHeader(
        title: "Find Hospitals",
        currentPage: "hospitals",
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Find Hospitals",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Discover hospitals and healthcare providers near you",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Search Bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search hospitals...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
            
            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _filters.map((filter) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      }
                    },
                    selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: _selectedFilter == filter 
                          ? AppTheme.primaryColor 
                          : AppTheme.textSecondaryColor,
                      fontWeight: _selectedFilter == filter 
                          ? FontWeight.bold 
                          : FontWeight.normal,
                    ),
                  ),
                )).toList(),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Map Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: () {
                  UIHelpers.showWorkInProgressDialog(context);
                },
                icon: const Icon(Icons.map),
                label: const Text("View on Map"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Hospital List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredHospitals.length,
                itemBuilder: (context, index) {
                  final hospital = filteredHospitals[index];
                  return _buildHospitalCard(hospital);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalCard(Hospital hospital) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hospital image
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              image: DecorationImage(
                image: NetworkImage(hospital.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hospital name and rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        hospital.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          hospital.rating.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Address and distance
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppTheme.textSecondaryColor,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        hospital.address,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${hospital.distance} km",
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Services
                const Text(
                  "Services",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: hospital.services.map((service) => _buildServiceChip(service)).toList(),
                ),
                const SizedBox(height: 16),
                
                // Contact buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          UIHelpers.showWorkInProgressDialog(context);
                        },
                        icon: const Icon(Icons.phone),
                        label: const Text("Call"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.accentColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          UIHelpers.showWorkInProgressDialog(context);
                        },
                        icon: const Icon(Icons.info_outline),
                        label: const Text("Details"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceChip(String service) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        service,
        style: TextStyle(
          fontSize: 12,
          color: AppTheme.accentColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
