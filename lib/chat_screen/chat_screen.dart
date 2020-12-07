import 'package:flutter/material.dart';
import 'package:friendly_chat/chat_screen/chat_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // TODO RX change to stream
  final List<ChatMessage> _messages = [];
  
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FriendlyChat Scaffold Appbar')),
      body: Column(
        children: [
          _messageList,
          Divider(height: 1.0),
          _themedTextComposer(context),
        ],
      )
    );
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
        children: [
          _inputFieldBox,
          _sendButton
        ],
      ),
    );
  }

  Flexible get _inputFieldBox {
    return Flexible(
          child: TextField(
            controller: _textController,
            onSubmitted: _handleSubmitted,
            decoration: InputDecoration.collapsed(
              hintText: 'Send a message'
            ),
            focusNode: _focusNode,
          ),
        );
  }

  Container get _sendButton {
    return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          child: IconButton(
            icon: Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        );
  }

  void _handleSubmitted(String text) {
    _textController.clear();

    // TODO RX this would be the Stream to the BLoC in Rx, lets try that and then StreamBuilder
    final message = ChatMessage(text: text);
    setState(() {
      _messages.insert(0, message);
    });

    _focusNode.requestFocus();
  }
}
