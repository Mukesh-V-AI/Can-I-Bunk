import 'package:intl/intl.dart';

enum AttendanceStatus { present, absent, cancelled }

class AttendanceRecord {
  String id;
  String subjectId;
  DateTime date;
  AttendanceStatus status;

  AttendanceRecord({
    required this.id,
    required this.subjectId,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subjectId': subjectId,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'status': status.toString().split('.').last,
    };
  }

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      id: map['id'],
      subjectId: map['subjectId'],
      date: DateFormat('yyyy-MM-dd').parse(map['date']),
      status: AttendanceStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
      ),
    );
  }
}
