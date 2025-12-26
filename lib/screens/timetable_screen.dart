import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/attendance_provider.dart';
import '../models/class_session.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _dayOfWeek;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AttendanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: 'Subject Name'),
                validator: (value) => value!.isEmpty ? 'Please enter subject name' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(_startTime == null ? 'Select Start Time' : 'Start: ${_startTime!.format(context)}'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() => _startTime = time);
                      }
                    },
                    child: const Text('Pick Time'),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(_endTime == null ? 'Select End Time' : 'End: ${_endTime!.format(context)}'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() => _endTime = time);
                      }
                    },
                    child: const Text('Pick Time'),
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                value: _dayOfWeek,
                decoration: const InputDecoration(labelText: 'Day of Week'),
                items: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
                    .map((day) => DropdownMenuItem(value: day, child: Text(day)))
                    .toList(),
                onChanged: (value) => setState(() => _dayOfWeek = value),
                validator: (value) => value == null ? 'Please select a day' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _startTime != null && _endTime != null && _dayOfWeek != null) {
                    final subjectId = provider.subjects.firstWhere((s) => s.name == _subjectController.text).id;
                    final session = ClassSession(
                      id: DateTime.now().toString(),
                      subjectId: subjectId,
                      subjectName: _subjectController.text,
                      startTime: DateTime(2024, 1, 1, _startTime!.hour, _startTime!.minute),
                      endTime: DateTime(2024, 1, 1, _endTime!.hour, _endTime!.minute),
                      dayOfWeek: _dayOfWeek!,
                    );
                    provider.addClassSession(session);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Add Class'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.classSessions.length,
                  itemBuilder: (context, index) {
                    final session = provider.classSessions[index];
                    final dayAbbrev = session.dayOfWeek.substring(0, 3);
                    return ListTile(
                      title: Text(session.subjectName),
                      subtitle: Text('${session.startTime.hour}:${session.startTime.minute.toString().padLeft(2, '0')} - ${session.endTime.hour}:${session.endTime.minute.toString().padLeft(2, '0')} ($dayAbbrev)'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
