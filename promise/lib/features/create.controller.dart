import 'package:get/get.dart';
import 'package:promise/features/page.controller.dart';
import 'package:promise/features/timeline/widget/timeline.dart';
import 'package:promise/models/memory/memory.dart';
import 'package:promise/models/person/person.dart';
import 'package:promise/models/promise/promise.dart';
import 'package:promise/networks/getx_api.state.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/util/response.ext.dart';
import 'package:promise/util/string_util.dart';
import 'package:promise/widgets/loading_overlay.dart';

abstract class CreateController<T> extends GetxController {
  var loadingState = LoadingState().obs;
  RxList<T> items = <T>[].obs;
  Future loadData(Future<PageResult<T>> Function() func) async{
    Log.d("GetX begin loadData for ${T.toPlural()}");
    final stopwatch = Stopwatch();
    stopwatch.start();
    var data = await loadingOverlay.during(func());
    setData(data.data);
    update();
    Log.d("GetX loadData for ${T.toPlural()} take ${stopwatch.elapsedMilliseconds}ms");
  }

  setData(List<T> data) {
    loadingState.value.isInprogress = false;
    items.addAll(data);
    loadingState.refresh();
  }
}

class CreateMemoryController extends CreateController<Memory> {}
class CreatePromiseController extends CreateController<Promise> {
  var loadingPeopleState = LoadingState().obs;
  RxList<Person> people = <Person>[].obs;
  loadPeople(Future<PageResult<Person>> Function() func) async {
    Log.d("GetX begin loadData for ${(Person).toPlural()}");
    final stopwatch = Stopwatch();
    stopwatch.start();
    loadingState.onLoading();
    var pageResult = await func();
    loadingState.onLoaded();
    people.clear();
    people.addAll(pageResult.data);

    Log.d("GetX loadData for ${(Person).toPlural()} take ${stopwatch.elapsedMilliseconds}ms");
  
  }
}
class CreateTimelineController extends CreateController<TimelineItem> {}