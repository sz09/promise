
import 'package:get/get.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/features/page.controller.dart';
import 'package:promise/models/person/person.dart';
import 'package:promise/models/promise/promise.dart';
import 'package:promise/services/promise/promise.service.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/util/string_util.dart';

class PeopleController extends PageController<Person> {
  var loadingPromiseState = LoadingState().obs;
  RxList<Promise> promises = <Promise>[].obs;
  loadPromiseCountByPerson() async{
    loadingPromiseState.value.isInprogress = true;
    loadingPromiseState.refresh();
    Log.d("GetX begin loadData for ${(Promise).toPlural()}");
    final stopwatch = Stopwatch();
    stopwatch.start();
    final promises = await serviceLocator.get<PromiseService>().fetchAsync();
    Log.d("GetX loadData for ${(Promise).toPlural()} take ${stopwatch.elapsedMilliseconds}ms");
    resetPromiseData();
    _setPromiseData(promises.data);
    update();
  }
  
  void resetPromiseData(){
    promises.clear();
  }
  void _setPromiseData(List<Promise> data) {
    loadingState.value.isInprogress = false;
    promises.addAll(data);
    loadingPromiseState.value.completed = true;
    loadingPromiseState.refresh();
  }
}