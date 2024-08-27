
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promise/const/text.dart';
import 'package:promise/data/data_not_found_exception.dart';
import 'package:promise/features/home/router/home_router_delegate.dart';
import 'package:promise/features/people/bloc/people_bloc.dart';
import 'package:promise/models/person/person.dart';
import 'package:promise/util/batch.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:promise/util/log/log.dart';
class PeopleView extends StatelessWidget {
  const PeopleView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PeopleBloc, PeopleState>(
        listener: (context, state) {
      // do stuff here based on PeopleCubit's state
      if (state is EventOpFailure) {
        //todo display an error dialog here on top of the presented UI
        Log.e('EventOpFailure: ${state.error}');
      }
    }, builder: (context, state) {
      // return widget here based on BlocA's state, this should be a pure fn
      return Scaffold(
        body: _getBodyForState(context, state),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // _openCreatePerson(context);
          },
          tooltip: context.translate('person_list_create_new'),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    });
  }
}

  Widget _getBodyForState(BuildContext context, PeopleState state) {
    if (state is PeopleLoadSuccess) {
      final List<Person> people = state.people;
      // people.add(Person(id: "id", nickname: '@her'));
      // people.add(Person(id: "id1", nickname: '@me'));
      // people.add(Person(id: "id2", nickname: '@mom'));
      // people.add(Person(id: "id3", nickname: '@dad'));
      // people.add(Person(id: "id4", nickname: '@grandpa'));

      var batchPeople = batch(people, 2);
      if (batchPeople.isEmpty) {
        return _emptyListWidget(context);
      } else {
        return Column(
          children: <Widget>[
            Expanded(
              child: _peopleListWidget(
                context,
                batchPeople,
              ),
            ),
          ],
        );
      }
    } else if (state is EventOpFailure) {
      return _getBodyForState(context, state.prevState);
    } else if (state is PeopleLoadFailure) {
      return _errorWidget(state, context);
    } else {
      Log.e(UnimplementedError('EventListState not consumed: $state'));
      return _errorWidget(state, context);
    }
  }

  
  Widget _emptyListWidget(BuildContext context) {
    return Center(
        child: Text(
          context.translate("person_list_no_memories_message")));
  }

  Widget _errorWidget(var state, BuildContext context) {
    String message;
    if (state is PeopleLoadFailure && state.error is DataNotFoundException) {
      message = context.translate("person_list_error_loading_memories");
    } else {
      message = context.translate("list_error_general");
    }
    return Center(child: Text(message));
  }
  

  Widget _peopleListWidget(BuildContext context, List<List<Person>> batchPeople) {
    return Scrollbar(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ListView(
          // color: context.containerLayoutColor,
          children: _getRow(context, batchPeople)
          ,
        ),
      ),
    );
  }

  List<Row> _getRow(BuildContext context, List<List<Person>> batchPeople){
    return batchPeople.map((item) => Row(
      key: Key("row_${item.map((i) => i.id).join("_")}"),
      children: [
        Column(
          key: Key("column_${item.map((i) => i.id).join("_")}"),
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[_getItem(item, context)],
      )]
    )).toList();
  }
  
  Column _getItem(List<Person> people, BuildContext context) {
    BlocProvider.of<PeopleBloc>(context);

    return Column(
        // shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          for (Person person in people)
            _PersonListItem(
                key: ValueKey(person.id),
                person: person,
                onClick: (person) => context
                    .read<HomeRouterDelegate>()
                    // .setPersonDetailNavState(person),
                    ,
                onStatusChange: (person, isDone) => {}
                // personListBloc
                //     .add(isDone ? EventCompleted(person) :  EventReopened(person)),
                ),
        ]);
  }

  
class _PersonListItem extends StatelessWidget {
  final Person person;
  final Function(Person person) onClick;
  final Function(Person person, bool isDone) onStatusChange;

  const _PersonListItem({
    super.key,
    required this.person,
    required this.onClick,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Ink(
      color: themeData.cardColor,
      child: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: context.containerLayoutColor,
          borderRadius: BorderRadius.circular(5),
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(color: context.containerLayoutColor, spreadRadius: 3)
          ],
          border: Border.all(color: context.borderColor)
        ),
        
        child: Row(
          children: [
            const SizedBox(width: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(
                    person.nickname,
                    style: const TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ])
              ],
            )
          ],
        ),
      ),
    ));
  }
}