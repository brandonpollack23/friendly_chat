import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friendly_chat/chat_screen/chat_message.dart';

import 'chat_input.dart';
import 'messages_list.dart';

// TODO Bonus add animations with chat bubbles that grow, like iMessage.

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

// TODO seperate this mixin?
class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  // TODO AFTER RX create a custom class that has a max of X messages in memory and stores the "starting" point.
  // Anything outside that can be GC'd or something (WeakReference list of all the data?)
  // This "in memory state" class is actually owned by the BLoC, though, and itemBuilder delegates to it.

  // Consider using a StreamBuilder with initalData being the latest X messages (X = MessageView.size / message.size)
  // or a hasData with a circle loader and the first message has a list of messages.
  final List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FriendlyChat Scaffold Appbar'),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: Column(
          children: [
            MessagesList(messages: _messages),
            Divider(height: 1.0),
            ChatInput(/* TODO change to bloc/stream*/ (ChatMessage message) {
              setState(() {
                _messages.insert(0, message);
              });
            }),
          ],
        ));
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    super.dispose();
  }
}
