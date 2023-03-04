import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewNode extends StatefulWidget {
  final Function addNoteHandler;
  NewNode(this.addNoteHandler);

  @override
  State<NewNode> createState() => _NewNodeState();
}

class _NewNodeState extends State<NewNode> {
  final titleNode = TextEditingController();
  final textNode = TextEditingController();
  

  void _submitDataNode(){
    final enteredTitle = titleNode.text;
    final enteredText = textNode.text;
    if (enteredTitle.isEmpty || enteredText.isEmpty ){
      return;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
            elevation: 5,
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  // Champs Titre 
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Add Title here',
                      labelText: 'Title Node',
                    ),
                    //onChanged: (value) => titleInput = value,
                    controller: titleNode,
                    onSubmitted: (_) => _submitDataNode(),
                  ),
                  SizedBox(height: 20,),
                  // Champs Amount
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Add node here',
                        labelText: 'Node',
                      ),
                      //onChanged: (value) => amountInput = value,
                      controller: textNode,
                      onSubmitted: (_) => _submitDataNode(),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      expands: true,
                      dragStartBehavior: DragStartBehavior.start,
                    ),
                  ),

                  // Boutton d'Ajout 
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        OutlinedButton(
                          child: Text(
                            'Add Node',
                            style: TextStyle(color: Colors.green),
                          ),
                          onPressed: () => {
                            print(titleNode.text),
                            print(textNode.text),
                            _submitDataNode,
                            
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );;
  }
}