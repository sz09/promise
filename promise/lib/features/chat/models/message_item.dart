import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  final String id;
  ListItem({required this.id });
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a message.
class MessageItem extends ListItem {
  final String sender;
  final String body;

  MessageItem(String id, this.sender, this.body): super(id: id);

  @override
  Widget buildTitle(BuildContext context) => Text(sender, style: const TextStyle( fontWeight: FontWeight.bold ));

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}