import 'package:promise/notifications/data/model/message_type.dart';

//todo modify this
enum AndroidNotificationChannels { A, B, C }

const Map<AndroidNotificationChannels, String> notificationChannelKeys = {
  AndroidNotificationChannels.A: 'a_channel_id',
  AndroidNotificationChannels.B: 'b_channel_id',
  AndroidNotificationChannels.C: 'c_channel_id',
};

const Map<AndroidNotificationChannels, String> notificationChannelNames = {
  AndroidNotificationChannels.A: 'androidNotifChannelName_A',
  AndroidNotificationChannels.B: 'androidNotifChannelName_B',
  AndroidNotificationChannels.C: 'androidNotifChannelName_C',
};

extension AndroidNotificationChannelsMethods on AndroidNotificationChannels {
  String get key => notificationChannelKeys[this]!;

  String get visibleName => notificationChannelNames[this]!;
}

AndroidNotificationChannels getChannelForMessageType(MessageType type) {
  switch (type) {
    case MessageType.Call:
      return AndroidNotificationChannels.A;
    case MessageType.Message:
    case MessageType.ConnectionRequest:
    case MessageType.UNKNOWN:
      return AndroidNotificationChannels.B;
  }
}
