import 'package:firebase_auth/firebase_auth.dart';
import 'package:firulapp/constants/constants.dart';
import 'package:firulapp/src/chat/widgets/conversation_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatList extends StatelessWidget {
  static const routeName = "/chat-users";
  @override
  Widget build(BuildContext context) {
    final username = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      backgroundColor: Constants.lightBackgroundColor,
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
              stream: Firestore.instance.collection('users').snapshots(),
              builder: (ctx, chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final usersDocs = chatSnapshot.data.documents;
                var list = [];
                usersDocs.forEach((element) {
                  if (element.data["username"] != username) {
                    list.add(element);
                  }
                });
                return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (ctx, index) => ConversationBubble(
                    list[index]['username'],
                    key: ValueKey(list[index].documentID),
                  ),
                );
              });
        },
      ),
    );
  }
}
