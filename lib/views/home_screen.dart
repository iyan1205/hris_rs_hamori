import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris_rs_hamori/services/api_service.dart';
import 'package:hris_rs_hamori/models/response_list_attendance.dart';
import 'package:hris_rs_hamori/theme.dart';
import 'package:hris_rs_hamori/utils/storage_helper.dart';
import 'package:hris_rs_hamori/views/add_attendance_screen.dart';
import 'package:hris_rs_hamori/widgets/attendance_widgets.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<List<Attendance>> _fetchAttendance() async {
    return await ApiService.getAttendanceList();
  }

  Future<Map<String, String>> _fetchEmployeeInfo() async {
    return await ApiService.getEmployeeInfo();
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
            title: const Text('HRIS', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () async {
                  await StorageHelper.logout();
                  Get.offAll(() => LoginScreen());
                },
                icon: const Icon(Icons.logout, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _fetchEmployeeInfo(),
        builder: (context, employeeSnapshot) {
          if (employeeSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (employeeSnapshot.hasError ||
              employeeSnapshot.data == null ||
              employeeSnapshot.data!.isEmpty) {
            return const Center(child: Text('Error loading employee data'));
          }

          final employeeData = employeeSnapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian atas dengan background putih
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: null,
                          child: ClipOval(
                            child: Image.network(
                              "${employeeData['image']}?t=${DateTime.now().millisecondsSinceEpoch}",
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.person, size: 30);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              employeeData['name'] ?? '-',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              employeeData['position'] ?? '-',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              employeeData['nik'] ?? '-',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Riwayat Kehadiran',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  color: hamoriWhite,
                  child: FutureBuilder<List<Attendance>>(
                    future: _fetchAttendance(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Text('Error loading data'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No attendance records found.'));
                      }

                      List<Attendance> attendanceList = snapshot.data!;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: AttendanceList(attendanceList: attendanceList),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Stack(
        children: [
          // Background Gradient Full pada Bottom Navigation Bar
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 7, 25, 82), // hamoriNavy
                    Color.fromARGB(255, 8, 131, 149), // hamoriTiel
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          // BottomAppBar dengan transparan agar tidak menghalangi gradient
          BottomAppBar(
            shape: const CircularNotchedRectangle(),
            color: Colors.transparent, // Pastikan transparan
            elevation: 0,
            child: Container(height: 60.0), // Pastikan tingginya sesuai
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: hamoriTiel,
        foregroundColor: Colors.white,
        onPressed: () async {
          bool? result = await Get.to(() => AddAttendanceScreen());
          if (result == true) {
            Get.forceAppUpdate();
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
