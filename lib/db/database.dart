import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:taskify/db/list_items.dart';

part 'database.g.dart'; // Required for generated code

@DriftDatabase(tables: [ListItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Fetch all notes
  Future<List<ListItem>> getAllNotes() => select(listItems).get();

  // Insert a note
  Future<int> insertNote(ListItemsCompanion note) =>
      into(listItems).insert(note);

  // Delete a note by ID
  Future<int> deleteNote(int id) =>
      (delete(listItems)..where((tbl) => tbl.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'lists.db'));
    return NativeDatabase(file);
  });
}
