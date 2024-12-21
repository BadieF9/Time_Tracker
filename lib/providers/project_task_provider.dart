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
        (storedProjects as List).map((item) => Project.fromJson(item)),
      );
      notifyListeners();
    }
  }

  void _loadTasksFromStorage() async {
    var storedTasks = storage.getItem('tasks');
    if (storedTasks != null) {
      _tasks = List<Task>.from(
        (storedTasks as List).map((item) => Task.fromJson(item)),
      );
      notifyListeners();
    }
  }

  void addProject(Project project) {
    _projects.add(project);
    notifyListeners();
  }

  void removeProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}
