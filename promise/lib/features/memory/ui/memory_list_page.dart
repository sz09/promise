import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:promise/features/home/router/home_router_delegate.dart';
import 'package:promise/features/page.controller.dart';
import 'package:promise/features/memory/ui/create_memory_view.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/main.dart';
import 'package:promise/models/memory/memory.dart';
import 'package:promise/services/memory/memory.service.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';

final _controller = Get.find<MemoryController>(tag: applicationTag);
class MemoryListPage extends StatelessWidget {
  const MemoryListPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    Get.put<MemoryController>(MemoryController(), tag: applicationTag);
    _controller.loadData(serviceLocator.get<MemoryService>().fetchAsync);
    return const MemoryListView();
  }
}


class MemoryListView extends StatelessWidget {
  const MemoryListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _getBodyForState(context)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openCreateMemory(context);
        },
        tooltip: context.translate('memory_list_create_new'),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _getBodyForState(BuildContext context) {
    if (_controller.loadingState.value.isInprogress) {
      return loadingWidget();
    } else 
    if (!_controller.loadingState.value.isInprogress) {
      final List<Memory> memories = _controller.items;
      if (memories.isEmpty) {
        return _emptyListWidget(context);
      } else {
        return Column(
          children: <Widget>[
            Expanded(
              child: _memoryListWidget(
                context,
                memories,
              ),
            ),
          ],
        );
      }
    } 
    else if (_controller.loadingState.value.isError) {
      return _errorWidget(_controller.loadingState.value.errorKey, context);
    } 
    else {
      Log.e(UnimplementedError('EventListState not consumed'));
      return _errorWidget("EventListState not consumed", context);
    }
  }

  Widget _memoryListWidget(BuildContext context, List<Memory> memories) {
    return Scrollbar(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          color: context.containerLayoutColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[_getItem(memories, context)],
          ),
        ),
      ),
    );
  }

  Widget _emptyListWidget(BuildContext context) {
    return Center(
        child: Text(context.translate("memory_list_no_memories_message")));
  }

  Widget _errorWidget(String errorKey, BuildContext context) {
    return Center(child: Text(context.translate(errorKey)));
  }

  void _openCreateMemory(BuildContext context) {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) {
          return const CreateMemoryView();
        });
  }

  ReorderableListView _getItem(List<Memory> memory, BuildContext context) {
    return ReorderableListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        header: SizedBox(
          height: 50,
          child: Container(
            color: context.containerLayoutColor,
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                child: Text(
                  "Event",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        children: <Widget>[
          for (Memory memory in memory)
            _MemoryListItem(
                key: ValueKey(memory.id),
                memory: memory,
                onClick: (memory) {
                    context
                    .read<HomeRouterDelegate>();
                } 
                    // .setMemoryDetailNavState(memory),
                    ,
                onStatusChange: (memory, isDone) => {}
                // memoryListBloc
                //     .add(isDone ? EventCompleted(memory) :  EventReopened(memory)),
                ),
        ],
        onReorder: (oldIndex, newIndex) {
          // memoryListBloc.add(MemoriesReordered(key, oldIndex, newIndex));
        });
  }
}

class _MemoryListItem extends StatelessWidget {
  final Memory memory;
  final Function(Memory memory) onClick;
  final Function(Memory memory, bool isDone) onStatusChange;

  const _MemoryListItem({
    super.key,
    required this.memory,
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
        //     value: memory.status == EventStatus.done,
        //     onChanged: (newState) => onStatusChange(memory, newState!)),
        trailing: const Icon(Icons.reorder),
        title: Text(memory.description),
        onTap: () => onClick(memory),
      ),
    );
  }
}
