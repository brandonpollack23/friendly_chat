import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friendly_chat/blocs/chat_messages_bloc.dart';
import 'package:friendly_chat/chat_screen/chat_screen.dart';

class ChatInput extends StatefulWidget {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  bool _isComposing = false;

  ChatMessagesBloc _chatMessagesBloc;

  @override
  Widget build(BuildContext context) {
    _chatMessagesBloc = ChatMessagesProvider.of(context).messagesBloc;

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                maxLines: null,
                controller: widget._textController,
                onSubmitted: _handleSubmitted,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                decoration:
                    InputDecoration.collapsed(hintText: 'Send a message'),
                focusNode: widget._focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              // TODO Theming, we'd use a provider or another library to abstract this selection away IRL.
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? CupertinoButton(
                      child: Text('Send'),
                      onPressed: _isComposing
                          ? () => _handleSubmitted(widget._textController.text)
                          : null,
                    )
                  : IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _isComposing
                          ? () => _handleSubmitted(widget._textController.text)
                          : null,
                    ),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    widget._textController.clear();

    // TODO RX this would be the Stream to the BLoC in Rx, lets try that and then StreamBuilder
    _chatMessagesBloc.addMessage.add(text);

    setState(() {
      _isComposing = false;
    });

    widget._focusNode.requestFocus();
  }
}
