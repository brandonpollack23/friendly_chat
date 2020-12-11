import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:friendly_chat/blocs/chat_messages_bloc.dart';
import 'package:provider/provider.dart';

import 'chat_input.dart';
import 'messages_list.dart';

// TODO Bonus add animations with chat bubbles that grow, like iMessage.

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).friendlyChatAppBar),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: Provider<ChatMessagesBloc>(
        create: (context) => ChatMessagesBloc(),
        dispose: (context, chatMessagesBloc) => chatMessagesBloc.dispose(),
        child: Column(
          children: [
            MessagesList(),
            Divider(height: 1.0),
            ChatInput(
              hintText: AppLocalizations.of(context).defaultMessageHintText,
            ),
          ],
        ),
      ),
    );
  }
}
