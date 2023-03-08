import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/note.dart';
import './new_node.dart';
import 'dart:developer' as devtools show log; //? log est une alternative a print
import 'note_list.dart';
 
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

  // ? Fonction de Greeting par rapport a l'heure
  String _greeting() {
    final hour = TimeOfDay.now().hour;
    if (hour <= 12) {
      return 'Good Morning';
    } else if (hour <= 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  void _startAddNewNode(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewNode(addNewNode);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  void addNewNode(String tlNode, String txNode) {
    final newNd = Note(
      title: tlNode,
      text: txNode,
    );
    setState(() {
      _userNotes.add(newNd);
    });
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
            _greeting(),
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
                    setState(() {
                      Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (_) => false);
                    });
                    
                  }

                  break;
                default:
              }
            },

            // Menu Action builder
            itemBuilder: (value) {
              return [
                //? Popup du menuItem
                 PopupMenuItem<MenuAction>(
                  value: MenuAction.addNewNode,
                  child: Text('Add Node'),
                ),
                 PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
          )
        ],
      ),
      body: Column(children: [
        
        NoteList(_userNotes),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _startAddNewNode(context),
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
