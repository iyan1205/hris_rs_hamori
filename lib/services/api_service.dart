import 'dart:convert';
import 'dart:io';
import 'package:hris_rs_hamori/models/response_attendance_today.dart';
import 'package:hris_rs_hamori/models/response_list_attendance.dart';
import 'package:hris_rs_hamori/models/response_user.dart';
import 'package:http/http.dart' as http;
import 'package:hris_rs_hamori/models/response_login.dart';
import 'package:hris_rs_hamori/utils/storage_helper.dart';

class ApiService {
  static const String _baseUrl = 'http://192.168.10.102:8084/api';

  /// Metode untuk login
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');

    try {
      final response = await http.post(
        url,
        body: jsonEncode({"email": email, "password": password}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = ResponseLogin.fromJson(jsonDecode(response.body));
        await StorageHelper.saveToken(data.data.accessToken);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Metode untuk mengambil daftar absensi dalam 5 hari terakhir
  static Future<List<Attendance>> getAttendanceList() async {
    final url = Uri.parse('$_baseUrl/attendance/list');
    final token = await StorageHelper.getToken();

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        final data = ResponseListAttendance.fromJson(jsonDecode(response.body));
        return data.attendance;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, String>> getEmployeeInfo() async {
    final url = Uri.parse('$_baseUrl/user');
    final token = await StorageHelper.getToken();

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = ResponseUser.fromJson(jsonDecode(response.body));
        final karyawan = data.karyawan;

        String baseUrlImage = "http://192.168.10.102:8084/storage/avatar/";
        String imageUrl = data.image.isNotEmpty
            ? Uri.parse(baseUrlImage + data.image).toString()
            : "http://192.168.10.102:8084/storage/avatar/default.png";

        return {
          "name": karyawan.name,
          "email": data.email,
          "image": imageUrl,
          "position": karyawan.jabatan.name,
          "unit": karyawan.name,
          "department": karyawan.departemen.name,
          "nik": karyawan.nik,
        };
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  static Future<ResponseAttendanceToday> getAttendanceToday() async {
    final url = Uri.parse('$_baseUrl/attendance');
    final token = await StorageHelper.getToken();

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return ResponseAttendanceToday.fromJson(jsonDecode(response.body));
      } else {
        return ResponseAttendanceToday(
          attendanceToday: AttendanceToday(
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
          ),
          totalAttendanceToday: 0,
        );
      }
    } catch (e) {
      return ResponseAttendanceToday(
        attendanceToday: AttendanceToday(
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
        ),
        totalAttendanceToday: 0,
      );
    }
  }

  /// Check-In dengan Foto
  static Future<bool> checkIn(File image) async {
    final url = Uri.parse('$_baseUrl/attendance/check-in');
    final token = await StorageHelper.getToken();

    var request = http.MultipartRequest('POST', url)
      ..headers["Authorization"] = "Bearer $token"
      ..files
          .add(await http.MultipartFile.fromPath('foto_jam_masuk', image.path));

    try {
      final response = await request.send();
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  /// Check-Out dengan Foto
  static Future<bool> checkOut(File image) async {
    final url = Uri.parse('$_baseUrl/attendance/check-out');
    final token = await StorageHelper.getToken();

    var request = http.MultipartRequest('POST', url)
      ..headers["Authorization"] = "Bearer $token"
      ..files.add(
          await http.MultipartFile.fromPath('foto_jam_keluar', image.path));

    try {
      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
