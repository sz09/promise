import 'package:get/get.dart';
import 'package:promise/models/memory/memory.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/util/response.ext.dart';
import 'package:promise/util/string_util.dart';
import 'package:promise/widgets/loading_overlay.dart';

abstract class Controller<T> extends GetxController{
  var isLoading = true.obs;
  var isError = false.obs;
  var errorKey = "".obs;
  var items = List<T>.empty(growable: true).obs;
  Future loadData(Future<PageResult<T>> Function() func) async{
    final stopwatch = Stopwatch();
    stopwatch.start();
    var data = await loadingOverlay.during(func());
    isLoading = false.obs;
    Log.d("fetch data for ${T.toPlural()} take ${stopwatch.elapsedMilliseconds}ms");
    items.addAll(data.data);
  }
}

class MemoryController extends Controller<Memory> {}