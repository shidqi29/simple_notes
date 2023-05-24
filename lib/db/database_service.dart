import 'package:hive/hive.dart';
import 'package:simple_notes/models/note.dart';

class DatabaseService{
  static const String boxName = 'notes';

  Future<void> addNote(Note note) async{
    final box = await Hive.openBox(boxName);
    await box.add(note);
  }
  Future<List<Note>> getNote(Note note) async{
    final box = await Hive.openBox(boxName);
    return await box.get(note.key).toList().cast<Note>();
  }
  Future<void> editNote(Note note) async{
    final box = await Hive.openBox(boxName);
    await box.put(note.key, note);
  }
  Future<void> deleteNote(Note note) async{
    final box = await Hive.openBox(boxName);
    box.delete(note.key);
  }
}