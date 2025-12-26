import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'dart:convert';
import '../models/subject.dart';
import '../models/attendance.dart';
import '../models/class_session.dart';
import 'package:collection/collection.dart';

class AttendanceProvider with ChangeNotifier {
  List<Subject> _subjects = [];
  List<AttendanceRecord> _attendanceRecords = [];
  List<ClassSession> _classSessions = [];
  bool _isSynced = false;

  List<Subject> get subjects => _subjects;
  List<AttendanceRecord> get attendanceRecords => _attendanceRecords;
  List<ClassSession> get classSessions => _classSessions;
  bool get isSynced => _isSynced;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Load data from local storage
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsJson = prefs.getStringList('subjects') ?? [];
    _subjects = subjectsJson.map((json) => Subject.fromMap(jsonDecode(json))).toList();

    final attendanceJson = prefs.getStringList('attendance') ?? [];
    _attendanceRecords = attendanceJson.map((json) => AttendanceRecord.fromMap(jsonDecode(json))).toList();

    final sessionsJson = prefs.getStringList('classSessions') ?? [];
    _classSessions = sessionsJson.map((json) => ClassSession.fromMap(jsonDecode(json))).toList();

    // Initialize timetable if empty
    if (_subjects.isEmpty && _classSessions.isEmpty) {
      _initializeTimetable();
    }

