import 'dart:developer' as devtools show log;

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/services/crud/notes_service.dart';
import 'package:my_notes/utilities/dialogs/logout_dialog.dart';
import 'package:my_notes/views/notes/notes_list_view.dart';
import '../../enum/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;

  String get userEmail => AuthService.firebase()
      .currentUser!
      .email!; // Read current user email in note_view
  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  // @override
  // void dispose() {
  //   _notesService.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your notes UI"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialog(context);
                  if (shouldLogOut) {
                    // await FirebaseAuth.instance.signOut(); // these for firebase
                    await AuthService.firebase()
                        .logOut(); // these for AuthService
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login/', (_) => false);
                  } else {
                    devtools.log(shouldLogOut.toString());
                  }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('logout'),
                ),
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              // return const Text('Your notes will appear here');
              return StreamBuilder(
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as List<DatabaseNote>;
                        return NotesListView(
                          notes: allNotes,
                          onDeleteNote: (note) async{
                            await _notesService.deleteNote(id: note.id);
                          },
                          onTap: (note){
                            Navigator.of(context).pushNamed(createOrUpdateNoteRoute, arguments:note);
                          },
                        );
                        // here from now we are building tile to show our note
                        // return ListView.builder(
                        //   itemCount: allNotes.length,
                        //   itemBuilder: (context, index) {
                        //     final note = allNotes[index];
                        //     return ListTile(
                        //       title: Text(
                        //         note.text,
                        //         maxLines: 1,
                        //         softWrap: true,
                        //       overflow: TextOverflow.ellipsis,
                        //       ),
                        //     );
                        //   },
                        // );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    default:
                      return const CircularProgressIndicator();
                  }
                },
                stream: _notesService.allNotes,
              );
              break;
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
//
// Future<bool> showLogOutDialog(BuildContext context) {
//   return showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Sign Out'),
//           content: const Text('Are you sure You want to Log out?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(true);
//               },
//               child: const Text('Log Out'),
//             ),
//           ],
//         );
//       }).then((value) => value ?? false);
// }
