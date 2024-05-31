import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'fifth.dart';

class FourthScreen extends StatelessWidget {
  final String service;
  final String location;
  final String name;
  final String phone;
  final String email;
  final String contactPreference;
  final String carModel;
  final String licensePlate;
  final String dealer;
  final String date;
  final String time;
  final String notes;

  FourthScreen({
    required this.service,
    required this.location,
    required this.name,
    required this.phone,
    required this.email,
    required this.contactPreference,
    required this.carModel,
    required this.licensePlate,
    required this.dealer,
    required this.date,
    required this.time,
    required this.notes,
  });

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
                  service,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.green,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  location,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Konfirmasi Booking',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Nama', name),
                      _buildDetailRow('No. Telp', phone),
                      _buildDetailRow('Email', email),
                      _buildDetailRow('Model', carModel),
                      _buildDetailRow('Nomor', licensePlate),
                      _buildDetailRow('Preferensi Kontak', contactPreference),
                      _buildDetailRow('Lokasi', dealer),
                      _buildDetailRow('Tanggal Booking', date),
                      _buildDetailRow('Waktu Booking', time),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Catatan Tambahan',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    notes,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                Spacer(),
                Row(
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
                          _showConfirmationDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Ajukan',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          children: [
            TextSpan(
              text: value,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Apakah anda yakin semua informasi sudah benar?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Kembali',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Ya',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                String bookingId = await _generateUniqueBookingId();
                await _saveBookingToFirestore(bookingId);
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FifthScreen(
                      service: service,
                      location: location,
                      bookingId: bookingId,
                      contactPreference: contactPreference,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> _generateUniqueBookingId() async {
    const chars = '0123456789ABCDEF';
    Random rnd = Random();
    String bookingId;
    bool exists;
    do {
      bookingId = String.fromCharCodes(Iterable.generate(
        8,
        (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
      ));
      exists = await _checkBookingIdExists(bookingId);
    } while (exists);
    return bookingId;
  }

  Future<bool> _checkBookingIdExists(String bookingId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('bookings').doc(bookingId).get();
    return doc.exists;
  }

  Future<void> _saveBookingToFirestore(String bookingId) async {
    CollectionReference bookings = FirebaseFirestore.instance.collection('bookings');
    await bookings.doc(bookingId).set({
      'service': service,
      'location': location,
      'name': name,
      'phone': phone,
      'email': email,
      'contactPreference': contactPreference,
      'carModel': carModel,
      'licensePlate': licensePlate,
      'dealer': dealer,
      'date': date,
      'time': time,
      'notes': notes,
    });
  }
}