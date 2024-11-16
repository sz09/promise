import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:promise/features/promise/ui/widgets/work_view.dart';
import 'package:promise/models/objective/objective.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:promise/widgets/wrap/wrap_textarea.dart';

const double _boxHeight = 180;

class ObjectiveView extends StatefulWidget {
  final String promiseId;
  const ObjectiveView({super.key, required this.promiseId});

  @override
  State<StatefulWidget> createState() {
    return _ObjectiveViewState();
  }
}

class _ObjectiveViewState extends State<ObjectiveView> {
  final _formKey = GlobalKey<FormState>();
  List<Objective> items = [];
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Function to add a new item
  void _addItem() {
    setState(() {
      items.add(Objective(content: "", promiseId: widget.promiseId));
    });
    // _scrollController.jumpTo(MediaQuery.of(context).size.height);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: LayoutBuilder(builder: (context, constraints) {
          return SizedBox(
              width: constraints.maxWidth,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.translate("objective.objective_title"),
                          style: titleFontStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              iconSize: 20,
                              icon: Icon(
                                FontAwesomeIcons.plus,
                                color: Colors.green,
                              ),
                              onPressed: _addItem,
                            ),
                          ],
                        )
                      ],
                    ),
                    Container(
                        padding: paddingTop,
                        width: constraints.maxWidth,
                        child: ListView.builder(
                          
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemCount: items.length,
                          itemBuilder: (context, i) {
                            return _ObjectiveItem(
                              item: items[i],
                              removeItem: () {
                                setState(() {
                                  items.removeAt(i);
                                });
                              },
                              insertItem: () {
                                setState(() {
                                  items.insert(
                                      i,
                                      Objective(
                                          content: i.toString(),
                                          promiseId: widget.promiseId));
                                });
                              },
                            );
                          },
                        ))
                  ]));
        }));
  }
}

class _ObjectiveItem extends StatefulWidget {
  final Objective item;
  final Function removeItem;
  final Function insertItem;
  const _ObjectiveItem(
      {required this.item, required this.removeItem, required this.insertItem});

  @override
  State<StatefulWidget> createState() {
    return _ObjectiveItemState();
  }
}

class _ObjectiveItemState extends State<_ObjectiveItem> {
  @override
  void initState() {
    _controller = TextEditingController(text: widget.item.content);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late TextEditingController _controller =
      TextEditingController(text: widget.item.content);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
          width: constraints.maxWidth,
          height: _boxHeight,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: roundedItem),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                        padding: paddingLeft,
                        child: SizedBox(
                          width: constraints.maxWidth - 65,
                          child: WrapTextAreaFormField(
                              controller: _controller,
                              labelText:
                                  context.translate("objective.content_label"),
                              hintText:
                                  context.translate("objective.content_hint"),
                              maxLines: 5,
                              minLines: 5,
                              required: true),
                        )),
                    SizedBox(
                        width: 50,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    widget.insertItem();
                                    setState(() {});
                                  },
                                  icon: Icon(FontAwesomeIcons.plus),
                                  color: Colors.green),
                              Badge(
                                label: Text(
                                    widget.item.progressions.length.toString()),
                                isLabelVisible:
                                    widget.item.progressions.isNotEmpty,
                                child: IconButton(
                                    onPressed: () {
                                      _openProgression();
                                    },
                                    icon: Icon(FontAwesomeIcons.listCheck)),
                              ),
                              IconButton(
                                  onPressed: () {
                                    widget.removeItem();
                                    setState(() {});
                                  },
                                  icon: Icon(FontAwesomeIcons.minus),
                                  color: Colors.red),
                            ]))
                  ],
                )
              ],
            ),
          ));
    });
  }

  _openProgression() {
    showEditableDialog(
        context: context,
        func: () => WorkView(works: widget.item.progressions, promiseId: widget.item.promiseId));
  }
}
