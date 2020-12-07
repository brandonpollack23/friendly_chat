import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friendly_chat/chat_screen/chat_message.dart';

// TODO Bonus add animations with chat bubbles that grow, like iMessage.

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

// TODO seperate this mixin?
class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  // TODO RX change to messges BLoC
  final List<ChatMessage> _messages = [];

  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  bool _isComposing = false;

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
            _messageList,
            Divider(height: 1.0),
            _themedTextComposer(context),
          ],
        ));
  }

  Flexible get _messageList {
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

  Container _themedTextComposer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: _buildTextComposer(),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [_inputFieldBox, _sendButton],
      ),
    );
  }

  Widget get _inputFieldBox {
    return Flexible(
      child: TextField(
        maxLines: null,
        controller: _textController,
        onSubmitted: _handleSubmitted,
        onChanged: (String text) {
          setState(() {
            _isComposing = text.length > 0;
          });
        },
        decoration: InputDecoration.collapsed(hintText: 'Send a message'),
        focusNode: _focusNode,
      ),
    );
  }

  Container get _sendButton {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      // TODO Theming, we'd use a provider or another library to abstract this selection away IRL.
      child: Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoButton(
              child: Text('Send'),
              onPressed: _isComposing
                  ? () => _handleSubmitted(_textController.text)
                  : null,
            )
          : IconButton(
              icon: Icon(Icons.send),
              onPressed: _isComposing
                  ? () => _handleSubmitted(_textController.text)
                  : null,
            ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();

    // TODO RX this would be the Stream to the BLoC in Rx, lets try that and then StreamBuilder
    final message = ChatMessage(
        text: text,
        animationController: AnimationController(
            duration: Duration(milliseconds: 700), vsync: this));

    setState(() {
      _messages.insert(0, message);
      _isComposing = false;
    });

    _focusNode.requestFocus();

    message.animationController.forward();
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();

    super.dispose();
  }
}
