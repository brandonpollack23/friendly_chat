import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({
    @required this.text,
    this.name = 'Unknown User',
    this.animationController,
  });

  final String text;
  final String name;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    // To make animations selectable just define an enum and switch on it here.
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _chatAvatar,
            _buildChatNameMessage(context),
          ],
        ),
      ),
    );
  }

  Container get _chatAvatar => Container(
      margin: EdgeInsets.only(right: 16.0),
      child: CircleAvatar(child: Text(name[0])));

  Widget _buildChatNameMessage(BuildContext context) {
    final messageStyle = TextStyle(fontSize: 16.0);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: Theme.of(context).textTheme.headline6),
          Container(
            margin: EdgeInsets.only(top: 5.0),
            child: Text(text, style: messageStyle),
          )
        ],
      ),
    );
  }
}
