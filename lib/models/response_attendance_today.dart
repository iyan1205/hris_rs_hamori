// To parse this JSON data, do
//
//     final responseAttendanceToday = responseAttendanceTodayFromJson(jsonString);

import 'dart:convert';

ResponseAttendanceToday responseAttendanceTodayFromJson(String str) =>
    ResponseAttendanceToday.fromJson(json.decode(str));

String responseAttendanceTodayToJson(ResponseAttendanceToday data) =>
    json.encode(data.toJson());

class ResponseAttendanceToday {
  final Attendance attendance;
  final int totalAttendanceToday;

  ResponseAttendanceToday({
    required this.attendance,
    required this.totalAttendanceToday,
  });

  factory ResponseAttendanceToday.fromJson(Map<String, dynamic> json) =>
      ResponseAttendanceToday(
        attendance: Attendance.fromJson(json["attendance"]),
        totalAttendanceToday: json["totalAttendanceToday"],
      );

  Map<String, dynamic> toJson() => {
        "attendance": attendance.toJson(),
        "totalAttendanceToday": totalAttendanceToday,
      };
}

class Attendance {
  final int id;
  final String userId;
  final String jamMasuk;
  final String fotoJamMasuk;
  final dynamic jamKeluar;
  final dynamic fotoJamKeluar;
  final String status;
  final String ipAddress;
  final String deviceInfo;
  final DateTime createdAt;
  final DateTime updatedAt;

  Attendance({
    required this.id,
    required this.userId,
    required this.jamMasuk,
    required this.fotoJamMasuk,
    required this.jamKeluar,
    required this.fotoJamKeluar,
    required this.status,
    required this.ipAddress,
    required this.deviceInfo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        id: json["id"],
        userId: json["user_id"],
        jamMasuk: json["jam_masuk"],
        fotoJamMasuk: json["foto_jam_masuk"],
        jamKeluar: json["jam_keluar"],
        fotoJamKeluar: json["foto_jam_keluar"],
        status: json["status"],
        ipAddress: json["ip_address"],
        deviceInfo: json["device_info"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "jam_masuk": jamMasuk,
        "foto_jam_masuk": fotoJamMasuk,
        "jam_keluar": jamKeluar,
        "foto_jam_keluar": fotoJamKeluar,
        "status": status,
        "ip_address": ipAddress,
        "device_info": deviceInfo,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
