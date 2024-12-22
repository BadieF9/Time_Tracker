import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:time_tracker/models/project.dart';
import 'package:time_tracker/models/task.dart';

class ProjectTaskProvider with ChangeNotifier {
  final LocalStorage storage;
  List<Project> _projects = [];
  List<Project> get projects => _projects;
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  ProjectTaskProvider({required this.storage}) {
    _loadProjectsFromStorage();
    _loadTasksFromStorage();
  }

  void _loadProjectsFromStorage() async {
    var storedProjects = storage.getItem('projects');
    if (storedProjects != null) {
      _projects = List<Project>.from(
        (jsonDecode(storedProjects) as List)
            .map((item) => Project.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
      notifyListeners();
    } else {
      _saveProjectsToStorage();
    }
  }

  void _saveProjectsToStorage() {
    storage.setItem(
        'projects', jsonEncode(_projects.map((e) => e.toJson()).toList()));
  }

  void addProject(Project project) {
    _projects.add(project);
    _saveProjectsToStorage();
    notifyListeners();
  }

  Project? getProjectById(String id) {
    return _projects.firstWhere((project) => project.id == id);
  }

  void removeProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    _saveProjectsToStorage();
    notifyListeners();
  }

  void _loadTasksFromStorage() async {
    var storedTasks = storage.getItem('tasks');
    if (storedTasks != null) {
      _tasks = List<Task>.from(
        (jsonDecode(storedTasks) as List).map((item) => Task.fromJson(item)),
      );
      notifyListeners();
    } else {
      _saveTasksToStorage();
    }
  }

  void _saveTasksToStorage() {
    storage.setItem(
        'tasks', jsonEncode(_tasks.map((e) => e.toJson()).toList()));
  }

  void addTask(Task task) {
    _tasks.add(task);
    _saveTasksToStorage();
    notifyListeners();
  }

  Task? getTaskById(String id) {
    return _tasks.firstWhere((task) => task.id == id);
  }

  void removeTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveTasksToStorage();
    notifyListeners();
  }
}
