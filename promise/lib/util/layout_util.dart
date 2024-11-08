import 'package:flutter/material.dart';

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

  Color get textColor 
  {
    return Theme.of(this).textTheme.titleLarge!.color!;
  }

  double get fontSize {
    return Theme.of(this).textTheme.bodyMedium!.fontSize!;
  }
  
  double get fontLargeSize {
    return Theme.of(this).textTheme.bodyLarge!.fontSize!;
  }
  Color get iconColor {
    final theme = Theme.of(this).textTheme;
    return theme.titleLarge!.color!;
  }
}


const EdgeInsets contentPadding = EdgeInsets.all(15);
const EdgeInsets paddingTop = EdgeInsets.only(top: 10);
const EdgeInsets halfPaddingTop = EdgeInsets.only(top: 5);
const EdgeInsets quarterPaddingTop = EdgeInsets.only(top: 2.5);
const EdgeInsets quarterToPaddingTop = EdgeInsets.only(top: 7.5);
BorderRadius roundedItem = BorderRadius.circular(10.0);

showEditableDialog({required BuildContext context, required Widget Function() func} ){
   showModalBottomSheet(
      isDismissible: false,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height *
              0.9, // 90% chiều cao màn hình
          width: MediaQuery.of(context).size.width, // Chiều rộng toàn màn hình
          padding: EdgeInsets.only(
            top: 10,
            left: 0, // Đảm bảo không có padding ở cạnh trái
            right: 0, // Đảm bảo không có padding ở cạnh phải
            bottom: MediaQuery.of(context).viewInsets.bottom + 15,
          ),
          decoration: BoxDecoration(
            color: context.containerLayoutColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: func(),
          ),
        );
      },
    );
}