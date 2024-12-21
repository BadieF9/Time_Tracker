import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/home_screen.dart';
import 'package:time_tracker/providers/project_task_provider.dart';
import 'package:time_tracker/providers/time_entry_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  runApp(MyApp(localStorage: localStorage));
}

class MyApp extends StatelessWidget {
  final LocalStorage localStorage;

  const MyApp({super.key, required this.localStorage});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => TimeEntryProvider(storage: localStorage)),
          ChangeNotifierProvider(
              create: (_) => ProjectTaskProvider(storage: localStorage)),
        ],
        child: MaterialApp(
          title: 'Time Tracker',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            appBarTheme: const AppBarTheme(
                centerTitle: true,
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white),
            tabBarTheme: TabBarTheme(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black54,
              indicator: UnderlineTabIndicator(
                borderSide:
                    BorderSide(width: 4.0, color: Colors.orange.shade200),
              ),
            ),
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        ));
  }
}
