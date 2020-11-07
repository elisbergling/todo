import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/pages/home_screen.dart';
import 'package:todo/providers/providers.dart';
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
  await Hive.openBox<int>(SETTINGS);
  await Hive.openBox<Note>(NOTES);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final settings = useProvider(hiveSettingsProvider);
    final colorListenable =
        useValueListenable(settings.getSettings()?.listenable()).get(COLOR);
    return MaterialApp(
      title: 'Todo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          color: Color(colorListenable),
          elevation: 0,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(colorListenable)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: WHITE),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ERROR_COLOR),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ERROR_COLOR),
          ),
          labelStyle: TextStyle(color: WHITE),
          helperStyle: TextStyle(color: WHITE),
        ),
        scaffoldBackgroundColor: DARKEST,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
