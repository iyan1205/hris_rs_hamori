import 'package:flutter/material.dart';
import 'package:hris_rs_hamori/models/response_attendance_today.dart';
import 'package:hris_rs_hamori/services/api_service.dart';
import 'package:hris_rs_hamori/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddAttendanceScreen extends StatefulWidget {
  const AddAttendanceScreen({super.key});

  @override
  _AddAttendanceScreenState createState() => _AddAttendanceScreenState();
}

class _AddAttendanceScreenState extends State<AddAttendanceScreen> {
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

  Future<Map<String, String>> _fetchEmployeeInfo() async {
    return await ApiService.getEmployeeInfo();
  }

  Future<AttendanceToday> _fetchAttendanceToday() async {
    final response = await ApiService.getAttendanceToday();
    return response.attendanceToday ??
        AttendanceToday(
          id: 0,
          userId: "",
          jamMasuk: "",
          fotoJamMasuk: "",
          jamKeluar: null,
          fotoJamKeluar: null,
          status: "",
          ipAddress: "",
          deviceInfo: "",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
  }

  Future<void> _checkIn() async {
    if (_image == null) {
      _showSnackBar('Silakan ambil foto terlebih dahulu');
      return;
    }
    bool success = await ApiService.checkIn(_image!);
    _showSnackBar(success ? 'Check-In berhasil' : 'Check-In gagal');
    if (success) Navigator.pop(context, true);
  }

  Future<void> _checkOut() async {
    if (_image == null) {
      _showSnackBar('Silakan ambil foto terlebih dahulu');
      return;
    }
    bool success = await ApiService.checkOut(_image!);
    _showSnackBar(success ? 'Check-Out berhasil' : 'Check-Out gagal');
    if (success) Navigator.pop(context, true);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Absensi'),
        backgroundColor: hrisAppBlue,
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _fetchEmployeeInfo(),
        builder: (context, employeeSnapshot) {
          if (employeeSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (employeeSnapshot.hasError || employeeSnapshot.data == null) {
            return const Center(child: Text('Error loading employee data'));
          }

          final employeeData = employeeSnapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama: ${employeeData['name'] ?? '-'}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Jabatan: ${employeeData['position'] ?? '-'}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FutureBuilder<AttendanceToday>(
                  future: _fetchAttendanceToday(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error loading data'));
                    }

                    final attendanceToday = snapshot.data!;
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Absen Hari Ini',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(),
                            Text(
                              'Status: ${attendanceToday.status}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Jam Masuk: ${attendanceToday.jamMasuk ?? '-'}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Jam Keluar: ${attendanceToday.jamKeluar ?? '-'}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            if (attendanceToday.id == 0) ...[
                              _buildImagePicker(),
                              const SizedBox(height: 8),
                              _buildButton(_checkIn, 'Check-In', Colors.green),
                            ] else if (attendanceToday.status == 'hadir') ...[
                              _buildImagePicker(),
                              const SizedBox(height: 8),
                              _buildButton(
                                  _checkOut, 'Check-Out', Colors.orange),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.camera_alt),
          label: const Text('Ambil Foto'),
          style: ElevatedButton.styleFrom(
            backgroundColor: hrisAppBlue,
            foregroundColor: Colors.white,
          ),
        ),
        if (_image != null) ...[
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(_image!, height: 120),
          ),
        ],
      ],
    );
  }

  Widget _buildButton(VoidCallback onPressed, String text, Color color) {
    return ElevatedButton(
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
    );
  }
}
