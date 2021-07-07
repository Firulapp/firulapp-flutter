import 'package:firulapp/src/chat/chat_screen.dart';
import 'package:flutter/material.dart';

class ConversationBubble extends StatefulWidget {
  ConversationBubble(this.name, {this.key});

  final Key key;
  final String name;
  @override
  _ConversationBubbleState createState() => _ConversationBubbleState();
}

class _ConversationBubbleState extends State<ConversationBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 10,
                          ),
                          child: ListTile(
                              subtitle: Text(""),
                              title: Text(
                                widget.name,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(ChatScreen.routeName);
                              },
                              trailing: Icon(Icons.arrow_forward_ios)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
