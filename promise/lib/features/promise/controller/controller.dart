
import 'package:get/get.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/features/create.controller.dart';
import 'package:promise/features/page.controller.dart';
import 'package:promise/models/objective/objective.dart';
import 'package:promise/models/person/person.dart';
import 'package:promise/models/promise/promise.dart';
import 'package:promise/services/objective/objective.service.dart';
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
        await loadingOverlay.during(serviceLocator.get<PersonService>().getUserReferences(), 
        doneHandler: (data) {
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

class PromiseDialogController extends EntityStateController<Promise> {
  final loadingReferenceState = LoadingState().obs;
  final service = serviceLocator.get<PromiseService>();
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
  create({required String content, required bool forYourself, required List<String> to, required DateTime? dueDate, 
        Function? completeFunc = null,
        Function(dynamic error)? errorFunc = null
        }) async{
   await service.createAsync(Promise.create(content: content, forYourself: forYourself, to: to, expectedTime: dueDate))
           .then((_) => completeFunc?.call())
           .catchError((e) => errorFunc?.call(e));
  }
  
  modify({required String id, required String content, required bool forYourself, required List<String> to, required DateTime? dueDate, 
        Function? completeFunc = null,
        Function(dynamic error)? errorFunc = null
        }) async {
    await service.modifyAsync(Promise.modify(id: id, userId: service.localRepository.userId, content: content, forYourself: forYourself, to: to, expectedTime: dueDate))
           .then((_) => completeFunc?.call())
           .catchError((e) => errorFunc?.call(e));
  }
  
  publish({required String id,
        Function? completeFunc = null,
       Function(dynamic error)? errorFunc = null
        }) async{
     await service.publishAsync(id: id)
           .then((_) => completeFunc?.call())
           .catchError((e) => errorFunc?.call(e));
  }
  
  delete({required String id,
        Function? completeFunc = null,
        Function(dynamic error)? errorFunc = null
        }) async{
    await service.deleteAsync(id)
           .then((_) => completeFunc?.call())
           .catchError((e) => errorFunc?.call(e));
  }
}

class ObjectiveController extends EntityStateController<Objective> {
  final service = serviceLocator.get<ObjectiveService>();
  Future<List<Objective>> loadObjectivesByPromise(String promiseId){
    return service.loadObjectivesByPromise(promiseId);
  }
  Future create({ 
                  required Objective objective,  
                  Function? completeFunc = null,
                  Function(dynamic error)? errorFunc = null
                }) async{
   await service.createAsync(Objective.create(content: objective.content, promiseId: objective.promiseId, works: objective.works))
           .then((_) => completeFunc?.call())
           .catchError((e) => errorFunc?.call(e));
  }
  
  Future modify({ 
                  required Objective objective,  
                  Function? completeFunc = null,
                  Function(dynamic error)? errorFunc = null
                }) async{
   await service.modifyAsync(Objective.modify(id: objective.id, content: objective.content, promiseId: objective.promiseId, works: objective.works))
           .then((_) => completeFunc?.call())
           .catchError((e) => errorFunc?.call(e));
  }

  
  delete({required String id,
        Function? completeFunc = null,
        Function(dynamic error)? errorFunc = null
        }) async{
    await service.deleteAsync(id)
           .then((_) => completeFunc?.call())
           .catchError((e) => errorFunc?.call(e));
  }
}