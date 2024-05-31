import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'second.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BookingServiceScreen(),
    );
  }
}
class BookingServiceScreen extends StatefulWidget {
  @override
  _BookingServiceScreenState createState() => _BookingServiceScreenState();
}

class _BookingServiceScreenState extends State<BookingServiceScreen> {
  String _selectedService = '5.000 Kilometer';
  String? _selectedLocation;
  List<String> _locations = [];

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Lokasi').get();
      final List<String> locations = snapshot.docs.map((doc) => doc['tempat'] as String).toList();
      setState(() {
        _locations = locations;
        _selectedLocation = _locations.isNotEmpty ? _locations[0] : null;
      });
    } catch (e) {
      print('Error fetching locations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.grey[900]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'ESEMKA',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Booking Service',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.grey,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    'assets/Bima-1-3-transparent.png', // Use the local image
                    height: 200,
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedService,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800],
                    labelText: 'Jenis Service',
                    labelStyle: TextStyle(color: Colors.white),
                    suffixIcon: Icon(Icons.build, color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  dropdownColor: Colors.grey[800],
                  style: TextStyle(color: Colors.white),
                  items: [
                    DropdownMenuItem(
                      child: Text('5.000 Kilometer'),
                      value: '5.000 Kilometer',
                    ),
                    DropdownMenuItem(
                      child: Text('10.000 Kilometer'),
                      value: '10.000 Kilometer',
                    ),
                    DropdownMenuItem(
                      child: Text('Rutin'),
                      value: 'Rutin',
                    ),
                    DropdownMenuItem(
                      child: Text('Kerusakan/Kendala'),
                      value: 'Kerusakan/Kendala',
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedService = value!;
                    });
                  },
                ),
                SizedBox(height: 20),
                if (_locations.isNotEmpty)
                  DropdownButtonFormField<String>(
                    value: _selectedLocation,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[800],
                      labelText: 'Lokasi Service',
                      labelStyle: TextStyle(color: Colors.white),
                      suffixIcon: Icon(Icons.location_on, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    dropdownColor: Colors.grey[800],
                    style: TextStyle(color: Colors.white),
                    items: _locations.map((location) {
                      return DropdownMenuItem(
                        child: Text(location),
                        value: location,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedLocation = value!;
                      });
                    },
                  ),
                if (_locations.isEmpty)
                  CircularProgressIndicator(), // Show a loading indicator while fetching locations
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_selectedLocation != null) {
                        Navigator.push(
                          context,
                              MaterialPageRoute(
                                builder: (context) => BookingDetailsScreen(
                                  service: _selectedService,
                                  location: _selectedLocation!,
                                ),
                              ),
                            );
                          } else {
                            // Show a message or handle the error
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please select a location')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Lanjut',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }