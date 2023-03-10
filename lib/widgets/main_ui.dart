import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:registration/constants/routes.dart';
import '../models/note.dart';
import 'dart:developer' as devtools
    show log;

import '../utilities/greeting.dart'; //? log est une alternative a print

/*? on import slmnt log grace a show et specifie ce log 
garce a devtool pour qu'il soit pas melangé avec les autres log */

enum MenuAction {
  addNewNode,
  logout,
}

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
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 50.0),
          child: Text(
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            greeting(),
          ),
        ),
        shadowColor: Colors.lightBlue,
        actions: [
          //? PopupMenuButton
          //? on crée d'abord le MenuAction enum et on l'utilise dans PopMenuButton
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.addNewNode:
                  return _startAddNewNode(context);
                case MenuAction.logout:
                  final shouldLogout = await showAlertDialog(context);
                  devtools.log(shouldLogout.toString());
                  if (shouldLogout) {
                    //? en cas de deconnexion
                    await FirebaseAuth.instance.signOut();
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
                  child: Text('Add Node'),
                ),
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: const [
        Text(
          'Recent Notes',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ]),
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
            child: const Text('Cancel'),
          ),

          // Confirme logout
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Sign Out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
