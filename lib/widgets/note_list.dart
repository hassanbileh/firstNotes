import 'package:flutter/material.dart';

import '../models/note.dart';

class NoteList extends StatelessWidget {
  List<Note> notes = [];
  NoteList(this.notes);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: notes.isEmpty
          ? Container(
              height: 300,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      'No Note added yet',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                        height: 150,
                        child: Image.asset(
                          'lib/images/waiting.png',
                          fit: BoxFit.cover,
                        )),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  elevation: 7,
                  child: Column(
                    children: [
                      const Text(
                        'Recent Notes',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(notes[index].title,),
                              Text(notes[index].text,),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
              itemCount: notes.length,
            ),
    );
  }
}
