import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final bool isDone;
  @HiveField(3)
  final String id;

  Todo({
    this.title,
    this.description,
    this.isDone,
    this.id,
  });
}
