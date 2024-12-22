import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:time_tracker/models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage storage;
  List<TimeEntry> _entries = [];
  List<TimeEntry> get entries => _entries;

  TimeEntryProvider({required this.storage}) {
    _loadTimeEntriesFromStorage();
    addTimeEntry(TimeEntry(
        id: "1",
        projectId: "1",
        taskId: "1",
        totalTime: 1,
        date: DateTime.now(),
        notes: "hello"));
    addTimeEntry(TimeEntry(
        id: "2",
        projectId: "2",
        taskId: "2",
        totalTime: 2,
        date: DateTime.now(),
        notes: "world"));
  }

  void _loadTimeEntriesFromStorage() async {
    var storedEntries = storage.getItem('timeEntries');
    if (storedEntries != null) {
      _entries = List<TimeEntry>.from(
        (storedEntries as List).map((item) => TimeEntry.fromJson(item)),
      );
      notifyListeners();
    }
  }

  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  List<TimeEntry> getEntriesByProjectId(String projectId) {
    return _entries.where((entry) => entry.projectId == projectId).toList();
  }

  void removeTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    notifyListeners();
  }
}
