import 'package:flutter/material.dart';
import 'package:friendly_chat/chat_screen/chat_screen.dart';

import 'chat_message.dart';

class MessagesList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList>
    with TickerProviderStateMixin {
  final List<ChatMessage> _chatMessages = List();

  @override
  Widget build(BuildContext context) {
    Stream<List<String>> messages =
        ChatMessagesProvider.of(context).messagesBloc.messages;

    return Flexible(
      // TODO BONUS make infinite and fetching as scroll
      child: StreamBuilder<List<String>>(
        stream: messages,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          insertNewMessages(snapshot.data);
          beginAnimationOfNewestMessage();

          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (_, int index) => _chatMessages[index],
            itemCount: _chatMessages.length,
          );
        },
      ),
    );
  }

  void insertNewMessages(List<String> newMessages) {
    final initialLength = _chatMessages.length;
    final newChatMessages = newMessages
        .getRange(0, newMessages.length - initialLength)
        .map((e) => ChatMessage(
              text: e,
              animationController: AnimationController(
                duration: Duration(milliseconds: 700),
                vsync: this,
              ),
            ));

    _chatMessages.insertAll(0, newChatMessages);
  }

  void beginAnimationOfNewestMessage() {
    if (_chatMessages.isNotEmpty)
      _chatMessages[0].animationController.forward();
  }

  @override
  void dispose() {
    for (ChatMessage message in _chatMessages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
