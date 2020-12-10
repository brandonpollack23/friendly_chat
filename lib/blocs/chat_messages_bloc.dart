import 'dart:async';

// TODO without rxdart what to use instead of BehaviorSubject?

class ChatMessagesBloc {
  // TODO instead of messages use Entity class that contains user and message.
  final _messages = <String>[];

  final _addMessageController = StreamController<String>();
  Sink<String> get addMessage => _addMessageController.sink;

  final _messagesController = StreamController<List<String>>();
  Stream<List<String>> get messages => _messagesController.stream;

  final _composingController = StreamController<bool>();
  Stream<bool> get isComposing => _composingController.stream.distinct();
  Sink<bool> get composing => _composingController.sink;

  ChatMessagesBloc() {
    _addMessageController.stream.listen(_handle);
    _messagesController.sink.add(List());
  }

  void _handle(element) {
    _messages.insert(0, element);
    _messagesController.sink.add(_messages);
  }

  void dispose() {
    _addMessageController.close();
    _messagesController.close();
    _composingController.close();
  }
}
// TODO Infinite Scrolling: (messages_list.dart:21) create a custom class that has a max of X messages in memory and stores the "starting" point.
// Anything outside that can be GC'd or something (WeakReference list of all the data?)
// This "in memory state" class is actually owned by the BLoC, though, and itemBuilder delegates to it.

// Consider using a StreamBuilder with initalData being the latest X messages (X = MessageView.size / message.size)
// or a hasData with a circle loader and the first message has a list of messages.
