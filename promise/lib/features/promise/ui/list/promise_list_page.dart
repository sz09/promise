import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:promise/features/promise/controller/controller.dart';
import 'package:promise/features/promise/ui/promise_view.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/main.dart';
import 'package:promise/models/promise/promise.dart';
import 'package:promise/services/promise/promise.service.dart';
import 'package:promise/util/date_time_util.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/widgets/custom_stateful.page.dart';
import 'package:promise/widgets/loading_overlay.dart';

final _controller = Get.find<PromiseController>(tag: applicationTag);

final ScrollController _scrollController = ScrollController();

class PromiseListPage extends PullToRefreshStateView {
  void openCreatePromise(BuildContext context) {
    showEditableDialog(context: context, func: () => PromiseDialog.create(reloadData: _loadData));
  }
  PromiseListPage({super.key})
      : super(){
        super.loadDataFunc = _loadData;
        super.buildWidgetFunc = (context) => Scaffold(
            body: Obx(() => _getBodyForState(context))
          );
      }

  void _loadData(){
    _controller.loadData(serviceLocator.get<PromiseService>().fetchAsync);
    _controller.loadUserRefereces();
  }

  Widget _getBodyForState(BuildContext context) {
    if (_controller.loadingState.value.isInprogress) {
      return loadingWidget();
    } else if (!_controller.loadingState.value.isInprogress) {
      final List<Promise> promises = _controller.items;
      if (promises.isEmpty) {
        return _emptyListWidget(context);
      } else {
        return Column(
          children: <Widget>[
            Expanded(
              child: _promiseListWidget(
                context,
                promises,
              ),
            ),
          ],
        );
      }
    } else if (_controller.loadingState.value.isError) {
      return _errorWidget(_controller.loadingState.value.errorKey, context);
    } else {
      Log.e(UnimplementedError('EventListState not consumed'));
      return _errorWidget("EventListState not consumed", context);
    }
  }

  Widget _promiseListWidget(BuildContext context, List<Promise> promises) {
    int index = 0;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      child: Column(
        children: [
          for (Promise promise in promises)
            _PromiseListItem(
                key: ValueKey(promise.id + (index++).toString()),
                promise: promise,
                onTap: (promise) {
                  _onEditPromise(context, promise);
                })
        ],
      ),
    );
  }

  Widget _emptyListWidget(BuildContext context) {
    return Center(
        child: Text(context.translate("promise_list_no_promises_message")));
  }

  Widget _errorWidget(String errorKey, BuildContext context) {
    return Center(child: Text(context.translate(errorKey)));
  }

  void _onEditPromise(BuildContext context, Promise promise) {
    showEditableDialog(context: context, func: () => PromiseDialog.edit(promise: promise, reloadData: _loadData));
  }
}

class _PromiseListItem extends StatelessWidget {
  final Promise promise;
  final void Function(Promise promise) onTap;

  const _PromiseListItem(
      {super.key, required this.promise, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(promise);
      },
      child: Card(
        elevation: 4,
        // color:  //context.containerLayoutColor
        shape: RoundedRectangleBorder(borderRadius: roundedItem),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Adjust height based on content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => _controller
                                    .loadingReferenceState.value.completed
                                ? _userReference(context, promise)
                                : Container()),
                            _dueDate(promise)
                          ]),
                        Padding(
                            padding: halfPaddingTop,
                            child: Text(
                              promise.content,
                              style: const TextStyle(fontSize: 14),
                            )),
                        Padding(padding: halfPaddingTop, child: Container())
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userReference(BuildContext context, Promise promise) {
    String text;
    if (promise.forYourself) {
      text = context.translate('promise.self_promise');
    } else {
      final listPeople = promise.to?.map((d) {
        final item = _controller.userReferences.value
            .firstWhereOrNull((s) => s.referenceUserId == d);
        return item?.hint ?? context.translate('promise.no_reference_user');
      }).join(", ");
      text = "${context.translate('promise.with_list_label')} $listPeople";
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.blueAccent,
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _dueDate(Promise promise) {
    if (promise.expectedTime != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          promise.expectedTime!.asString(true),
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    }

    return Container();
  }
}
