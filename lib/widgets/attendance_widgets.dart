import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hris_rs_hamori/models/response_list_attendance.dart';

class AttendanceList extends StatelessWidget {
  final List<Attendance> attendanceList;

  const AttendanceList({super.key, required this.attendanceList});

  String formatDateTime(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy HH:mm').format(dateTime.toLocal());
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime.toLocal());
  }

  /// Konversi totalHours dari format HH:mm ke jumlah jam dalam angka
  double convertToHours(String totalHours) {
    try {
      List<String> parts = totalHours.split(':');
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      return hours + (minutes / 60); // Menjadikan menit sebagai desimal
    } catch (e) {
      return 0.0; // Jika format salah, default 0.0
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: attendanceList.length,
      itemBuilder: (context, index) {
        Attendance attendance = attendanceList[index];

        // Jika status "pulang", ubah menjadi "HADIR"
        String status = attendance.status.toLowerCase() == "pulang"
            ? "HADIR"
            : attendance.status.toUpperCase();

        // Konversi totalHours ke angka sebelum dibandingkan
        double totalHoursAsNumber = convertToHours(attendance.totalHours);
        bool isOvertime = totalHoursAsNumber > 12;

        // Cek apakah belum check-out
        bool isNotCheckedOut = attendance.jamKeluar == null;

        return AttendanceCard(
          date: formatDate(attendance.createdAt),
          status: status,
          totalHours: attendance.totalHours,
          inOutWidget: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              children: [
                TextSpan(
                  text:
                      formatDateTime(attendance.createdAt), // Tanggal Check-in
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const TextSpan(
                  text: ' - ',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                TextSpan(
                  text: isNotCheckedOut
                      ? 'Belum Check-out'
                      : formatDateTime(attendance
                          .updatedAt), // Tanggal Check-out atau teks "Belum Check-out"
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isNotCheckedOut
                        ? Colors.orange
                        : Colors.black87, // Warna hanya untuk "Belum Check-out"
                  ),
                ),
              ],
            ),
          ),
          isOvertime: isOvertime,
          isNotCheckedOut: isNotCheckedOut,
        );
      },
    );
  }
}

class AttendanceCard extends StatelessWidget {
  final String date;
  final String status;
  final String totalHours;
  final Widget inOutWidget;
  final bool isOvertime;
  final bool isNotCheckedOut;

  const AttendanceCard({
    super.key,
    required this.date,
    required this.status,
    required this.totalHours,
    required this.inOutWidget,
    required this.isOvertime,
    required this.isNotCheckedOut,
  });

  /// Warna status tergantung apakah sudah check-out atau belum
  Color _getStatusColor() {
    if (isNotCheckedOut) return Colors.orange; // Belum check-out (Warna Oranye)
    return status.toLowerCase() == "hadir" ? Colors.green : Colors.red;
  }

  /// Ikon status tergantung apakah sudah check-out atau belum
  IconData _getStatusIcon() {
    if (isNotCheckedOut) return Icons.warning; // Belum check-out (Tanda Seru)
    return status.toLowerCase() == "hadir" ? Icons.check_circle : Icons.error;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tanggal & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text(
                  date,
                  style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  ),
                ),
                Chip(
                  backgroundColor: _getStatusColor().withAlpha(25),
                  label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                    _getStatusIcon(),
                    color: _getStatusColor(),
                    size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(),
                    ),
                    ),
                  ],
                  ),
                  padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Total Jam
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Jam',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  totalHours,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isOvertime ? Colors.red : Colors.black87,
                  ),
                ),
              ],
            ),

            if (isOvertime)
              const Text(
                'Tidak absen pulang',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),

            const SizedBox(height: 8),
            const Divider(),

            // Check In - Check Out
            const Text(
              'Waktu Check In dan Check Out:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            inOutWidget,
          ],
        ),
      ),
    );
  }
}
