import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris_rs_hamori/controllers/home_controller.dart';
import 'package:hris_rs_hamori/theme.dart';
import 'package:hris_rs_hamori/utils/storage_helper.dart';
import 'package:hris_rs_hamori/views/add_attendance_screen.dart';
import 'package:hris_rs_hamori/widgets/attendance_widgets.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null && Get.arguments['message'] != null) {
        Get.snackbar("Success", Get.arguments['message'],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: hamoriLightTiel,
            colorText: Colors.white);
      }
    });

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
              IconButton(
                onPressed: () {
                  homeController.fetchData();
                },
                icon: const Icon(Icons.refresh, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (homeController.errorMessage.isNotEmpty) {
          return Center(child: Text(homeController.errorMessage.value));
        }

        final employeeData = homeController.employeeData;
        final attendanceList = homeController.attendanceList;

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
                            loadingBuilder: (context, child, loadingProgress) {
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
                  const Text(
                    'Riwayat Kehadiran',
                    style: TextStyle(
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
                child: attendanceList.isEmpty
                    ? const Center(child: Text('No attendance records found.'))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: AttendanceList(attendanceList: attendanceList),
                      ),
              ),
            ),
          ],
        );
      }),
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
            homeController.fetchData();
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
