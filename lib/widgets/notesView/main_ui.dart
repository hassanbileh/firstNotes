// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:registration/constants/routes.dart';
import 'package:registration/enums/menu_action.dart';
import 'package:registration/services/auth/auth_services.dart';
import 'package:registration/services/crud/notes_service.dart';
import 'package:registration/widgets/notesView/notes_list.dart';
import 'dart:developer' as devtools show log;//? log est une alternative a print

import '../../utilities/dialogs/logout_dialog.dart';
import '../../constants/greeting.dart'; 

/*? on import slmnt log grace a show et specifie ce log 
garce a devtool pour qu'il soit pas melangé avec les autres log */

class MainUi extends StatefulWidget {
  const MainUi({super.key});

  @override
  State<MainUi> createState() => _MainUiState();
}

class _MainUiState extends State<MainUi> {
  late final NotesServices _notesServices;
  late final user = AuthService.firebase().currentUser!.email;
  String get userEmail => user;

  @override
  void initState() {
    _notesServices = NotesServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(1),
        title: Text(
          greeting(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),

          //? PopupMenuButton
          //? on crée d'abord le MenuAction enum et on l'utilise dans PopMenuButton
          PopupMenuButton<MenuAction>(
            color: Colors.black.withOpacity(0.5),
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  devtools.log(shouldLogout.toString());
                  if (shouldLogout) {
                    //? en cas de deconnexion
                    AuthService.firebase().logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }

                  break;
                default:
              }
            },

            // Menu Action builder
            itemBuilder: (value) {
              return [
                //? Popup du menuItem

                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text(
                    'Log out',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _notesServices.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesServices.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as List<DatabaseNote>;
                        print(allNotes);
                        return NotesList(
                          notes: allNotes,
                          onDeleteNote: (DatabaseNote note) async {
                            await _notesServices.deleteNote(id: note.id);
                          },
                          onTap: (note) {
                            Navigator.of(context).pushNamed(
                              createOrUpdateNoteRoute,
                              arguments: note,
                            );
                          },
                        );
                      } else {
                        return const Text('snapshot has no data');
                      }
                    case ConnectionState.done:
                      return const Text('done');
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
        },
      ),
    );
  }
}

//! Future de AlertDialog pour la deconnexion

// Future<bool> showAlertDialog(BuildContext context) {
//   return showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text('Sign Out'),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadiusDirectional.circular(10),
//         ),
//         content: const Text('Are you sure to logout'),
//         actions: [
//           // Cancel logout
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(false);
//             },
//             child: const Text(
//               'Cancel',
//               style: TextStyle(color: Colors.blueGrey),
//             ),
//           ),

//           // Confirme logout
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(true);
//             },
//             child: const Text(
//               'Sign Out',
//               style: TextStyle(color: Colors.blueGrey),
//             ),
//           ),
//         ],
//       );
//     },
//   ).then((value) => value ?? false);
// }
