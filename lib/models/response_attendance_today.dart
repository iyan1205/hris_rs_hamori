// To parse this JSON data, do
//
//     final responseAttendanceToday = responseAttendanceTodayFromJson(jsonString);

import 'dart:convert';

ResponseAttendanceToday responseAttendanceTodayFromJson(String str) =>
    ResponseAttendanceToday.fromJson(json.decode(str));

String responseAttendanceTodayToJson(ResponseAttendanceToday data) =>
    json.encode(data.toJson());

class ResponseAttendanceToday {
  final AttendanceToday attendanceToday;
  final int totalAttendanceToday;

  ResponseAttendanceToday({
    required this.attendanceToday,
    required this.totalAttendanceToday,
  });

  factory ResponseAttendanceToday.fromJson(Map<String, dynamic> json) =>
      ResponseAttendanceToday(
        attendanceToday: AttendanceToday.fromJson(json["attendanceToday"]),
        totalAttendanceToday: json["totalAttendanceToday"],
      );

  Map<String, dynamic> toJson() => {
        "attendanceToday": attendanceToday.toJson(),
        "totalAttendanceToday": totalAttendanceToday,
      };
}

class AttendanceToday {
  int id;
  String userId;
  String jamMasuk;
  String fotoJamMasuk;
  dynamic jamKeluar;
  dynamic fotoJamKeluar;
  String status;
  String ipAddress;
  String deviceInfo;
  DateTime createdAt;
  DateTime updatedAt;

  AttendanceToday({
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

  factory AttendanceToday.fromJson(Map<String, dynamic> json) =>
      AttendanceToday(
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
