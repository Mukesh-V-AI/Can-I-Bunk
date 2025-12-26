import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../providers/attendance_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AttendanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Subjects Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: provider.subjects.length,
                itemBuilder: (context, index) {
                  final subject = provider.subjects[index];
                  return Card(
                    color: subject.statusColor,
                    child: ListTile(
                      title: Text(subject.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Attendance: ${subject.currentAttendancePercentage.toStringAsFixed(1)}%'),
                          Text('Classes: ${subject.attendedClasses}/${subject.totalClasses}'),
                          Text('Safe Skips: ${subject.safeSkips}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text('Recent Attendance History', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: provider.attendanceRecords.length,
                itemBuilder: (context, index) {
                  final record = provider.attendanceRecords[provider.attendanceRecords.length - 1 - index];
                  final subject = provider.subjects.firstWhere((s) => s.id == record.subjectId);
                  return ListTile(
                    title: Text(subject.name),
                    subtitle: Text('${record.date.toString().split(' ')[0]} - ${record.status.name}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
