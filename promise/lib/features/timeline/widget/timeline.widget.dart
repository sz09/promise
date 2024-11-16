import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:promise/features/menu/menu.dart';
import 'package:promise/models/story/story.model.dart';
import 'package:promise/routers/router.config.dart';
import 'package:promise/util/date_time_util.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';

class TimelineItemWidget extends StatefulWidget {
  final Story item;
  final int index;
  const TimelineItemWidget(
      {super.key, required this.item, required this.index});

  
  @override
  State<StatefulWidget> createState() {
    return _StateTimelineItemWidget();
  }
}

class _StateTimelineItemWidget extends State<TimelineItemWidget> {

  final _initialMaxLines = 5;
  late bool _showAllText = false;
  _onLove() {

  }

  _onTryYourBest() {

  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: _onLove,
      child:  Card(
      shape: RoundedRectangleBorder(borderRadius: roundedItem),
      borderOnForeground: true,
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // mainAxisSize: MainAxisSize.min, // Adjust height based on content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: halfPaddingTop,
                  child: Row(
                    children: [
                      InkWell(
                          child: Text(widget.item.from,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: const Color.fromARGB(255, 13, 138, 240), // Set color, you can adjust the shade
                                letterSpacing: 0.5,
                              )),
                          onTap: () {
                            context.navigateToWithArguments(
                                userRoute, {"id": widget.item.from});
                          }),
                      Text(
                        " ${_displayAction(context)}" ,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        " ${_forUser(context)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    ],
                  )),
              Text(
                widget.item.time.asString(isDateOnly: true),
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontStyle: FontStyle.italic),
              ),
              Padding(
                  padding: halfPaddingTop,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _showAllText = !_showAllText;
                      });
                    },
                    child:  Text(
                      widget.item.content,
                      maxLines: _showAllText ? null : _initialMaxLines,
                      overflow: _showAllText ? null: TextOverflow.ellipsis,
                  )
              )),
              Padding(
                  padding: quarterToPaddingTop, 
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: _onLove,
                          icon: const Icon(FontAwesomeIcons.heart)),
                      IconButton(
                          onPressed: _onTryYourBest,
                          icon: const Icon(Icons.handshake_outlined)),
                    ],
                  ))
            ],
          )),
    ));
  }

  String _displayAction(BuildContext context) {
    return widget.item.action == PromiseAction.Promise
        ? context.translate("timeline.promise_action")
        : context.translate("timeline.complete_challenge_action");
  }

  String _forUser(BuildContext context) {
    return widget.item.to.isEmpty
        ? context.translate('timeline.for_himself')
        : "${widget.item.to.join(', ')}:";
  }
}
