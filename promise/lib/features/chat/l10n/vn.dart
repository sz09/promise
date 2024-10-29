
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

@immutable
class ChatL10nVN extends ChatL10n {
  /// Creates English l10n. Use this constructor if you want to
  /// override only a couple of properties, otherwise create a new class
  /// which extends [ChatL10n].
  const ChatL10nVN({
    super.and = 'và',
    super.attachmentButtonAccessibilityLabel = 'Gửi đa phương tiện',
    super.emptyChatPlaceholder = 'Không có tin nhắn',
    super.fileButtonAccessibilityLabel = 'File',
    super.inputPlaceholder = 'Tin nhắn',
    super.isTyping = 'đang nhập...',
    super.others = 'khác',
    super.sendButtonAccessibilityLabel = 'Gửi',
    super.unreadMessagesLabel = 'Tin nhắn chưa đọc',
  });
}
