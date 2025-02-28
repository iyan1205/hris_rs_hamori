import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris_rs_hamori/views/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hris_rs_hamori/services/api_service.dart';
import 'package:hris_rs_hamori/theme.dart';

class AttendanceController extends GetxController {
  var isLoading = false.obs;
  var isCheckedIn = false.obs;
  var totalAttendance = 0.obs;
  var employeeInfo = <String, String>{}.obs;
  var selectedImage = Rx<File?>(null);
  var isProcessing = false.obs;
  var createdAt = DateTime.now().obs;
  var jamMasuk = 'Belum Check In'.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchAttendanceData();
  }

  Future<void> fetchAttendanceData() async {
    try {
      isLoading.value = true;
      var response = await ApiService.getAttendanceToday();
      employeeInfo.value = await ApiService.getEmployeeInfo();
      isCheckedIn.value = response.attendanceToday.id != 0;
      totalAttendance.value = response.totalAttendanceToday;
      createdAt.value = response.attendanceToday.createdAt;
      jamMasuk.value = response.attendanceToday.jamMasuk.isEmpty
          ? 'Belum Check In'
          : response.attendanceToday.jamMasuk;
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil data absensi');
    } finally {
      isLoading.value = false;
    }
  }

  String getTotalHours() {
    final now = DateTime.now();
    final difference = now.difference(createdAt.value);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    return '$hours jam $minutes menit';
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<void> checkIn() async {
    if (selectedImage.value == null) {
      Get.snackbar(
        'Peringatan !',
        '',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.yellow,
        backgroundColor: hamoriLightTiel,
        messageText: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Silakan ambil foto terlebih dahulu',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }
    if (isProcessing.value) return; // Cegah double klik
    isProcessing.value = true;
    bool success = await ApiService.checkIn(selectedImage.value!);
    if (success) {
      isCheckedIn.value = true;
      totalAttendance.value += 1;
      Get.offAll(() => HomeScreen(),
          arguments: {"message": "Check-In berhasil"});
    } else {
      Get.snackbar('Error', 'Check-In gagal');
    }
  }

  Future<void> checkOut() async {
    if (selectedImage.value == null) {
      Get.snackbar(
        'Peringatan !',
        '',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.yellow,
        backgroundColor: hamoriLightTiel,
        messageText: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Silakan ambil foto terlebih dahulu',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }
    if (isProcessing.value) return; // Cegah double klik
    isProcessing.value = true;
    bool success = await ApiService.checkOut(selectedImage.value!);
    if (success) {
      isCheckedIn.value = false;
      Get.offAll(() => HomeScreen(),
          arguments: {"message": "Check-Out berhasil"});
    } else {
      Get.snackbar('Error', 'Check-Out gagal');
    }
    isProcessing.value = false;
  }
}
