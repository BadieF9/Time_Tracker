import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/models/project.dart';
import 'package:time_tracker/models/task.dart';
import 'package:time_tracker/providers/project_task_provider.dart';
import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  final TimeEntry? timeEntry;
  const AddTimeEntryScreen({super.key, this.timeEntry});

  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? projectId;
  String? taskId;
  double totalTime = 0.0;
  DateTime date = DateTime.now();
  String notes = '';

  @override
  void initState() {
    if (widget.timeEntry != null) {
      projectId = widget.timeEntry!.projectId;
      taskId = widget.timeEntry!.taskId;
      totalTime = widget.timeEntry!.totalTime;
      date = widget.timeEntry!.date;
      notes = widget.timeEntry!.notes;
    }
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date, // Start with current date
      firstDate: DateTime(1900), // Earliest allowed date
      lastDate: DateTime(2100), // Latest allowed date
      helpText: 'Select expense date', // Customize the help text
      cancelText: 'Not now',
      confirmText: 'Select',
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

  void _saveEntry(BuildContext context, String? id) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Provider.of<TimeEntryProvider>(context, listen: false)
          .addOrUpdateEntry(TimeEntry(
        id: widget.timeEntry?.id ??
            DateTime.now()
                .millisecondsSinceEpoch
                .toString(), // Simple ID generation
        projectId: projectId!,
        taskId: taskId!,
        totalTime: totalTime,
        date: date,
        notes: notes,
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProjectTaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Time Entry'),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DropdownButtonFormField<String>(
                  onChanged: (String? newValue) {
                    setState(() {
                      projectId = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: "Project", border: InputBorder.none),
                  icon: const SizedBox.shrink(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Select a Project';
                    }
                    return null;
                  },
                  items: provider.projects
                      .map<DropdownMenuItem<String>>((Project project) {
                    return DropdownMenuItem<String>(
                      value: project.id,
                      child: Text(project.name),
                    );
                  }).toList(),
                  value: projectId,
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  onChanged: (String? newValue) {
                    setState(() {
                      taskId = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: "Task", border: InputBorder.none),
                  icon: const SizedBox.shrink(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Select a Task';
                    }
                    return null;
                  },
                  items:
                      provider.tasks.map<DropdownMenuItem<String>>((Task task) {
                    return DropdownMenuItem<String>(
                      value: task.id,
                      child: Text(task.name),
                    );
                  }).toList(),
                  value: taskId,
                ),
                const SizedBox(height: 15),
                Text(
                  'Date: ${DateFormat('yyyy-MM-dd').format(date)}',
                  style: const TextStyle(fontSize: 18),
                ),
                ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Select Date')),
                const SizedBox(height: 15),
                TextFormField(
                  initialValue: totalTime.toString(),
                  decoration: const InputDecoration(
                      labelText: 'Total Time (hours)',
                      border: InputBorder.none),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter total time';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) => totalTime = double.parse(value!),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  initialValue: notes,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some notes';
                    }
                    return null;
                  },
                  onSaved: (value) => notes = value!,
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () => _saveEntry(context, widget.timeEntry?.id),
                  child: const Text('Save the Entry'),
                )
              ],
            ),
          )),
    );
  }
}
