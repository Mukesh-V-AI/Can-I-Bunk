import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../providers/attendance_provider.dart';
import '../models/attendance.dart';
import '../models/subject.dart';
import '../models/class_session.dart';
import '../services/notification_service.dart';
import 'dashboard_screen.dart';
import 'timetable_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<AttendanceProvider>(context, listen: false).loadData();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AttendanceProvider>(context);
    final now = DateTime.now();
    final currentClass = provider.getCurrentClass(now);
    final upcomingClass = provider.getUpcomingClass(now);

    // Dark mode first design
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEC4899), Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.school, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text(
              'Can I Bunk?',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard, color: Colors.white70),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DashboardScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.schedule, color: Colors.white70),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TimetableScreen())),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Time Context Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      currentClass != null ? Icons.access_time : Icons.schedule,
                      color: Colors.white70,
                      size: 20,
                    ),
                    
                    const SizedBox(width: 12),
                    Text(
                      currentClass != null ? 'Right now' : 'Next class in ${upcomingClass?.timeUntilStart(now).inMinutes ?? 0} mins',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // DECISION CARD - The Heart of the App
              if (currentClass != null || upcomingClass != null) ...[
                _buildDecisionCard(context, currentClass ?? upcomingClass!, currentClass != null),
              ] else ...[
                // No classes today
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.celebration,
                        color: Color(0xFF10B981),
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No classes today!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enjoy your free time. We\'ll be here when you need us.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDecisionCard(BuildContext context, ClassSession classSession, bool isCurrent) {
    final provider = Provider.of<AttendanceProvider>(context);
    final subject = provider.subjects.firstWhereOrNull((s) => s.id == classSession.subjectId);

    if (subject == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: subject.attendanceStatus == SubjectAttendanceStatus.safe
              ? [const Color(0xFF10B981), const Color(0xFF059669)]
              : subject.attendanceStatus == SubjectAttendanceStatus.borderline
                  ? [const Color(0xFFF59E0B), const Color(0xFFD97706)]
                  : [const Color(0xFFEF4444), const Color(0xFFDC2626)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: subject.statusColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Subject Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.book,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isCurrent ? 'Class in progress' : 'Upcoming class',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Current Attendance - BIG and Readable
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  '${subject.currentAttendancePercentage.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Current Attendance',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Safety Band Visual
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: subject.currentAttendancePercentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Threshold Markers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0%',
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
              ),
              Container(
                width: 2,
                height: 16,
                color: Colors.white.withOpacity(0.8),
              ),
              Text(
                '${subject.minAttendancePercentage.toStringAsFixed(0)}%',
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Container(
                width: 2,
                height: 16,
                color: Colors.white.withOpacity(0.6),
              ),
              Text(
                '100%',
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // DECISION BUTTONS - The Primary Action
          Row(
            children: [
              // ATTEND Button
              Expanded(
                child: GestureDetector(
                  onTap: () => _handleDecision(context, classSession.subjectId, AttendanceStatus.present, subject),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Attend',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // SKIP Button
              Expanded(
                child: GestureDetector(
                  onTap: () => _handleDecision(context, classSession.subjectId, AttendanceStatus.absent, subject),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.cancel,
                          color: Colors.white.withOpacity(0.8),
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Guidance Message
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  subject.safeSkips > 0 ? Icons.lightbulb : Icons.warning,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    subject.getDecisionGuidance(false), // Default to attend guidance
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleDecision(BuildContext context, String subjectId, AttendanceStatus status, Subject subject) {
    final provider = Provider.of<AttendanceProvider>(context, listen: false);
    provider.markAttendance(subjectId, status);

    // Show emotional feedback
    final isSkip = status == AttendanceStatus.absent;
    final message = subject.getDecisionGuidance(isSkip);

    // Show snackbar with emotional copy
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSkip
              ? subject.safeSkips > 0
                  ? "Good call. You've got this under control."
                  : "This one hurts a little. Stay focused for the next ones."
              : "Great choice! Every attendance counts.",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: subject.statusColor,
        duration: const Duration(seconds: 3),
      ),
    );

    // Trigger notification
    NotificationService.showGuidanceNotification('Decision Made', message);
  }

  Widget _buildClassCard(BuildContext context, String title, String subjectName, String time, IconData icon, Color color, List<Widget> actions) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF1E293B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            subjectName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF1E293B),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: actions,
          ),
        ],
      ),
    );
  }

  void _markAttendance(String subjectId, AttendanceStatus status) {
    final provider = Provider.of<AttendanceProvider>(context, listen: false);
    provider.markAttendance(subjectId, status);
    final subject = provider.subjects.firstWhereOrNull((s) => s.id == subjectId);
    if (subject != null) {
      final message = provider.getGuidanceMessage(subject, status == AttendanceStatus.absent);
      NotificationService.showGuidanceNotification('Attendance Decision', message);
    }
  }

  void _showAddSubjectDialog(BuildContext context) {
    final nameController = TextEditingController();
    final percentageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Subject'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Subject Name'),
            ),
            TextField(
              controller: percentageController,
              decoration: const InputDecoration(labelText: 'Min Attendance %'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text;
              final percentage = double.tryParse(percentageController.text) ?? 75.0;
              if (name.isNotEmpty) {
                final provider = Provider.of<AttendanceProvider>(context, listen: false);
                provider.addSubject(Subject(id: DateTime.now().toString(), name: name, minAttendancePercentage: percentage, totalClasses: 60));
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
