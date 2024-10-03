// ignore_for_file: constant_identifier_names

import 'package:promise/notifications/data/model/message_type.dart';

//todo modify this

const TYPE_A_NOTIFICATION_ID = 111111;
const TYPE_B_NOTIFICATION_ID = 222222;
const TYPE_C_NOTIFICATION_ID = 333333;

int getMessageIdForType(MessageType type) {
  switch (type) {
    case MessageType.Call:
      return TYPE_A_NOTIFICATION_ID;
    case MessageType.Message:
    case MessageType.ConnectionRequest:
      return TYPE_B_NOTIFICATION_ID;
    case MessageType.UNKNOWN:
      return DateTime.now().millisecondsSinceEpoch;
  }
}
