
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';


ChatL10n getChatL10n() {
  if(Get.locale!.languageCode != 'en'){
    return const ChatL10nVi();
  }
  return const ChatL10nEn();
}

@immutable
class ChatL10nVi extends ChatL10n {
  /// Creates Vietnamese l10n. Use this constructor if you want to
  /// override only a couple of properties, otherwise create a new class
  /// which extends [ChatL10n].
  const ChatL10nVi({
    super.and = 'và',
    super.attachmentButtonAccessibilityLabel = 'Gửi đa phương tiện',
    super.emptyChatPlaceholder = 'Chưa có tin nhắn',
    super.fileButtonAccessibilityLabel = 'File',
    super.inputPlaceholder = 'Tin nhắn',
    super.isTyping = 'đang nhập...',
    super.others = 'khác',
    super.sendButtonAccessibilityLabel = 'Gửi',
    super.unreadMessagesLabel = 'Tin nhắn chưa đọc',
  });
}