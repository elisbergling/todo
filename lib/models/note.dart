import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 1)
class Note {
  @HiveField(0)
  String title;
  @HiveField(1)
  String description;
  @HiveField(2)
  String id;
  @HiveField(3)
  int index;
  @HiveField(4)
  int color;

  Note({
    this.title,
    this.description,
    this.id,
    this.index,
    this.color,
  });
}
