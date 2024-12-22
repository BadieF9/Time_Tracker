import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/dialogs/creation_dialog.dart';
import 'package:time_tracker/models/project.dart';
import 'package:time_tracker/models/task.dart';
import '../providers/project_task_provider.dart';

class ProjectTaskManagementScreen<T> extends StatelessWidget {
  final List<T> items;
  const ProjectTaskManagementScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Manage ${T == Project ? 'Projects' : T == Task ? 'Tasks' : ''}'),
      ),
      body: Consumer<ProjectTaskProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(
                      item is Project
                          ? item.name
                          : item is Task
                              ? item.name
                              : '',
                      style: const TextStyle(fontSize: 18)),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      if (item is Project) {
                        provider.removeProject(item.id);
                      } else if (item is Task) {
                        provider.removeTask(item.id);
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (T == Project) {
            _showAddProjectDialog(context);
          } else if (T == Task) {
            _showAddTaskDialog(context);
          }
        },
        tooltip: 'Add ${T == Project ? 'Project' : T == Task ? 'Task' : ''}',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CreationDialog(
          title: 'Add Project',
          content: 'Project Name',
          onCancel: () {
            Navigator.pop(context);
          },
          onConfirm: (GlobalKey<FormState> formKey, String value) {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              final project = Project(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: value,
              );
              Provider.of<ProjectTaskProvider>(context, listen: false)
                  .addProject(project);
              Navigator.pop(context);
            }
          },
          validationErrorMessage: 'Please enter a project name',
        );
      },
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CreationDialog(
          title: 'Add Task',
          content: 'Task Name',
          onCancel: () {
            Navigator.pop(context);
          },
          onConfirm: (GlobalKey<FormState> formKey, String value) {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              final task = Task(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: value,
              );
              Provider.of<ProjectTaskProvider>(context, listen: false)
                  .addTask(task);
              Navigator.pop(context);
            }
          },
          validationErrorMessage: 'Please enter a task name',
        );
      },
    );
  }
}
