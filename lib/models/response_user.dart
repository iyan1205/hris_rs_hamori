// To parse this JSON data, do
//
//     final responseUser = responseUserFromJson(jsonString);

import 'dart:convert';

ResponseUser responseUserFromJson(String str) =>
    ResponseUser.fromJson(json.decode(str));

String responseUserToJson(ResponseUser data) => json.encode(data.toJson());

class ResponseUser {
  final String id;
  final String name;
  final String email;
  final DateTime emailVerifiedAt;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Karyawan karyawan;

  ResponseUser({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.karyawan,
  });

  factory ResponseUser.fromJson(Map<String, dynamic> json) => ResponseUser(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: DateTime.parse(json["email_verified_at"]),
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        karyawan: Karyawan.fromJson(json["karyawan"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt.toIso8601String(),
        "image": image,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "karyawan": karyawan.toJson(),
      };
}

class Karyawan {
  final int id;
  final String userId;
  final String name;
  final String nik;
  final String statusKaryawan;
  final DateTime tglKontrak1;
  final DateTime akhirKontrak1;
  final DateTime tglKontrak2;
  final DateTime akhirKontrak2;
  final String status;
  final dynamic tglResign;
  final dynamic resignId;
  final String nomerKtp;
  final String tempatLahir;
  final DateTime tanggalLahir;
  final String alamatKtp;
  final String gender;
  final String statusKtp;
  final String telepon;
  final String npwp;
  final int departemenId;
  final int jabatanId;
  final int unitId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic tglKontrak3;
  final dynamic akhirKontrak3;
  final dynamic deletedAt;
  final Jabatan jabatan;
  final Departemen departemen;
  final List<Kontrak> kontrak;

  Karyawan({
    required this.id,
    required this.userId,
    required this.name,
    required this.nik,
    required this.statusKaryawan,
    required this.tglKontrak1,
    required this.akhirKontrak1,
    required this.tglKontrak2,
    required this.akhirKontrak2,
    required this.status,
    required this.tglResign,
    required this.resignId,
    required this.nomerKtp,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.alamatKtp,
    required this.gender,
    required this.statusKtp,
    required this.telepon,
    required this.npwp,
    required this.departemenId,
    required this.jabatanId,
    required this.unitId,
    required this.createdAt,
    required this.updatedAt,
    required this.tglKontrak3,
    required this.akhirKontrak3,
    required this.deletedAt,
    required this.jabatan,
    required this.departemen,
    required this.kontrak,
  });

  factory Karyawan.fromJson(Map<String, dynamic> json) => Karyawan(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        nik: json["nik"],
        statusKaryawan: json["status_karyawan"],
        tglKontrak1: DateTime.parse(json["tgl_kontrak1"]),
        akhirKontrak1: DateTime.parse(json["akhir_kontrak1"]),
        tglKontrak2: DateTime.parse(json["tgl_kontrak2"]),
        akhirKontrak2: DateTime.parse(json["akhir_kontrak2"]),
        status: json["status"],
        tglResign: json["tgl_resign"],
        resignId: json["resign_id"],
        nomerKtp: json["nomer_ktp"],
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
        alamatKtp: json["alamat_ktp"],
        gender: json["gender"],
        statusKtp: json["status_ktp"],
        telepon: json["telepon"],
        npwp: json["npwp"],
        departemenId: json["departemen_id"],
        jabatanId: json["jabatan_id"],
        unitId: json["unit_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        tglKontrak3: json["tgl_kontrak3"],
        akhirKontrak3: json["akhir_kontrak3"],
        deletedAt: json["deleted_at"],
        jabatan: Jabatan.fromJson(json["jabatan"]),
        departemen: Departemen.fromJson(json["departemen"]),
        kontrak:
            List<Kontrak>.from(json["kontrak"].map((x) => Kontrak.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "nik": nik,
        "status_karyawan": statusKaryawan,
        "tgl_kontrak1":
            "${tglKontrak1.year.toString().padLeft(4, '0')}-${tglKontrak1.month.toString().padLeft(2, '0')}-${tglKontrak1.day.toString().padLeft(2, '0')}",
        "akhir_kontrak1":
            "${akhirKontrak1.year.toString().padLeft(4, '0')}-${akhirKontrak1.month.toString().padLeft(2, '0')}-${akhirKontrak1.day.toString().padLeft(2, '0')}",
        "tgl_kontrak2":
            "${tglKontrak2.year.toString().padLeft(4, '0')}-${tglKontrak2.month.toString().padLeft(2, '0')}-${tglKontrak2.day.toString().padLeft(2, '0')}",
        "akhir_kontrak2":
            "${akhirKontrak2.year.toString().padLeft(4, '0')}-${akhirKontrak2.month.toString().padLeft(2, '0')}-${akhirKontrak2.day.toString().padLeft(2, '0')}",
        "status": status,
        "tgl_resign": tglResign,
        "resign_id": resignId,
        "nomer_ktp": nomerKtp,
        "tempat_lahir": tempatLahir,
        "tanggal_lahir":
            "${tanggalLahir.year.toString().padLeft(4, '0')}-${tanggalLahir.month.toString().padLeft(2, '0')}-${tanggalLahir.day.toString().padLeft(2, '0')}",
        "alamat_ktp": alamatKtp,
        "gender": gender,
        "status_ktp": statusKtp,
        "telepon": telepon,
        "npwp": npwp,
        "departemen_id": departemenId,
        "jabatan_id": jabatanId,
        "unit_id": unitId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "tgl_kontrak3": tglKontrak3,
        "akhir_kontrak3": akhirKontrak3,
        "deleted_at": deletedAt,
        "jabatan": jabatan.toJson(),
        "departemen": departemen.toJson(),
        "kontrak": List<dynamic>.from(kontrak.map((x) => x.toJson())),
      };
}

class Departemen {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;

  Departemen({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Departemen.fromJson(Map<String, dynamic> json) => Departemen(
        id: json["id"],
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class Jabatan {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int managerId;
  final String level;
  final int levelApprove;
  final dynamic deletedAt;

  Jabatan({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.managerId,
    required this.level,
    required this.levelApprove,
    required this.deletedAt,
  });

  factory Jabatan.fromJson(Map<String, dynamic> json) => Jabatan(
        id: json["id"],
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        managerId: json["manager_id"],
        level: json["level"],
        levelApprove: json["level_approve"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "manager_id": managerId,
        "level": level,
        "level_approve": levelApprove,
        "deleted_at": deletedAt,
      };
}

class Kontrak {
  final int id;
  final int karyawanId;
  final DateTime tanggalMulai;
  final DateTime tanggalSelesai;
  final String deskripsiKontrak;
  final DateTime createdAt;
  final DateTime updatedAt;

  Kontrak({
    required this.id,
    required this.karyawanId,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.deskripsiKontrak,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Kontrak.fromJson(Map<String, dynamic> json) => Kontrak(
        id: json["id"],
        karyawanId: json["karyawan_id"],
        tanggalMulai: DateTime.parse(json["tanggal_mulai"]),
        tanggalSelesai: DateTime.parse(json["tanggal_selesai"]),
        deskripsiKontrak: json["deskripsi_kontrak"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "karyawan_id": karyawanId,
        "tanggal_mulai":
            "${tanggalMulai.year.toString().padLeft(4, '0')}-${tanggalMulai.month.toString().padLeft(2, '0')}-${tanggalMulai.day.toString().padLeft(2, '0')}",
        "tanggal_selesai":
            "${tanggalSelesai.year.toString().padLeft(4, '0')}-${tanggalSelesai.month.toString().padLeft(2, '0')}-${tanggalSelesai.day.toString().padLeft(2, '0')}",
        "deskripsi_kontrak": deskripsiKontrak,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
