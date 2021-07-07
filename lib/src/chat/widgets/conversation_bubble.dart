import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firulapp/src/chat/chat_screen.dart';
import 'package:flutter/material.dart';

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
                              title: Text(
                                widget.name,
                                style: TextStyle(fontSize: 16),
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

class UsersBubble extends StatelessWidget {
  UsersBubble(this.userName, {this.key});

  final Key key;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
          ),
          width: 140,
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // Card(

              //   ),
              //   elevation: 6,
              //   child: Center(
              //     child: ListTile(
              //       title: Text(
              //         userName,
              //       ),
              //       onTap: () {
              //         Navigator.of(context).pushNamed(ChatScreen.routeName);
              //       },
              //       contentPadding: EdgeInsets.symmetric(horizontal: 30),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
