import 'package:promise/features/promise/bloc/create_promise_cubit.dart';
import 'package:promise/features/promise/ui/create_promise_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promise/data/data_not_found_exception.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/features/promise/bloc/promise_list_bloc.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/models/promise/promise.dart';
import 'package:promise/resources/colors/color_palette.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:promise/services/promise/promise.service.dart';
import 'package:promise/util/localize.ext.dart';

class PromiseListView extends StatelessWidget {
  const PromiseListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PromiseListBloc, PromiseListState>(
        listener: (context, state) {
      // do stuff here based on PromisesCubit's state
      if (state is EventOpFailure) {
        //todo display an error dialog here on top of the presented UI
        Log.e('EventOpFailure: ${state.error}');
      }
    }, builder: (context, state) {
      // return widget here based on BlocA's state, this should be a pure fn
      return Scaffold(
        appBar: AppBar(
          title: Text(context.translate('promise.title')),
          automaticallyImplyLeading: false,
        ),
        body: _getBodyForState(context, state),
        // drawer: createNavigationBar(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _openCreatePromise(context);
          },
          tooltip: context.translate('promise_list_create_new'),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    });
  }

  Widget _getBodyForState(BuildContext context, PromiseListState state) {
    if (state is PromisesLoadInProgress) {
      return _loadingWidget();
    } else if (state is PromisesLoadSuccess) {
      final List<Promise> memories = state.memories;
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
    } else if (state is EventOpFailure) {
      return _getBodyForState(context, state.prevState);
    } else if (state is PromisesLoadFailure) {
      return _errorWidget(state, context);
    } else {
      Log.e(UnimplementedError('EventListState not consumed: $state'));
      return _errorWidget(state, context);
    }
  }

  Widget _promiseListWidget(BuildContext context, List<Promise> memories) {
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
          context.translate("promise_list_no_promises_message")
        )
      );
  }

  Widget _errorWidget(var state, BuildContext context) {
    String message;
    if (state is PromisesLoadFailure && state.error is DataNotFoundException) {
      message = context.translate("promise_list_error_loading_memories");
    } else {
      message = context.translate("list_error_general");
    }
    return Center(child: Text(message));
  }

  void _openCreatePromise(BuildContext context) {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) {
          return BlocProvider<CreatePromiseCubit>(
            create: (BuildContext context) =>
                CreatePromiseCubit(serviceLocator.get<PromiseService>()),
            child: const CreatePromiseView(),
          );
        });
  }

  ReorderableListView getItem(List<Promise> promise, BuildContext context) {
    BlocProvider.of<PromiseListBloc>(context);

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
        title: Text(promise.description),
        onTap: () => onClick(promise),
      ),
    );
  }
}
