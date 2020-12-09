import 'package:flutter/material.dart';

import 'chat_message.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({
    Key key,
    @required List<ChatMessage> messages,
  })  : _messages = messages,
        super(key: key);

  final List<ChatMessage> _messages;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      // TODO BONUS make infinite and fetching as scroll
      child: ListView.builder(
        padding: EdgeInsets.all(8.0),
        reverse: true,
        itemBuilder: (_, int index) => _messages[index],
        itemCount: _messages.length,
      ),
    );
  }
}
