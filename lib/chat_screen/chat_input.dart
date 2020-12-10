import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:friendly_chat/blocs/chat_messages_bloc.dart';
import 'package:friendly_chat/chat_screen/chat_screen.dart';

class ChatInput extends StatefulWidget {
  final hintText;

  ChatInput({this.hintText = 'Send a message'});

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

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
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.send,
                controller: _textController,
                onSubmitted: _handleSubmitted,
                onChanged: (_) => _chatMessagesBloc.composing.add(true),
                decoration:
                    InputDecoration.collapsed(hintText: widget.hintText),
                focusNode: _focusNode,
              ),
            ),
            // TODO fix stream already listened to on hot reload.
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              // TODO Theming, we'd use a provider or another library to abstract this selection away IRL.
              child: StreamBuilder(
                stream: _chatMessagesBloc.isComposing,
                builder: _buildSendButton,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton(context, snapshot) {
    bool isComposing = snapshot.hasData && snapshot.data;
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoButton(
            child: Text('Send'),
            onPressed: isComposing
                ? () => _handleSubmitted(_textController.text)
                : null,
          )
        : IconButton(
            icon: Icon(Icons.send),
            onPressed: isComposing
                ? () => _handleSubmitted(_textController.text)
                : null,
          );
  }

  void _handleSubmitted(String text) {
    // Clear text in box.
    _textController.clear();

    // Notify message has been created.
    _chatMessagesBloc.addMessage.add(text);

    // Notify no longer composing message.
    _chatMessagesBloc.composing.add(false);

    _focusNode.requestFocus();
  }
}
