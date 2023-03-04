import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/node.dart';
import './new_node.dart';

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
        return NewNode(_addNewNode);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  void _addNewNode(String tlNode, String txNode) {
    final newNd = Note(
      title: tlNode,
      text: txNode,
    );
    setState(() {
      _userNodes.add(newNd);
    });
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
          PopupMenuButton<MenuAction>(
            onSelected: (value) {
              if (value == MenuAction.addNewNode) {
                return _startAddNewNode(context);
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
