import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

commonDialog({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required String dialogTitleKey,
  required Widget Function(BuildContext context) bodyWidgets,
  required Function? onSave,
  Widget? action = null,
}) {
  return SingleChildScrollView(
      child: StickyHeader(
        header: Padding(
        padding: paddingTop,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: context.containerLayoutColor,

          ),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.translate(dialogTitleKey),
              style: titleFontStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (action != null) action,
                if(onSave != null) 
                  IconButton(
                    icon: Icon(FontAwesomeIcons.solidFloppyDisk,
                        color: Colors.green),
                    onPressed: () {
                      onSave();
                  }),
              ],
            )
          ],
        )
        )),
        content: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.zero,
            child: bodyWidgets(context),
          ),
        ),
  ));
}
