import 'package:flutter/foundation.dart';
import 'package:friendly_chat/entities/user.dart';

class Message {
  final User user;
  final String text;

  Message({
    @required this.user,
    @required this.text,
  });
}
