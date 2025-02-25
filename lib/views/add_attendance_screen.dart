import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris_rs_hamori/models/response_attendance_today.dart';
import 'package:hris_rs_hamori/services/api_service.dart';
import 'package:hris_rs_hamori/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddAttendanceScreen extends StatefulWidget {
  const AddAttendanceScreen({super.key});

  @override
  AddAttendanceScreenState createState() => AddAttendanceScreenState();
}

class AddAttendanceScreenState extends State<AddAttendanceScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<Map<String, String>> fetchEmployeeInfo() async {
    return await ApiService.getEmployeeInfo();
  }

  Future<AttendanceToday> _fetchAttendanceToday() async {
    final response = await ApiService.getAttendanceToday();
    return response.attendanceToday;
  }

  Future<int> fetchTotalAttendance() async {
    final response = await ApiService.getAttendanceToday();
    return response.totalAttendanceToday;
  }

  Future<void> _checkIn() async {
    if (_image == null) {
      _showSnackBar('Silakan ambil foto terlebih dahulu', isError: true);
      return;
    }

    bool success = await ApiService.checkIn(_image!);

    if (mounted) {
      _showSnackBar(success ? 'Check-In berhasil' : 'Check-In gagal',
          isError: !success);
      if (success) Navigator.pop(context, true);
    }
  }

  Future<void> _checkOut() async {
    if (_image == null) {
      _showSnackBar('Silakan ambil foto terlebih dahulu', isError: true);
      return;
    }

    bool success = await ApiService.checkOut(_image!);

    if (mounted) {
      _showSnackBar(success ? 'Check-Out berhasil' : 'Check-Out gagal',
          isError: !success);
      if (success) Navigator.pop(context, true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    Get.snackbar(
      isError ? 'Error' : 'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? Colors.red : Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF001F3F), Color(0xFF39CCCC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: const Text('Absensi', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: fetchEmployeeInfo(),
        builder: (context, employeeSnapshot) {
          if (employeeSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (employeeSnapshot.hasError || employeeSnapshot.data == null) {
            return const Center(child: Text('Error loading employee data'));
          }

          final employeeData = employeeSnapshot.data!;

          return FutureBuilder<AttendanceToday>(
            future: _fetchAttendanceToday(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading data'));
              }

              final attendanceToday = snapshot.data!;
              bool isCheckedIn = attendanceToday.id != 0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                employeeData['name'] ?? '',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                employeeData['position'] ?? '',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                employeeData['nik'] ?? '',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<int>(
                    future: fetchTotalAttendance(),
                    builder: (context, totalSnapshot) {
                      if (totalSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (totalSnapshot.hasError) {
                        return const Center(
                            child: Text('Error loading total attendance'));
                      }

                      final totalAttendance = totalSnapshot.data ?? 0;

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Total Kehadiran Aktif: $totalAttendance',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildImagePicker(),
                        const SizedBox(height: 20),
                        _buildButton(
                          isCheckedIn ? _checkOut : _checkIn,
                          isCheckedIn ? 'Check-Out' : 'Check-In',
                          isCheckedIn ? Colors.orange : Colors.green,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      backgroundColor: hamoriWhite,
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        if (_image != null) ...[
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(_image!, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 8),
        ],
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.camera_alt, color: Colors.white),
          label: const Text('Ambil Foto'),
          style: ElevatedButton.styleFrom(
            backgroundColor: hrisAppGrey,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildButton(VoidCallback onPressed, String text, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
