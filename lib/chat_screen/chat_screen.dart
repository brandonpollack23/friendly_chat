import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friendly_chat/blocs/chat_messages_bloc.dart';

import 'chat_input.dart';
import 'messages_list.dart';

// TODO Bonus add animations with chat bubbles that grow, like iMessage.

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

// TODO seperate this mixin?
class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  ChatMessagesProvider _chatMessagesProvider;

  @override
  Widget build(BuildContext context) {
    _chatMessagesProvider = ChatMessagesProvider(
      messagesBloc: ChatMessagesBloc(),
      child: Column(
        children: [
          MessagesList(),
          Divider(height: 1.0),
          ChatInput(),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('FriendlyChat Scaffold Appbar'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: _chatMessagesProvider,
    );
  }

  @override
  void dispose() {
    _chatMessagesProvider.dispose();
    super.dispose();
  }
}

class ChatMessagesProvider extends InheritedWidget {
  final ChatMessagesBloc messagesBloc;

  ChatMessagesProvider({@required this.messagesBloc, Widget child})
      : super(child: child);

  static ChatMessagesProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ChatMessagesProvider>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  void dispose() {
    messagesBloc.dispose();
  }
}
