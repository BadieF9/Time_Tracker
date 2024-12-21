import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/add_time_entry_screen.dart';
import 'package:time_tracker/project_task_management_screen.dart';
import 'package:time_tracker/providers/project_task_provider.dart';
import 'providers/time_entry_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> _tabs = [
    const Tab(text: 'All Entries'),
    const Tab(text: 'Grouped by Projects')
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Time Tracking',
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
        ),
      ),
      drawer: Drawer(
        // This is the sidebar
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
                // Header of the sidebar
                decoration: BoxDecoration(
                  color: Colors.teal,
                ),
                child: Center(
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                )),
            ListTile(
              // Item in the sidebar
              leading: const Icon(
                Icons.folder,
                color: Colors.black,
              ),
              title: const Text('Projects'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProjectTaskManagementScreen(),
                  ),
                );
              },
            ),
            ListTile(
              // Item in the sidebar
              leading: const Icon(Icons.assignment, color: Colors.black),
              title: const Text('Tasks'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProjectTaskManagementScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children: const [AllEntriesScreen(), GroupedByProjectsScreen()]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the screen to add a new time entry
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTimeEntryScreen()),
          );
        },
        tooltip: 'Add Time Entry',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AllEntriesScreen extends StatelessWidget {
  const AllEntriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeEntryProvider = Provider.of<TimeEntryProvider>(context);

    return Padding(
        padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
        child: ListView.builder(
          itemCount: timeEntryProvider.entries.length,
          itemBuilder: (context, index) {
            final entry = timeEntryProvider.entries[index];
            return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 15, 4, 15),
                      child: ListTile(
                        title: Text(
                          "Project Gamma - Task A",
                          style: TextStyle(
                            fontSize: 18,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // title: Text(
                        //   '${projectTaskProvider.getProjectById(entry.projectId)?.name} - \$${projectTaskProvider.getTaskById(entry.taskId)?.name}',
                        //   style: const TextStyle(fontSize: 20),
                        // ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Time: ${entry.totalTime} hours',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Date: ${DateFormat('MMM dd, yyyy').format(entry.date)}',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  Text(
                                    'Note: ${entry.notes}',
                                    style: const TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddTimeEntryScreen(timeEntry: entry),
                            ),
                          );
                        },
                      )),
                ));
          },
        ));
  }
}

class GroupedByProjectsScreen extends StatelessWidget {
  const GroupedByProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeEntryProvider>(builder: (context, provider, child) {
      return ListView.builder(
        itemCount: provider.entries.length,
        itemBuilder: (context, index) {
          final entry = provider.entries[index];
          return ListTile(
            title: Text(
              '${entry.projectId} - ${entry.totalTime} hours',
              style: const TextStyle(color: Colors.teal),
            ),
            subtitle: Text('${entry.date.toString()} - Notes: ${entry.notes}'),
            onTap: () {
              // This could open a detailed view or edit screen
            },
          );
        },
      );
    });
  }
}
