import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/add_time_entry_screen.dart';
import 'package:time_tracker/project_task_management_screen.dart';
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
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.entries.length,
            itemBuilder: (context, index) {
              final entry = provider.entries[index];
              return ListTile(
                title: Text('${entry.projectId} - ${entry.totalTime} hours'),
                subtitle:
                    Text('${entry.date.toString()} - Notes: ${entry.notes}'),
                onTap: () {
                  // This could open a detailed view or edit screen
                },
              );
            },
          );
        },
      ),
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
