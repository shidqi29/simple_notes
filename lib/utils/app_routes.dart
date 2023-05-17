import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_notes/pages/add_note_page.dart';
import '../pages/home_page.dart';

class AppRoutes {
  static const home = 'home';
  static const addNote = 'add-note';

  static Page _homePageBuilder(
    BuildContext context,
    GoRouterState state,
  ) {
    return const MaterialPage(child: HomePage());
  }

  static Page _addNotePageBuilder(
    BuildContext context,
    GoRouterState state,
  ) {
    return const MaterialPage(child: AddNotePage());
  }

  static GoRouter goRouter = GoRouter(routes: [
    GoRoute(path: '/', name: home, pageBuilder: _homePageBuilder, routes: [
      GoRoute(
        path: 'add-note',
        name: addNote,
        pageBuilder: _addNotePageBuilder,
      )
    ]),
  ]);
}
