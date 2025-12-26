import 'package:intl/intl.dart';

class ClassSession {
  String id;
  String subjectId;
  String subjectName;
  DateTime startTime;
  DateTime endTime;
  String dayOfWeek; // Monday, Tuesday, etc.

  ClassSession({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    required this.startTime,
    required this.endTime,
    required this.dayOfWeek,
  });

  bool isCurrent(DateTime now) {
    return now.isAfter(startTime) && now.isBefore(endTime) && dayOfWeek == DateFormat('EEEE').format(now);
  }

  bool isUpcoming(DateTime now) {
    return now.isBefore(startTime) && dayOfWeek == DateFormat('EEEE').format(now);
  }

  Duration timeUntilStart(DateTime now) {
    return startTime.difference(now);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'dayOfWeek': dayOfWeek,
    };
  }

  factory ClassSession.fromMap(Map<String, dynamic> map) {
    return ClassSession(
      id: map['id'],
      subjectId: map['subjectId'],
      subjectName: map['subjectName'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      dayOfWeek: map['dayOfWeek'],
    );
  }
}
