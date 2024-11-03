import 'package:flutter/material.dart';

extension ContainerLayout on BuildContext {
  Color get containerLayoutColor 
  {
    return Theme.of(this).scaffoldBackgroundColor;
  }
  
  Color get borderColor {
    return Theme.of(this).textTheme.titleLarge!.color!;
  }

  Color get textColor 
  {
    return Theme.of(this).textTheme.titleLarge!.color!;
  }

  Color get iconColor 
  {
    final theme = Theme.of(this).textTheme;
    return theme.titleLarge!.color!;
  }
}


const EdgeInsets contentPadding = EdgeInsets.all(15);
const EdgeInsets paddingTop = EdgeInsets.only(top: 10);
