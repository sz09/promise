import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:promise/const/text.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/features/home/router/home_router_delegate.dart';
import 'package:promise/features/people/controller/controllerr.dart';
import 'package:promise/main.dart';
import 'package:promise/models/person/person.dart';
import 'package:promise/services/person/person.service.dart';
import 'package:promise/util/batch.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:promise/util/log/log.dart';
import 'package:provider/provider.dart';

final _controller = Get.find<PeopleController>(tag: applicationTag);
class MePage extends StatelessWidget {
  
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    _controller.loadData(serviceLocator.get<PersonService>().fetchAsync);
   return  const MeView();
  }
}

class MeView extends StatelessWidget {
  const MeView({super.key});
  @override
  Widget build(BuildContext context) {
   return Scaffold(
        body: Obx(() => _getBodyForState(context)),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // _openCreatePerson(context);
          },
          tooltip: context.translate('person_list_create_new'),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
  }
}

  Widget _getBodyForState(BuildContext context) {
    if (!_controller.loadingState.value.isInprogress) {
      final List<Person> people = _controller.items;
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
    } else if (_controller.loadingState.value.isError) {
      return _errorWidget(_controller.loadingState.value.errorKey, context);
    } 
    else {
      Log.e(UnimplementedError('EventListState not consumed'));
      return _errorWidget("EventListState not consumed", context);
    }
  }

  
  Widget _emptyListWidget(BuildContext context) {
    return Center(
        child: Text(
          context.translate("person_list_no_memories_message")));
  }

  Widget _errorWidget(String errorKey, BuildContext context) {
    return Center(child: Text(context.translate(errorKey)));
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