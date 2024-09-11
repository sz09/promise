import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:promise/features/page.controller.dart';
import 'package:promise/features/promise/ui/create_promise_view.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/main.dart';
import 'package:promise/models/promise/promise.dart';
import 'package:promise/services/promise/promise.service.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/widgets/loading_overlay.dart';

final _controller = Get.find<PromiseController>(tag: applicationTag);
class PromiseListPage extends StatelessWidget {
  const PromiseListPage({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put<PromiseController>(PromiseController(), tag: applicationTag);
    _controller.loadData(serviceLocator.get<PromiseService>().fetchAsync);
    return const PromiseListView();
  }
}

class PromiseListView extends StatelessWidget {
  const PromiseListView({super.key});
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Obx(() => _getBodyForState(context)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openCreatePromise(context);
        },
        tooltip: context.translate('promise_list_create_new'),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _getBodyForState(BuildContext context) {
    if (_controller.loadingState.value.isInprogress) {
      return loadingWidget();
    } else if (!_controller.loadingState.value.isInprogress) {
      final List<Promise> memories = _controller.items;
      if (memories.isEmpty) {
        return _emptyListWidget(context);
      } else {
        return Column(
          children: <Widget>[
            Expanded(
              child: _promiseListWidget(
                context,
                memories,
              ),
            ),
          ],
        );
      }
    }  else if (_controller.loadingState.value.isError) {
      return _errorWidget(_controller.loadingState.value.errorKey, context);
    } 
    else {
      Log.e(UnimplementedError('EventListState not consumed'));
      return _errorWidget("EventListState not consumed", context);
    }
  }

  Widget _promiseListWidget(BuildContext context, List<Promise> memories) {
    return Scrollbar(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          color: context.containerLayoutColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[getItem(memories, context)],
          ),
        ),
      ),
    );
  }

  Widget _emptyListWidget(BuildContext context) {
    return Center(
        child: Text(
          context.translate("promise_list_no_promises_message")
        )
      );
  }
 
  Widget _errorWidget(String errorKey, BuildContext context) {
    return Center(child: Text(context.translate(errorKey)));
  }

  void _openCreatePromise(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const CreatePromiseView();
        });
  }

  ReorderableListView getItem(List<Promise> promise, BuildContext context) {
    return ReorderableListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        header: SizedBox(
          height: 50,
          child: Container(
            color: context.containerLayoutColor,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                child: Text(
                 context.translate('promise.title'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        children: <Widget>[
          for (Promise promise in promise)
            _PromiseListItem(
                key: ValueKey(promise.id),
                promise: promise,
                onClick: (promise) =>  {} 
                // context
                //     .read<HomeRouterDelegate>()
                //     .setPromiseDetailNavState(promise)
                    ,
                onStatusChange: (promise, isDone) => {}
                // promiseListBloc
                //     .add(isDone ? EventCompleted(promise) :  EventReopened(promise)),
                ),
        ],
        onReorder: (oldIndex, newIndex) {
          // promiseListBloc.add(PromisesReordered(key, oldIndex, newIndex));
        });
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
