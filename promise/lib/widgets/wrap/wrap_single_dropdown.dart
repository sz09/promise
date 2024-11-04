import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:promise/features/page.controller.dart';
import 'package:promise/main.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/widgets/dropdown/dropdown_textfield.dart';

class DropdownController extends GetxController {
  var loadingState = LoadingState().obs;
  RxList<DropDownValueModel> items = <DropDownValueModel>[].obs;
  loadData(Future<List<DropDownValueModel>> Function() func, String tag) async {
    loadingState.value.isInprogress = true;
    loadingState.refresh();
    Log.d("GetX begin loadData for DropdownController-$tag");
    final stopwatch = Stopwatch();
    stopwatch.start();
    items.clear();
    setData(await func());
    Log.d(
        "GetX loadData for DropdownController$tag take ${stopwatch.elapsedMilliseconds}ms");
  }

  void setData(List<DropDownValueModel> data) {
    loadingState.value.isInprogress = false;
    items.addAll(data);
    loadingState.refresh();
  }
}

@immutable
class WrapSingleDropdownFormField extends StatelessWidget {
  late String _hintText;
  late String labelText;
  late String uniqueName;
  late bool validState;
  late SingleValueDropDownController controller;
  late Future<List<DropDownValueModel>> Function() loadItemsFunc;

  WrapSingleDropdownFormField(
      {required this.controller,
      required this.loadItemsFunc,
      required this.uniqueName,
      required this.labelText,
      String? hintText = null,
      super.key,
      this.validState = true}) {
    _hintText = hintText ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final fetchItemController =
        Get.find<DropdownController>(tag: "$applicationTag.$uniqueName");
    fetchItemController.loadData(loadItemsFunc, uniqueName);
    return Theme(
        data: context.theme,
        child: Padding(
          padding: paddingTop,
          child: Obx(() => DropDownTextField(
              enableSearch: true,
              clearOption: false,
              controller: controller,
              listTextStyle: TextStyle(
                color: context.textColor,
                backgroundColor: context.containerLayoutColor,
              ),
              textStyle: TextStyle(backgroundColor: context.containerLayoutColor),
              textFieldDecoration: InputDecoration(
                  labelText: labelText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
              ),
              // ignore: invalid_use_of_protected_member
              dropDownList: fetchItemController.items.value,
              searchDecoration: InputDecoration(
                hintText: _hintText,
              )))
        ));
  }
}
