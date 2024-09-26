import 'package:hive/hive.dart';
import 'package:hive_nosql_database/models/notes_model.dart';

class Boxes {
  static Box<NotesModel> getData() => Hive.box<NotesModel>('notes');
}
