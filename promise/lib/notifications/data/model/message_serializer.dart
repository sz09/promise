import 'dart:convert';

import 'package:promise/notifications/data/parser/base_message_type_parser.dart';

import 'message.dart';
import 'message_type.dart';

extension SerializableMessage on Message? {
  static Message? deserialize(String? serialized) {
    if (serialized == null) return null;

    final Map<String, dynamic> jsonData = jsonDecode(serialized);
    final messageType = getTypeFromMappedData(jsonData);

    switch (messageType) {
      case MessageType.Message:
      //return AMessage.fromJson(jsonData);
      case MessageType.ConnectionRequest:
      //return BMessage.fromJson(jsonData);
      default:
        return Message.fromJson(jsonData);
    }
  }

  String? serialize() {
    return this != null ? jsonEncode(this!.toJson()) : null;
  }
}
