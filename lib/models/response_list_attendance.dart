import 'dart:convert';

ResponseListAttendance responseListAttendanceFromJson(String str) =>
    ResponseListAttendance.fromJson(json.decode(str));

String responseListAttendanceToJson(ResponseListAttendance data) =>
    json.encode(data.toJson());

class ResponseListAttendance {
  final List<Attendance> attendance;

  ResponseListAttendance({
    required this.attendance,
  });

  factory ResponseListAttendance.fromJson(Map<String, dynamic> json) =>
      ResponseListAttendance(
        attendance: List<Attendance>.from(
            json["attendance"].map((x) => Attendance.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "attendance": List<dynamic>.from(attendance.map((x) => x.toJson())),
      };
}

class Attendance {
  final int id;
  final String userId;
  final String jamMasuk;
  final String fotoJamMasuk;
  final String? jamKeluar;
  final String? fotoJamKeluar;
  final String status;
  final String? ipAddress;
  final String? deviceInfo;
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

  factory Attendance.fromJson(Map<String, dynamic> json) {
    DateTime created = DateTime.parse(json["created_at"]).toLocal();
    DateTime updated = DateTime.parse(json["updated_at"]).toLocal();

    return Attendance(
      id: json["id"],
      userId: json["user_id"],
      jamMasuk: json["jam_masuk"],
      fotoJamMasuk: json["foto_jam_masuk"],
      jamKeluar: json["jam_keluar"],
      fotoJamKeluar: json["foto_jam_keluar"],
      status: json["status"],
      ipAddress: json["ip_address"],
      deviceInfo: json["device_info"],
      createdAt: created,
      updatedAt: updated,
    );
  }

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

  /// Menghitung total jam kerja dalam format HH:mm
  String get totalHours {
    Duration duration = updatedAt.difference(createdAt);
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}
