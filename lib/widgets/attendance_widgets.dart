import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hris_rs_hamori/models/response_list_attendance.dart';

class AttendanceList extends StatelessWidget {
  final List<Attendance> attendanceList;

  const AttendanceList({super.key, required this.attendanceList});

  String formatDateTime(DateTime dateTime) {
    DateTime localTime = dateTime.toLocal();
    return DateFormat('dd-MM-yyyy HH:mm:ss').format(localTime);
  }

  String formatDate(DateTime dateTime) {
    DateTime localTime = dateTime.toLocal();
    return DateFormat('dd-MM-yyyy').format(localTime);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: attendanceList.length,
      itemBuilder: (context, index) {
        Attendance attendance = attendanceList[index];

        return AttendanceCard(
          date: formatDate(attendance.createdAt),
          status: attendance.status,
          totalHours: attendance.totalHours,
          inOut:
              '${formatDateTime(attendance.createdAt)} - ${attendance.jamKeluar != null ? formatDateTime(attendance.updatedAt) : "Belum Check Out"}',
        );
      },
    );
  }
}

class AttendanceCard extends StatelessWidget {
  final String date;
  final String status;
  final String totalHours;
  final String inOut;

  const AttendanceCard({
    super.key,
    required this.date,
    required this.status,
    required this.totalHours,
    required this.inOut,
  });

  Color _getStatusColor(String status) {
    return status.toLowerCase() == "hadir" ? Colors.red : Colors.green;
  }

  IconData _getStatusIcon(String status) {
    return status.toLowerCase() == "hadir" ? Icons.error : Icons.check_circle;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    color: Colors.blueAccent,
                  ),
                ),
                Chip(
                  backgroundColor: _getStatusColor(status).withOpacity(0.1),
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(status),
                        color: _getStatusColor(status),
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(status),
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
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
            Text(
              inOut,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
