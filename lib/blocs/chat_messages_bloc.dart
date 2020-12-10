import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:friendly_chat/entities/message.dart';
import 'package:friendly_chat/entities/user.dart';
import 'package:rxdart/rxdart.dart';

class ChatMessagesBloc {
  // TODO instead of messages use Entity class that contains user and message.
  final _messages = <Message>[];

  final _addMessageController = StreamController<Message>.broadcast();
  Sink<Message> get addMessage => _addMessageController.sink;

  // BehaviourSubject aka ReplayStream.  A broadcast stream that saves and resends its latest value to listeners.
  final _messagesController = BehaviorSubject<List<Message>>();
  Stream<List<Message>> get messages => _messagesController.stream;

  final _composingController = BehaviorSubject<bool>();
  Stream<bool> get isComposing => _composingController.stream.distinct();
  Sink<bool> get composing => _composingController.sink;

  ChatMessagesBloc() {
    _addMessageController.stream.listen(_handle);
    _messagesController.sink.add(List());
  }

  void _handle(Message element) {
    _messages.insert(0, element);
    _messagesController.sink.add(_messages);
  }

  void dispose() {
    _addMessageController.close();
    _messagesController.close();
    _composingController.close();
  }
}

extension Formatting on User {
  // TODO i18n better and on caller.
  String asLocaleFormattedString([
    Locale locale = const Locale.fromSubtags(languageCode: "en"),
  ]) {
    switch (locale.languageCode) {
      case "ja":
        return "$lastName$firstName";
      default:
        return "$firstName $lastName";
    }
  }
}
// TODO Infinite Scrolling: (messages_list.dart:21) create a custom class that has a max of X messages in memory and stores the "starting" point.
// Anything outside that can be GC'd or something (WeakReference list of all the data?)
// This "in memory state" class is actually owned by the BLoC, though, and itemBuilder delegates to it.

// Consider using a StreamBuilder with initalData being the latest X messages (X = MessageView.size / message.size)
// or a hasData with a circle loader and the first message has a list of messages.
