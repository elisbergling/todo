import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
  await Hive.openBox<int>(MyStrings.settings);
  await Hive.openBox<Note>(MyStrings.notes);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = useProvider(hiveSettingsProvider);
    final colorListenable = useValueListenable(
            settings.getSettings()?.listenable() as ValueListenable)
        .get(MyStrings.color);
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
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.white),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.error),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.error),
          ),
          labelStyle: const TextStyle(color: MyColors.white),
          helperStyle: const TextStyle(color: MyColors.white),
        ),
        scaffoldBackgroundColor: MyColors.darkest,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}
