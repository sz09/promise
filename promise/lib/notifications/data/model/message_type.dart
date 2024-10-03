/// Enumeration that determines type of the incoming remote message
// ignore: constant_identifier_names
enum MessageType { Message, Call, ConnectionRequest, UNKNOWN }

extension ParseMessageType on String {
  /// Concerts raw [String] to [MessageType].
  MessageType toMessageType() {
    switch (this) {
      case 'Call':
        return MessageType.Call;
      case 'Message':
        return MessageType.Message;
      case 'ConnectionRequest':
        return MessageType.ConnectionRequest;
      default:
        return MessageType.UNKNOWN;
    }
  }
}

extension MessageDetails on MessageType {
  /// Returns the remote key for the [MessageType]
  String getKey() {
    switch (this) {
      case MessageType.Call:
        return 'Call';
      case MessageType.Message:
        return 'Message';
      case MessageType.ConnectionRequest:
        return 'ConnectionRequest';
      case MessageType.UNKNOWN:
        return 'n/a';
    }
  }

  bool shouldShowAlert() {
    switch (this) {
      case MessageType.Message:
        return true;
      case MessageType.Call:
        return true;
      case MessageType.ConnectionRequest:
        return true;
      default:
        return false;
    }
  }
}
