import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_notes/db/database_service.dart';
import 'package:simple_notes/extensions/format_date.dart';

import '../models/note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseService dbService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Notes'),
        elevation: 0,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box(DatabaseService.boxName).listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text('Tidak Ada Data'),
            );
          } else {
            return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  final note = box.getAt(index);
                  return NoteCard(
                    note: note,
                    databaseService: dbService,
                  );
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).pushNamed('add-note');
        },
        child: const Icon(Icons.note_add_rounded),
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.databaseService,
  });
  final Note note;
  final DatabaseService databaseService;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(note.key.toString()),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          databaseService.deleteNote(note).then(
                (value) => {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.red,
                      content: Text("Catatan Berhasil Dihapus"),
                    ),
                  ),
                },
              );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 3,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.grey[300],
        ),
        child: ListTile(
          title: Text(
            note.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(note.desc),
          trailing: Text('Dibuat pada:\n ${note.createdAt.formatDate()}'),
        ),
      ),
    );
  }
}
