
import 'package:get/get.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/features/create.controller.dart';
import 'package:promise/features/page.controller.dart';
import 'package:promise/models/person/person.dart';
import 'package:promise/models/promise/promise.dart';
import 'package:promise/services/person/person.service.dart';
import 'package:promise/services/promise/promise.service.dart';
import 'package:promise/widgets/loading_overlay.dart';

class PromiseController extends PageController<Promise> {
  final loadingReferenceState = LoadingState().obs;
  RxList<UserReference> userReferences = <UserReference>[].obs;
  Future loadUserRefereces() async {
        loadingReferenceState.value.isInprogress = true;
        loadingReferenceState.refresh();
        final stopwatch = Stopwatch();
        stopwatch.start();
        await loadingOverlay.during(serviceLocator.get<PersonService>().getUserReferences(), doneHandler: (data) {
          _reset();
          _setData(data);
          update();
          return data;
        });
    }

  void _reset(){
    userReferences.clear();
  }
  void _setData(List<UserReference> data) {
    loadingReferenceState.value.isInprogress = false;
    userReferences.addAll(data);
    loadingReferenceState.value.completed = true;
    loadingReferenceState.refresh();
  }
}

class CreatePromiseController extends CreateController<Promise> {
  var loadingPeopleState = LoadingState().obs;
  create({required String content, required bool forYourself, required List<String> to, required DateTime? dueDate, 
        Function? completeFunc = null,
        Function? errorFunc = null
        }){
    serviceLocator.get<PromiseService>()
                  .createAsync(Promise(id: '', content: content, forYourself: forYourself, to: to, dueDate: dueDate))
                  .then(completeFunc?.call())
                  .catchError(errorFunc?.call());
  }
}