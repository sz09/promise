import 'package:get/get.dart';
import 'package:promise/features/timeline/widget/timeline.dart';
import 'package:promise/models/memory/memory.dart';
import 'package:promise/models/person/person.dart';
import 'package:promise/models/promise/promise.dart';
import 'package:promise/networks/getx_api.state.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/util/response.ext.dart';
import 'package:promise/util/string_util.dart';
import 'package:promise/widgets/loading_overlay.dart';

class LoadingState extends NetworkState {
}

abstract class PageController<T> extends GetxController {
  var loadingState = LoadingState().obs;
  RxList<T> items = <T>[].obs;
  Future loadData(Future<PageResult<T>> Function() func) async {
    loadingState.value.isInprogress = true;
    loadingState.refresh();
    Log.d("GetX begin loadData for ${T.toPlural()}");
    final stopwatch = Stopwatch();
    stopwatch.start();
    await loadingOverlay.during(func(), doneHandler: (data) {
      reset();
      setData(data.data);
      update();
      return data;
    });
    Log.d("GetX loadData for ${T.toPlural()} take ${stopwatch.elapsedMilliseconds}ms");
  }
  void reset(){
    items.clear();
  }
  void setData(List<T> data) {
    loadingState.value.isInprogress = false;
    items.addAll(data);
    loadingState.refresh();
  }
}

class MemoryController extends PageController<Memory> {}
class PromiseController extends PageController<Promise> {}
class TimelineController extends PageController<TimelineItem> {}
class PeopleController extends PageController<Person> {}