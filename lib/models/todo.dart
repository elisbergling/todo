import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  String title;
  @HiveField(1)
  String description;
  @HiveField(2)
  bool isDone;
  @HiveField(3)
  String id;
  @HiveField(4)
  int index;
  @HiveField(5)
  int color;

  Todo({
    required this.title,
    required this.description,
    required this.isDone,
    required this.id,
    required this.index,
    required this.color,
  });
}
