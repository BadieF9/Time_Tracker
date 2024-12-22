import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:time_tracker/models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage storage;
  List<TimeEntry> _entries = [];
  List<TimeEntry> get entries => _entries;

  TimeEntryProvider({required this.storage}) {
    _loadTimeEntriesFromStorage();
  }

  void _loadTimeEntriesFromStorage() async {
    var storedEntries = storage.getItem('timeEntries');
    if (storedEntries != null) {
      _entries = List<TimeEntry>.from(
        (jsonDecode(storedEntries) as List)
            .map((item) => TimeEntry.fromJson(item)),
      );
      notifyListeners();
    } else {
      _saveEntriesToStorage();
    }
  }

  void _saveEntriesToStorage() {
    storage.setItem(
        'timeEntries', jsonEncode(_entries.map((e) => e.toJson()).toList()));
  }

  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    _saveEntriesToStorage();
    notifyListeners();
  }

  List<TimeEntry> getEntriesByProjectId(String projectId) {
    return _entries.where((entry) => entry.projectId == projectId).toList();
  }

  void removeTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    _saveEntriesToStorage();
    notifyListeners();
  }
}
