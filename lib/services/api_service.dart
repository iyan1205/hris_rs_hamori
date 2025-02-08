import 'dart:convert';
import 'package:hris_rs_hamori/models/response_user.dart';
import 'package:http/http.dart' as http;
import 'package:hris_rs_hamori/models/response_login.dart';
import 'package:hris_rs_hamori/models/response_list_attendance.dart';
import 'package:hris_rs_hamori/utils/storage_helper.dart';

class ApiService {
  static const String _baseUrl = 'http://192.168.142.12:8484/api';

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
      // print("Login error: $e");
      return false;
    }
  }

  /// Metode untuk mengambil daftar absensi
  static Future<List<Attendance>> getAttendanceList() async {
    final url = Uri.parse('$_baseUrl/attendance/list');
    final token = await StorageHelper.getToken(); // Ambil token dari storage

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = responseListAttendanceFromJson(response.body);
        return data.attendance;
      } else {
        // print("Failed to fetch attendance: ${response.body}");
        return [];
      }
    } catch (e) {
      //print("Error fetching attendance: $e");
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

        // Pastikan Base URL sesuai dengan path storage Laravel
        String baseUrlImage = "http://192.168.142.12:8484/storage/avatar/";
        String imageUrl = data.image.isNotEmpty
            ? Uri.parse(baseUrlImage + data.image).toString()
            : "http://192.168.142.12:8484/storage/avatar/default.png";

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
        //print("Failed to fetch employee info: ${response.body}");
        return {};
      }
    } catch (e) {
      //print("Error fetching employee info: $e");
      return {};
    }
  }
}
