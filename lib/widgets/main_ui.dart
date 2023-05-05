import 'package:flutter/material.dart';
import 'package:registration/constants/routes.dart';
import 'package:registration/enums/menu_action.dart';
import 'package:registration/services/auth/auth_services.dart';
import '../models/note.dart';
import 'dart:developer' as devtools show log;

import '../utilities/greeting.dart'; //? log est une alternative a print

/*? on import slmnt log grace a show et specifie ce log 
garce a devtool pour qu'il soit pas melangé avec les autres log */

class MainUi extends StatefulWidget {
  const MainUi();

  @override
  State<MainUi> createState() => _MainUiState();
}

class _MainUiState extends State<MainUi> {
  //Liste des Notes
  final List<Note> _userNotes = [];

  void _startAddNewNode(BuildContext ctx) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/note_content',
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        backgroundColor: Colors.grey.withOpacity(0.5),
        title: Text(greeting()),
        actions: [
          //? PopupMenuButton
          //? on crée d'abord le MenuAction enum et on l'utilise dans PopMenuButton
          PopupMenuButton<MenuAction>(
            color: Colors.black.withOpacity(0.5),
            onSelected: (value) async {
              switch (value) {
                case MenuAction.addNewNode:
                  return _startAddNewNode(context);
                case MenuAction.logout:
                  final shouldLogout = await showAlertDialog(context);
                  devtools.log(shouldLogout.toString());
                  if (shouldLogout) {
                    //? en cas de deconnexion
                    await AuthService.firebase().logout();
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
                  value: MenuAction.addNewNode,
                  child: Text(
                    'Add Node',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text(
                    'Log out',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Recent Notes',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          (_userNotes.isEmpty)
              ? Center(
                  child: SizedBox(
                    child: Image.asset('lib/assets/images/waiting.png'),
                    height: 300.0,
                    width: 200.0,
                  ),
                )
              : const Text('There is some notes')
        ],
      ),
    );
  }
}

//! Future de AlertDialog pour la deconnexion

Future<bool> showAlertDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(10),
        ),
        content: const Text('Are you sure to logout'),
        actions: [
          // Cancel logout
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.blueGrey),
            ),
          ),

          // Confirme logout
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.blueGrey),
            ),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
