import 'package:hive/hive.dart';
import 'package:todo/constants/strings.dart';
import 'package:todo/models/note.dart';
import 'package:todo/models/todo.dart';

class HiveNote {
  Box noteBox = Hive.box<Note>(NOTES);

  Box<Note> getNotes() {
    try {
      return noteBox;
    } catch (e) {
      print(e);
      return null;
    }
  }

  List<Note> sortedNotes({
    List<Note> notes,
    String searchText,
  }) {
    try {
      String lowerText = searchText.toLowerCase();
      List<Note> newNotes = notes
          .where((e) =>
              e.description.toLowerCase().contains(lowerText) ||
              e.title.toLowerCase().contains(lowerText))
          .toList();
      newNotes.sort((a, b) => a.index.compareTo(b.index));
      return newNotes;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void updateNotes({int oldIndex, int newIndex, List<Note> notes}) {
    try {
      if (oldIndex < newIndex) {
        notes[oldIndex].index = newIndex - 1;
        noteBox.put(notes[oldIndex].id, notes[oldIndex]);
        for (int i = oldIndex + 1; i < newIndex; i++) {
          notes[i].index = notes[i].index - 1;
          noteBox.put(notes[i].id, notes[i]);
        }
      } else {
        notes[oldIndex].index = newIndex;
        noteBox.put(notes[oldIndex].id, notes[oldIndex]);
        for (int i = newIndex; i < oldIndex; i++) {
          notes[i].index = notes[i].index + 1;
          noteBox.put(notes[i].id, notes[i]);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void makeNote({Note note, bool isNew}) {
    try {
      if (note.title != '' || note.description != '') {
        if (isNew) {
          note.index = noteBox.length;
        }
        noteBox.put(note.id, note);
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteNote({String id}) {
    try {
      noteBox.delete(id);
      Hive.box<Todo>(id).deleteFromDisk();
    } catch (e) {
      print(e);
    }
  }
}
