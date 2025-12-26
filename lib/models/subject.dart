import 'package:flutter/material.dart';

enum SubjectPriority { core, elective }
enum SubjectAttendanceStatus { safe, borderline, danger }

class Subject {
  String id;
  String name;
  double minAttendancePercentage;
  int totalClasses;
  int attendedClasses;
  int conductedClasses;
  String? facultyName;
  SubjectPriority priority;
  Color? subjectColor;

  Subject({
    required this.id,
    required this.name,
    required this.minAttendancePercentage,
    required this.totalClasses,
    this.attendedClasses = 0,
    this.conductedClasses = 0,
    this.facultyName,
    this.priority = SubjectPriority.core,
    this.subjectColor,
  });

  double get currentAttendancePercentage {
    if (conductedClasses == 0) return 100.0;
    return (attendedClasses / conductedClasses) * 100;
  }

  int get remainingClasses => totalClasses - conductedClasses;

  int get requiredClasses => (totalClasses * minAttendancePercentage / 100).ceil();

  int get safeSkips {
    int remainingRequired = requiredClasses - attendedClasses;
    return remainingClasses - remainingRequired;
  }

  SubjectAttendanceStatus get attendanceStatus {
    double percentage = currentAttendancePercentage;
    if (percentage >= minAttendancePercentage + 5) return SubjectAttendanceStatus.safe;
    if (percentage >= minAttendancePercentage - 2) return SubjectAttendanceStatus.borderline;
    return SubjectAttendanceStatus.danger;
  }

  Color get statusColor {
    switch (attendanceStatus) {
      case SubjectAttendanceStatus.safe:
        return const Color(0xFF10B981); // Green
      case SubjectAttendanceStatus.borderline:
        return const Color(0xFFF59E0B); // Orange
      case SubjectAttendanceStatus.danger:
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF6B7280); // Gray fallback
    }
  }

  String getDecisionGuidance(bool willSkip) {
    if (willSkip) {
      if (safeSkips > 0) {
        return "You're safe to skip this one. You can still skip ${safeSkips} more classes.";
      } else {
        return "Better attend this class to stay safe.";
      }
    } else {
      return "Great choice! Attending will help maintain your attendance.";
    }
  }

  int get classesNeededToRecover {
    if (currentAttendancePercentage >= minAttendancePercentage) return 0;

    int needed = 0;
    int tempAttended = attendedClasses;
    int tempConducted = conductedClasses;

    while (tempConducted > 0 && (tempAttended / tempConducted * 100) < minAttendancePercentage) {
      tempAttended++;
      tempConducted++;
      needed++;
    }

    return needed;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'minAttendancePercentage': minAttendancePercentage,
      'totalClasses': totalClasses,
      'attendedClasses': attendedClasses,
      'conductedClasses': conductedClasses,
      'facultyName': facultyName,
      'priority': priority.toString().split('.').last,
      'subjectColor': subjectColor?.value,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'],
      name: map['name'],
      minAttendancePercentage: map['minAttendancePercentage'],
      totalClasses: map['totalClasses'],
      attendedClasses: map['attendedClasses'] ?? 0,
      conductedClasses: map['conductedClasses'] ?? 0,
      facultyName: map['facultyName'],
      priority: SubjectPriority.values.firstWhere(
        (e) => e.toString().split('.').last == map['priority'],
        orElse: () => SubjectPriority.core,
      ),
      subjectColor: map['subjectColor'] != null ? Color(map['subjectColor']) : null,
    );
  }
}
