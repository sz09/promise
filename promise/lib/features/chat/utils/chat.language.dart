
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:promise/features/chat/l10n/vn.dart';


ChatL10n getChatL10n() {
  if(Get.locale!.languageCode != 'en'){
    return const ChatL10nVN();
  }
  return const ChatL10nEn();
}