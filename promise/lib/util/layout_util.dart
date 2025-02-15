import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

extension ContainerLayout on BuildContext {
  Color get containerLayoutColor {
    return Theme.of(this).scaffoldBackgroundColor;
  }
  double get sizeHeight {
    return MediaQuery.of(this).size.height;
  }
  double get sizeWidth {
    return MediaQuery.of(this).size.width;
  }

  double get viewInsetsBottom {
    return MediaQuery.of(this).viewInsets.bottom;
  }

  Color get borderColor {
    return Theme.of(this).textTheme.titleLarge!.color!;
  }
  
  Color get borderWidgetColor {
    return Theme.of(this).colorScheme.outline;
  }
  
  Color get borderWidgetErrorColor {
    return Theme.of(this).colorScheme.error;
  }
  
  Color get textErrorColor {
    return Theme.of(this).colorScheme.error;
  }

  Color get selectedColor {
    return Theme.of(this).colorScheme.primaryContainer;
  }

  Color get textColor 
  {
    return Theme.of(this).textTheme.titleLarge!.color!;
  }

  double get titleFontSize {
    return Theme.of(this).textTheme.titleSmall!.fontSize!;
  }

  FontWeight get titleFontWeight {
    return Theme.of(this).textTheme.titleSmall!.fontWeight!;
  }
  double get fontSize {
    return Theme.of(this).textTheme.bodyMedium!.fontSize!;
  }
  
  double get fontLargeSize {
    return Theme.of(this).textTheme.bodyLarge!.fontSize!;
  }

  double get titleMediumSize {
    return Theme.of(this).textTheme.titleMedium!.fontSize!;
  }

  double get titleLargeSize {
    return Theme.of(this).textTheme.titleLarge!.fontSize!;
  }

  Color get iconColor {
    final theme = Theme.of(this).textTheme;
    return theme.titleLarge!.color!;
  }
}


const EdgeInsets contentPadding = EdgeInsets.only(left: 10, right: 10);
const EdgeInsets paddingTop = EdgeInsets.only(top: 10);
const EdgeInsets quarterToPaddingTop = EdgeInsets.only(top: 7.5);
const EdgeInsets halfPaddingTop = EdgeInsets.only(top: 5);
const EdgeInsets quarterPaddingTop = EdgeInsets.only(top: 2.5);
const EdgeInsets paddingLeft = EdgeInsets.only(left: 5);
const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(horizontal: 5);
BorderRadius roundedItem = BorderRadius.circular(10.0);


const titleFontStyle = TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    );

showEditableDialog({required BuildContext context, required Widget Function() func} ){
   showModalBottomSheet(
      isScrollControlled: true, // make dialog can show with custom height
      context: context,
      constraints: BoxConstraints.expand(height: MediaQuery.of(context).size.height * 0.9),
      builder: (BuildContext context) {
        return Container(
          padding: contentPadding,
          decoration: BoxDecoration(
            color: context.containerLayoutColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: func(),
        );
      },
    );
}


removeButton({required Function onRemove}){
  return IconButton(
    onPressed: () {
      onRemove();
    },
    color: Colors.red,
    icon: Icon(FontAwesomeIcons.x),
  );
}