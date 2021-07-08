import 'package:firulapp/constants/constants.dart';
import 'package:firulapp/src/chat/widgets/messages.dart';
import 'package:firulapp/src/chat/widgets/new_message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = "/chat";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.kSecondaryColor,
        title: Text('Firulapp Chat', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
