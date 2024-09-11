
import 'package:get/get.dart';

class NetworkState {
  late var isInprogress = false;
  late var isError = false;
  late var errorKey = "";
}

extension StateExtension on Rx<NetworkState> {
  onLoading(){
    value.isInprogress = true;
    refresh();
  }

  onLoaded(){
    value.isInprogress = false;
    refresh();
  }
}