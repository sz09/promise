import 'package:promise/util/notification_util.dart';

cancelByUniqueName({required String taskName, String? tag = null}){
  workManagerInstance.cancelByUniqueName(_calculateUniqueName(taskName: taskName, tag: tag));
}

registerPeriodicTask({
    required String taskName,
    required Duration? frequency,
    String? tag = null,
    required Map<String, dynamic>? inputData,
  }){
    workManagerInstance.registerPeriodicTask(
      _calculateUniqueName(taskName: taskName, tag: tag), 
      taskName,
      tag: tag,
      frequency: frequency,
      inputData: inputData,
    );
}

_calculateUniqueName({required String taskName, String? tag = null}){
  return taskName + (tag != null ? '#$tag' : '');
}