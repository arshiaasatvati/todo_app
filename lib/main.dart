import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_appp/data/data.dart';
import 'package:todo_appp/data/repo/repository.dart';
import 'package:todo_appp/data/src/hive_task_source.dart';
import 'package:todo_appp/screens/home/home_screen.dart';

const taskBoxName = 'tasks';

const Color primaryContainerColor = Color(0xff5C0AFF);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<Task>(taskBoxName);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: primaryContainerColor),
  );

  runApp(
    ChangeNotifierProvider<Repository<Task>>(
      create: (context) => Repository<Task>(
        localDataSource: HiveTaskDataSource(box: Hive.box(taskBoxName)),
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xff1D2830);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          primaryContainer: primaryContainerColor,
          // ignore: deprecated_member_use
          background: Color(0xffF3F5F8),
          onSurface: primaryTextColor,
          onPrimary: Colors.white,
          // ignore: deprecated_member_use
          onBackground: primaryTextColor,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
