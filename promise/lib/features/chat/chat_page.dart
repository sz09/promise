import 'package:flutter/material.dart';
import 'package:promise/features/chat/models/message_item.dart';
import 'package:promise/features/menu/menu.dart';
import 'package:promise/routers/router.config.dart';
import 'package:promise/util/layout_util.dart';

class ChatPage extends StatelessWidget {
  late List<ListItem> items = List<ListItem>.generate(
        100,
        (i) => MessageItem(i.toString(), 'Sender $i', 'Message body $i'),
      );

  ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              style: ListTileStyle.drawer,
              onTap:() => {
                context.navigateToWithArguments(chatOneRoute, {
                  "id": item.id
                })
              },
              minLeadingWidth : 100,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: context.borderColor, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              title: item.buildTitle(context),
              subtitle: item.buildSubtitle(context),
            );
          },
        ),
      );
  }
}