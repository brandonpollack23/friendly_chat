import 'package:flutter/material.dart';

import 'chat_screen/chat_screen.dart';

// TODO i18n replace hard coded strings w/ i18n to learn how.  Just use JA and EN

void main() {
  runApp(FriendlyChatApp());
}

class FriendlyChatApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FriendlyChat Title',
      home: ChatScreen()
    );
  }
}

