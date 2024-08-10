import 'package:flutter/cupertino.dart';
import 'package:promise/util/loader.dart';

class OverlayView extends StatelessWidget {
  const OverlayView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      // <--- IMP , using ValueListenableBuilder for showing/removing overlay
      valueListenable: Loader.appLoader.loaderShowingNotifier,
      builder: (context, value, child) {
        return Container();
      },
    );
  }
}
