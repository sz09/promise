import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:promise/features/promise/controller/controller.dart';
import 'package:promise/features/promise/ui/promise_view.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/main.dart';
import 'package:promise/models/promise/promise.dart';
import 'package:promise/services/promise/promise.service.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/widgets/custom_stateful.page.dart';
import 'package:promise/widgets/loading_overlay.dart';

final _controller = Get.find<PromiseController>(tag: applicationTag);

final ScrollController _scrollController = ScrollController();

class PromiseListPage extends StatelessWidget {
  const PromiseListPage({super.key});
  @override
  Widget build(BuildContext context) {
    _controller.loadData(serviceLocator.get<PromiseService>().fetchAsync);
    _controller.loadUserRefereces();
    return PromiseListView();
  }
}

class PromiseListView extends StateView<PromiseListView> {
  PromiseListView({super.key}) {
    buildWidgetFunc = (context) => Scaffold(
          body: Obx(() => _getBodyForState(context)),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _openCreatePromise(context);
            },
            tooltip: context.translate('promise_list_create_new'),
            child: const Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
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
    int a = 0;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      child: Column(
        children: [
          for (Promise promise in promises)
            _PromiseListItem(
                key: ValueKey(promise.id + (a++).toString()),
                promise: promise,
                onTap: (promise) => {

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

  void _openCreatePromise(BuildContext context) {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height *
              0.9, // 90% chiều cao màn hình
          width: MediaQuery.of(context).size.width, // Chiều rộng toàn màn hình
          padding: EdgeInsets.only(
            top: 10,
            left: 0, // Đảm bảo không có padding ở cạnh trái
            right: 0, // Đảm bảo không có padding ở cạnh phải
            bottom: MediaQuery.of(context).viewInsets.bottom + 15,
          ),
          decoration: BoxDecoration(
            color: context.containerLayoutColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const SingleChildScrollView(
            child: PromiseDialog(),
          ),
        );
      },
    );
  }

  void _onEditPromise(BuildContext context, Promise promise){
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height *
              0.9, // 90% chiều cao màn hình
          width: MediaQuery.of(context).size.width, // Chiều rộng toàn màn hình
          padding: EdgeInsets.only(
            top: 10,
            left: 0, // Đảm bảo không có padding ở cạnh trái
            right: 0, // Đảm bảo không có padding ở cạnh phải
            bottom: MediaQuery.of(context).viewInsets.bottom + 15,
          ),
          decoration: BoxDecoration(
            color: context.containerLayoutColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const SingleChildScrollView(
            child: PromiseDialog.edit(promise),
          ),
        );
      },
    );
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
      onTap: () => onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                        Obx(() => Text(
                              _controller.loadingReferenceState.value.completed
                                  ? _userReferenceText(context, promise)
                                  : "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        Text(
                          promise.content,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                "description",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _userReferenceText(BuildContext context, Promise promise) {
    if (promise.forYourself) {
      return context.translate('promise.self_promise');
    }
    final listPeople = promise.to!.map((d) {
      // ignore: invalid_use_of_protected_member
      final item = _controller.userReferences.value
          .firstWhereOrNull((s) => s.referenceUserId == d);
      return item?.hint ?? context.translate('promise.no_reference_user');
    }).join(", ");
    return "${context.translate('promise.with_list_label')} $listPeople";
  }
}
