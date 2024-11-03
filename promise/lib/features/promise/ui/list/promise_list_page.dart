import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:promise/features/page.controller.dart';
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
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      child: Column(
        children: [
          for (Promise promise in promises)
            _PromiseListItem(
                key: ValueKey(promise.id),
                promise: promise,
                onClick: (promise) => {}
                // context
                //     .read<HomeRouterDelegate>()
                //     .setPromiseDetailNavState(promise)
                ,
                onStatusChange: (promise, isDone) => {}
                // promiseListBloc
                //     .add(isDone ? EventCompleted(promise) :  EventReopened(promise)),
                )
          // ListView.separated(
          //   shrinkWrap: true,
          //   itemCount: 20,
          //   separatorBuilder: (_, __) => const Divider(),
          //   itemBuilder: (context, int index) {
          //     return ListTile(
          //       title: Text(promises[index].content),
          //     );
          //   },
          // )
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
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.9, // 90% chiều cao màn hình
        width: MediaQuery.of(context).size.width, // Chiều rộng toàn màn hình
        padding: EdgeInsets.only(
          top: 10,
          left: 0,  // Đảm bảo không có padding ở cạnh trái
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
}

class _PromiseListItem extends StatelessWidget {
  final Promise promise;
  final Function(Promise promise) onClick;
  final Function(Promise promise, bool isDone) onStatusChange;

  const _PromiseListItem({
    super.key,
    required this.promise,
    required this.onClick,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Ink(
      color: themeData.cardColor,
      child: ListTile(
        // leading: Checkbox(
        //     checkColor: ColorPalette.black,
        //     activeColor: Theme.of(context).colorScheme.secondary,
        //     value: promise.status == EventStatus.done,
        //     onChanged: (newState) => onStatusChange(promise, newState!)),
        trailing: const Icon(Icons.reorder),
        title: Text(promise.content),
        onTap: () => onClick(promise),
      ),
    );
  }
}
