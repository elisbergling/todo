import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/pages/home_screen.dart';
import 'constants/colors.dart';
import 'constants/strings.dart';
import 'models/note.dart';
import 'models/todo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final path = await getApplicationDocumentsDirectory();
  Hive.init(path.path);
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<int>(MyStrings.settings);
  await Hive.openBox<Note>(MyStrings.notes);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Todo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.white),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.error),
          ),
          labelStyle: TextStyle(color: MyColors.white),
          helperStyle: TextStyle(color: MyColors.white),
        ),
        scaffoldBackgroundColor: MyColors.darkest,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}
