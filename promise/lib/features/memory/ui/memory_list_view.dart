import 'package:promise/features/memory/bloc/create_memory_cubit.dart';
import 'package:promise/features/memory/ui/create_memory_view.dart';
import 'package:promise/features/settings/ui/widget/nav_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promise/data/data_not_found_exception.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/features/home/router/home_router_delegate.dart';
import 'package:promise/features/memory/bloc/memory_list_bloc.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/models/memory/memory.dart';
import 'package:promise/resources/colors/color_palette.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:promise/services/memory/memory.service.dart';
import 'package:promise/util/localize.ext.dart';

class MemoryListView extends StatelessWidget {
  const MemoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MemoryListBloc, MemoryListState>(
        listener: (context, state) {
      // do stuff here based on MemoriesCubit's state
      if (state is EventOpFailure) {
        //todo display an error dialog here on top of the presented UI
        Log.e('EventOpFailure: ${state.error}');
      }
    }, builder: (context, state) {
      // return widget here based on BlocA's state, this should be a pure fn
      return Scaffold(
        body: _getBodyForState(context, state),
        drawer: createNavigationBar(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _openCreateMemory(context);
          },
          tooltip: context.translate('memory_list_create_new'),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    });
  }

  Widget _getBodyForState(BuildContext context, MemoryListState state) {
    if (state is MemoriesLoadInProgress) {
      return _loadingWidget();
    } else if (state is MemoriesLoadSuccess) {
      final List<Memory> memories = state.memories;
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
    } else if (state is EventOpFailure) {
      return _getBodyForState(context, state.prevState);
    } else if (state is MemoriesLoadFailure) {
      return _errorWidget(state, context);
    } else {
      Log.e(UnimplementedError('EventListState not consumed: $state'));
      return _errorWidget(state, context);
    }
  }

  Widget _memoryListWidget(BuildContext context, List<Memory> memories) {
    return Scrollbar(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          color: Theme.of(context).brightness == Brightness.dark
              ? ColorPalette.primaryLightD
              : ColorPalette.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[getItem(memories, context)],
          ),
        ),
      ),
    );
  }

  Widget _loadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _emptyListWidget(BuildContext context) {
    return Center(
        child: Text(
          context.translate("memory_list_no_memories_message")));
  }

  Widget _errorWidget(var state, BuildContext context) {
    String message;
    if (state is MemoriesLoadFailure && state.error is DataNotFoundException) {
      message = context.translate("memory_list_error_loading_memories");
    } else {
      message = context.translate("list_error_general");
    }
    return Center(child: Text(message));
  }

  void _openCreateMemory(BuildContext context) {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) {
          return BlocProvider<CreateMemoryCubit>(
            create: (BuildContext context) =>
                CreateMemoryCubit(serviceLocator.get<MemoryService>()),
            child: const CreateMemoryView(),
          );
        });
  }

  ReorderableListView getItem(List<Memory> memory, BuildContext context) {
    BlocProvider.of<MemoryListBloc>(context);

    return ReorderableListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        header: SizedBox(
          height: 50,
          child: Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? ColorPalette.primaryDisabledD
                : ColorPalette.backgroundGray,
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
                onClick: (memory) => context
                    .read<HomeRouterDelegate>()
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
