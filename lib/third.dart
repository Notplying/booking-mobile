import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'fourth.dart'; // Import the FourthScreen file

class ThirdScreen extends StatefulWidget {
  final String service;
  final String location;
  final String name;
  final String phone;
  final String email;
  final String contactPreference;
  final String carModel;
  final String licensePlate;

  ThirdScreen({
    required this.service,
    required this.location,
    required this.name,
    required this.phone,
    required this.email,
    required this.contactPreference,
    required this.carModel,
    required this.licensePlate,
  });

  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  String? _selectedDealer;
  List<DropdownMenuItem<String>> _dealers = [];
  DateTime? _selectedDate;
  String? _selectedTime;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDealers();
  }

  Future<void> _fetchDealers() async {
    CollectionReference dealers = FirebaseFirestore.instance.collection('/Lokasi/Jakarta/toko');
    QuerySnapshot snapshot = await dealers.get();

    List<DropdownMenuItem<String>> dealerItems = snapshot.docs.map((doc) {
      return DropdownMenuItem<String>(
        child: Text(doc['jalan']), // Assuming the document has a 'jalan' field
        value: doc['jalan'], // Use the 'jalan' field as the value
      );
    }).toList();

    setState(() {
      _dealers = dealerItems;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final times = List.generate(11, (index) => '${8 + index}:00'); // 08:00 to 18:00

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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Service',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.service,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.green,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.location,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.grey,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[800],
                              labelText: 'Tempat Dealer',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            dropdownColor: Colors.grey[800],
                            style: TextStyle(color: Colors.white),
                            items: _dealers,
                            validator: (value) => value == null ? 'Please select a dealer' : null,
                            onChanged: (value) {
                              setState(() {
                                _selectedDealer = value;
                              });
                            },
                            value: _selectedDealer,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              filled: true,
                              labelText: 'Tanggal',
                              hintText: 'Pilih Tanggal',
                              fillColor: Colors.grey[800],
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                            onTap: () => _selectDate(context),
                            validator: (value) {
                              if (_selectedDate == null) {
                                return 'Please select a date';
                              }
                              return null;
                            },
                            controller: TextEditingController(
                              text: _selectedDate == null
                                  ? ''
                                  : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                            ),
                          ),
                          SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[800],
                              labelText: 'Waktu',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            dropdownColor: Colors.grey[800],
                            style: TextStyle(color: Colors.white),
                            items: times.map((time) {
                              return DropdownMenuItem<String>(
                                child: Text(time),
                                value: time,
                              );
                            }).toList(),
                            validator: (value) => value == null ? 'Please select a time' : null,
                            onChanged: (value) {
                              setState(() {
                                _selectedTime = value;
                              });
                            },
                            value: _selectedTime,
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: _notesController,
                            decoration: InputDecoration(
                              filled: true,
                              labelText: 'Catatan',
                              hintText: 'Tambahkan catatan...',
                              fillColor: Colors.grey[800],
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                            maxLines: 5,
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Kembali',
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FourthScreen(
                                  service: widget.service,
                                  location: widget.location,
                                  name: widget.name,
                                  phone: widget.phone,
                                  email: widget.email,
                                  contactPreference: widget.contactPreference,
                                  carModel: widget.carModel,
                                  licensePlate: widget.licensePlate,
                                  dealer: _selectedDealer!,
                                  date: DateFormat('dd/MM/yyyy').format(_selectedDate!),
                                  time: _selectedTime!,
                                  notes: _notesController.text,
                                ),
                              ),
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
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}