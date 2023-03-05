import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/node.dart';
import './new_node.dart';
import 'dart:developer' as devtools show log; //? log est une alternative a print
/*? on import slmnt log grace a show et specifie ce log 
garce a devtool pour qu'il soit pas melangé avec les autres log */


enum MenuAction {
  addNewNode,
  logout,
}

class MainUi extends StatefulWidget {
  const MainUi({super.key});

  @override
  State<MainUi> createState() => _MainUiState();
}

class _MainUiState extends State<MainUi> {
  List<Note> _userNodes = [];

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
      _userNodes.add(newNd);
    });
  }

  void logout() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.reload();
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 50.0),
          child: Text(
            style: TextStyle(
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
            onSelected: (value) async{
              switch (value) {
                case MenuAction.addNewNode:
                  return _startAddNewNode(context);
                case MenuAction.logout:

                  final shouldLogout = await showAlertDialog(context);
                  devtools.log(shouldLogout.toString());
                  if (shouldLogout){
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
                  }

                  break;
                default:
              }
            },
            itemBuilder: (value) {
              return [
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
          )
        ],
      ),
      body: const Text('data'),
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
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
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
