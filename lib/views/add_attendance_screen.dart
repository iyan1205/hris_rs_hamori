import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris_rs_hamori/controllers/attendance_controller.dart';
import 'package:hris_rs_hamori/theme.dart';

class AddAttendanceScreen extends StatelessWidget {
  final AttendanceController controller = Get.put(AttendanceController());

  AddAttendanceScreen({super.key});

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
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  // Add your refresh logic here
                  controller.fetchAttendanceData();
                },
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEmployeeInfo(),
              const SizedBox(height: 10),
              _buildAttendanceCount(),
              const SizedBox(height: 30),
              _buildImagePicker(),
              const SizedBox(height: 20),
              _buildCheckButton(),
            ],
          ),
        );
      }),
      backgroundColor: hamoriWhite,
    );
  }

  Widget _buildEmployeeInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(controller.employeeInfo['name'] ?? '',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(controller.employeeInfo['position'] ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(controller.employeeInfo['nik'] ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildAttendanceCount() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              '${[
                'Senin',
                'Selasa',
                'Rabu',
                'Kamis',
                'Jumat',
                'Sabtu',
                'Minggu'
              ][DateTime.now().weekday - 1]}, ${DateTime.now().day} ${[
                'Januari',
                'Februari',
                'Maret',
                'April',
                'Mei',
                'Juni',
                'Juli',
                'Agustus',
                'September',
                'Oktober',
                'November',
                'Desember'
              ][DateTime.now().month - 1]} ${DateTime.now().year}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(),
          Text(
            'Total Kehadiran Aktif: ${controller.totalAttendance}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Jam Check In: ${controller.jamMasuk()}',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'Total Jam Kerja: ${controller.getTotalHours()}',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        Obx(() {
          if (controller.selectedImage.value != null) {
            return Container(
              height: 270,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: FileImage(controller.selectedImage.value!),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }
          return Container(
            height: 270,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Text('No Image Selected')),
          );
        }),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: controller.pickImage,
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

  Widget _buildCheckButton() {
    return Obx(() {
      if (controller.isProcessing.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return SizedBox(
        width: double.infinity, // Tombol sepanjang layar
        child: ElevatedButton(
          onPressed: controller.isCheckedIn.value
              ? controller.checkOut
              : controller.checkIn,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                controller.isCheckedIn.value ? Colors.orange : Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          child: Text(
            controller.isCheckedIn.value ? 'CHECK-OUT' : 'CHECK-IN',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }
}
