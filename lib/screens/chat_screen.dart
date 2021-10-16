import 'package:chat_app/widgets/chats/messages.dart';
import 'package:chat_app/widgets/chats/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> _firebaseMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.notification}');
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();

    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();

    FirebaseMessaging.onMessage.listen((event) {
      print(event.data);
      print('Notification received');
      if (event.notification != null) {
        print(
            'Message also contained a notification: ${event.notification!.body}');
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('Message Clicked!');
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessageHandler);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
        actions: <Widget>[
          DropdownButton(
            underline: Container(),
            items: [
              DropdownMenuItem(
                child: Row(
                  children: const [
                    Icon(Icons.exit_to_app),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Logout')
                  ],
                ),
                value: 'Logout',
              )
            ],
            onChanged: (itemIdentifier) {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage()
          ],
        ),
      ),
    );
  }
}