    notifyListeners();
  }

  // Save data to local storage
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final subjectsJson = _subjects.map((s) => jsonEncode(s.toMap())).toList();
    await prefs.setStringList('subjects', subjectsJson);

    final attendanceJson = _attendanceRecords.map((a) => jsonEncode(a.toMap())).toList();
    await prefs.setStringList('attendance', attendanceJson);

    final sessionsJson = _classSessions.map((s) => jsonEncode(s.toMap())).toList();
    await prefs.setStringList('classSessions', sessionsJson);
  }

  // Initialize default timetable
  void _initializeTimetable() {
    // Default subjects
    _subjects = [
      Subject(id: 'cv', name: 'Computer Vision', minAttendancePercentage: 75.0, totalClasses: 60),
      Subject(id: 'dl', name: 'Deep Learning', minAttendancePercentage: 75.0, totalClasses: 60),
      Subject(id: 'pe', name: 'Prompt engineering', minAttendancePercentage: 75.0, totalClasses: 60),
      Subject(id: 'cc', name: 'Content Creation', minAttendancePercentage: 75.0, totalClasses: 60),
      Subject(id: 'apc', name: 'Association/Placement/Career Guidance', minAttendancePercentage: 75.0, totalClasses: 60),
      Subject(id: 'cv_lab', name: 'Computer Vision Lab', minAttendancePercentage: 75.0, totalClasses: 60),
    ];

    // Monday
    _classSessions.add(ClassSession(
      id: 'mon_cv',
      subjectId: 'cv',
      subjectName: 'Computer Vision',
      startTime: DateTime(2024, 1, 1, 9, 0),
      endTime: DateTime(2024, 1, 1, 10, 0),
      dayOfWeek: 'Monday',
    ));
    _classSessions.add(ClassSession(
      id: 'mon_pe',
      subjectId: 'pe',
      subjectName: 'Prompt engineering',
      startTime: DateTime(2024, 1, 1, 10, 0),
      endTime: DateTime(2024, 1, 1, 11, 0),
      dayOfWeek: 'Monday',
    ));

    // Tuesday
    _classSessions.add(ClassSession(
      id: 'tue_dl',
      subjectId: 'dl',
      subjectName: 'Deep Learning',
      startTime: DateTime(2024, 1, 1, 9, 0),
      endTime: DateTime(2024, 1, 1, 10, 0),
      dayOfWeek: 'Tuesday',
    ));
    _classSessions.add(ClassSession(
      id: 'tue_cc',
      subjectId: 'cc',
      subjectName: 'Content Creation',
      startTime: DateTime(2024, 1, 1, 10, 0),
      endTime: DateTime(2024, 1, 1, 11, 0),
      dayOfWeek: 'Tuesday',
    ));

    // Wednesday
    _classSessions.add(ClassSession(
      id: 'wed_apc',
      subjectId: 'apc',
      subjectName: 'Association/Placement/Career Guidance',
      startTime: DateTime(2024, 1, 1, 9, 0),
      endTime: DateTime(2024, 1, 1, 10, 0),
      dayOfWeek: 'Wednesday',
    ));

    // Thursday
    _classSessions.add(ClassSession(
      id: 'thu_dl',
      subjectId: 'dl',
      subjectName: 'Deep Learning',
      startTime: DateTime(2024, 1, 1, 9, 0),
      endTime: DateTime(2024, 1, 1, 10, 0),
      dayOfWeek: 'Thursday',
    ));
    _classSessions.add(ClassSession(
      id: 'thu_cv_lab',
      subjectId: 'cv_lab',
      subjectName: 'Computer Vision Lab',
      startTime: DateTime(2024, 1, 1, 11, 0),
      endTime: DateTime(2024, 1, 1, 12, 0),
      dayOfWeek: 'Thursday',
    ));

    // Friday
    _classSessions.add(ClassSession(
      id: 'fri_cv',
      subjectId: 'cv',
      subjectName: 'Computer Vision',
      startTime: DateTime(2024, 1, 1, 9, 0),
      endTime: DateTime(2024, 1, 1, 10, 0),
      dayOfWeek: 'Friday',
    ));

    _saveData();
  }

  // Sync with Firebase
  Future<void> syncWithFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = _firestore.collection('users').doc(user.uid);

    try {
      // Sync subjects
      final subjectsSnapshot = await userDoc.collection('subjects').get();
      if (subjectsSnapshot.docs.isNotEmpty) {
        _subjects = subjectsSnapshot.docs
            .map((doc) => Subject.fromMap({...doc.data(), 'id': doc.id}))
            .toList();
      }

      // Sync attendance
      final attendanceSnapshot = await userDoc.collection('attendance').get();
      if (attendanceSnapshot.docs.isNotEmpty) {
        _attendanceRecords = attendanceSnapshot.docs
            .map((doc) => AttendanceRecord.fromMap({...doc.data(), 'id': doc.id}))
            .toList();
      }

      // Sync class sessions
      final sessionsSnapshot = await userDoc.collection('classSessions').get();
      if (sessionsSnapshot.docs.isNotEmpty) {
        _classSessions = sessionsSnapshot.docs
            .map((doc) => ClassSession.fromMap({...doc.data(), 'id': doc.id}))
            .toList();
      }

      await _saveData();
      _isSynced = true;

      // Analytics event
      await _analytics.logEvent(name: 'data_synced');

      notifyListeners();
    } catch (e) {
      print('Sync failed: $e');
    }
  }

  // Add subject
  void addSubject(Subject subject) {
    _subjects.add(subject);
    _saveData();

    // Sync to Firebase
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _firestore
          .collection('users')
          .doc(user.uid)
          .collection('subjects')
          .doc(subject.id)
          .set(subject.toMap());
    }

    // Analytics
    _analytics.logEvent(name: 'subject_added', parameters: {'subject_name': subject.name});

    notifyListeners();
  }

  // Add class session
  void addClassSession(ClassSession session) {
    _classSessions.add(session);
    _saveData();
    notifyListeners();
  }

  // Mark attendance
  void markAttendance(String subjectId, AttendanceStatus status) {
    final subject = _subjects.firstWhere((s) => s.id == subjectId);
    subject.conductedClasses++;
    if (status == AttendanceStatus.present) {
      subject.attendedClasses++;
    }

    final record = AttendanceRecord(
      id: DateTime.now().toString(),
      subjectId: subjectId,
      date: DateTime.now(),
      status: status,
    );
    _attendanceRecords.add(record);

    _saveData();

    // Sync to Firebase
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && record != null) {
      _firestore
          .collection('users')
          .doc(user.uid)
          .collection('attendance')
          .doc(record.id)
          .set(record.toMap());
    }

    // Analytics
    _analytics.logEvent(
      name: 'attendance_marked',
      parameters: {
        'subject_id': subjectId,
        'status': status.toString(),
      },
    );

    notifyListeners();
  }

  // Get current class
  ClassSession? getCurrentClass(DateTime now) {
    return _classSessions.firstWhereOrNull((session) => session.isCurrent(now));
  }

  // Get upcoming class
  ClassSession? getUpcomingClass(DateTime now) {
    final upcoming = _classSessions.where((session) => session.isUpcoming(now)).toList();
    upcoming.sort((a, b) => a.startTime.compareTo(b.startTime));
    return upcoming.isNotEmpty ? upcoming.first : null;
  }

  // Get guidance message
  String getGuidanceMessage(Subject subject, bool willSkip) {
    if (willSkip) {
      if (subject.safeSkips > 0) {
        return "You're safe to skip this one. You can still skip ${subject.safeSkips} more classes.";
      } else {
        return "Better attend this class to stay safe.";
      }
    } else {
      return "Great choice! Attending will help maintain your attendance.";
    }
  }
}
