
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';

ChatTheme getChatTheme(){ 
  if(Get.isDarkMode){
    return const DarkChatTheme();
  }

  return const DefaultChatTheme();
}
