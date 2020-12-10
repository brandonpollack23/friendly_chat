import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:friendly_chat/blocs/chat_messages_bloc.dart';
import 'package:friendly_chat/entities/message.dart';
import 'package:friendly_chat/entities/user.dart';
import 'package:provider/provider.dart';

class ChatInput extends StatefulWidget {
  final hintText;

  ChatInput({this.hintText = 'Send a message'});

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  // TODO don't hard code, get from initState fetch from interface(configuration/db)
  final _user = User(
    firstName: "Brandon",
    lastName: "Pollack",
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
                child: Consumer<ChatMessagesBloc>(
              builder: (context, chatMessagesBloc, child) => TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.send,
                controller: _textController,
                onSubmitted: (value) =>
                    _handleSubmitted(chatMessagesBloc, _user, value),
                onChanged: (_) => chatMessagesBloc.composing.add(true),
                decoration:
                    InputDecoration.collapsed(hintText: widget.hintText),
                focusNode: _focusNode,
              ),
            )),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              // TODO Theming, we'd use a provider or another library to abstract this selection away IRL.
              child: Consumer<ChatMessagesBloc>(
                builder: (context, chatMessagesBloc, child) => StreamBuilder(
                  stream: chatMessagesBloc.isComposing,
                  builder: (context, snapshot) =>
                      _buildSendButton(context, snapshot, chatMessagesBloc),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton(context, snapshot, chatMessagesBloc) {
    bool isComposing = snapshot.hasData && snapshot.data;
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoButton(
            child: Text('Send'),
            onPressed: isComposing
                ? () => _handleSubmitted(
                    chatMessagesBloc, _user, _textController.text)
                : null,
          )
        : IconButton(
            icon: Icon(Icons.send),
            onPressed: isComposing
                ? () => _handleSubmitted(
                    chatMessagesBloc, _user, _textController.text)
                : null,
          );
  }

  void _handleSubmitted(
      ChatMessagesBloc chatMessagesBloc, User user, String text) {
    // Clear text in box.
    _textController.clear();

    // Notify message has been created.
    chatMessagesBloc.addMessage.add(
      Message(
        user: user,
        text: text,
      ),
    );

    // Notify no longer composing message.
    chatMessagesBloc.composing.add(false);

    _focusNode.requestFocus();
  }
}
