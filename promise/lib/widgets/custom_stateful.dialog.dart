import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';

commonDialog(
    { 
      required BuildContext context, 
      required GlobalKey<FormState> formKey, 
      required String dialogTitleKey,
      required Widget Function(BuildContext context) bodyWidgets,
      required Function onSave,
      Widget? action = null,
    }){
  return Padding(
        padding: contentPadding,
        child: Form(
            key: formKey,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.translate(dialogTitleKey),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if(action != null)
                        action
                    ],
                  ),
                  bodyWidgets(context),
                  Padding(
                      padding: paddingTop,
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton.icon(
                              icon: Icon(FontAwesomeIcons.floppyDisk),
                              onPressed: () {
                                onSave();
                              },
                              label: Text(context.translate("common.save")),
                              iconAlignment: IconAlignment.end,
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: roundedItem,
                                  ),
                                  backgroundColor: Colors.green[700]))))
                ]
            )
          )
      );

    }