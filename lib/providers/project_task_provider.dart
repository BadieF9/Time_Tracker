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
    addProject(Project(id: '1', name: 'Project 1'));
    addProject(Project(id: '2', name: 'Project 2'));
    addProject(Project(id: '3', name: 'Project 3'));
    _loadTasksFromStorage();
    addTask(Task(id: '1', name: 'Task 1'));
    addTask(Task(id: '2', name: 'Task 2'));
    addTask(Task(id: '3', name: 'Task 3'));
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

  Project? getProjectById(String id) {
    return _projects.firstWhere((project) => project.id == id);
  }

  void removeProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  Task? getTaskById(String id) {
    return _tasks.firstWhere((task) => task.id == id);
  }

  void removeTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}
