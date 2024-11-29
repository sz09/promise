import 'package:get/get.dart';
import 'package:promise/features/page.controller.dart';
import 'package:promise/models/memory/memory.dart';

abstract class EntityStateController<T> extends GetxController {
  var loadingState = LoadingState().obs;
}

class CreateMemoryController extends EntityStateController<Memory> {}