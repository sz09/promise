import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/features/people/controller/controllerr.dart';
import 'package:promise/main.dart';
import 'package:promise/models/person/person.dart';
import 'package:promise/services/person/person.service.dart';
import 'package:promise/util/batch.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';
import 'package:promise/widgets/loading_overlay.dart';

final _controller = Get.find<PeopleController>(tag: applicationTag);

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});
  
  static void openCreatePerson(BuildContext context) {
    // showModalBottomSheet(
    //   context: context,
    //   builder: (context) {
    //     return const CreateMemoryView();
    //   });
  }
  
  @override
  State<StatefulWidget> createState() {
    return _StatePeoplePage();
  }
}

class _StatePeoplePage extends State<PeoplePage> {
  final int _batchSize = 2;
  final PersonService personService = serviceLocator.get<PersonService>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  _loadData(){
    _controller.loadData(personService.getUsersWithHint);
    _controller.loadPromiseCountByPerson();
  }
  @override
  void dispose() {
    _controller.reset();
    _controller.resetPromiseData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _getBodyForState(context)),
    );
  }

  Widget _getBodyForState(BuildContext context) {
    if (!_controller.loadingState.value.isInprogress) {
      final List<Person> people = _controller.items;
      var batchPeople = batch(people, _batchSize);
      if (batchPeople.isEmpty) {
        return _emptyListWidget(context);
      } else {
        return _peopleListWidget(
          context,
          batchPeople,
        );
      }
    } else if (_controller.loadingState.value.isError) {
      return _errorWidget(_controller.loadingState.value.errorKey, context);
    } else if (_controller.loadingState.value.isInprogress) {
      return loadingWidget();
    }

    return Container();
  }

  Widget _emptyListWidget(BuildContext context) {
    return Center(
        child: Text(context.translate("person_list_no_memories_message")));
  }

  Widget _errorWidget(String errorKey, BuildContext context) {
    return Center(child: Text(context.translate(errorKey)));
  }

  Widget _peopleListWidget(
      BuildContext context, List<List<Person>> batchPeople) {
    return ListView.builder(
      itemCount: batchPeople.length,
      itemBuilder: (context, index) {
        var people = batchPeople[index];
        return Padding(
          padding: paddingTop,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            for (int i = 0; i < _batchSize; i++)
              people.length > i
                  ? _PersonListItem(
                      key: ValueKey(people[i].id),
                      currentUserId: personService.localRepository.userId,
                      person: people[i],
                      onTap: (person) {},
                    )
                  : Expanded(child: Container())
          ]),
        );
      },
    );
  }
}

class _PersonListItem extends StatelessWidget {
  final String currentUserId;
  final Person person;
  final Function(Person person) onTap;
  _PersonListItem({super.key, required this.currentUserId, required this.person, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
      onTap: () {
        onTap(person);
      },
      child: Card(
        elevation: 4,
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
                        Text(
                          _getDisplayName(context),
                          style: TextStyle(
                            fontSize: _isYou ? context.fontLargeSize : context.fontSize,
                            fontWeight: _isYou ? FontWeight.bold: FontWeight.normal
                          ),
                        ),
                        Padding(
                            padding: halfPaddingTop,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(() => _controller.loadingPromiseState
                                              .value.completed &&
                                          _controller
                                              .loadingState.value.completed
                                      ? Text("${context.translate('person.promise_count_label')}: ${_mapPersonPromiseCount[person.userId]}")
                                      : Container()),
                                  // _dueDate(promise)
                                ]))
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  String _getDisplayName(BuildContext context){
    if(_isYou){
      return context.translate('person.you');
    }
    else {
      late String displayName = '';
      if(person.firstName.isNotEmpty){
        displayName += person.firstName;
      }
      
      if(person.lastName.isNotEmpty){
        displayName += (displayName.isNotEmpty ? ' ' : '') +  person.lastName;
      }

      return person.nickname + (displayName.isNotEmpty ? '($displayName)': '');
    }
  }

  bool get _isYou => currentUserId == person.userId;
  Map<String, int>? _mapPersonPromiseCountCache = null;
  Map<String, int> get _mapPersonPromiseCount {
    loadPersonPromiseCountFunc() {
      return _controller.items.value.map((person) {
        late int count = 0;
        if (person.userId == currentUserId) {
          count = _controller.promises.value.where((d) => d.forYourself).length;
        } else {
          count = _controller.promises.value
              .where((e) => e.to?.contains(person.userId) ?? false)
              .length;
        }
        return {person.userId: count};
      });
    }

    return _mapPersonPromiseCountCache ??= {
      for (var item in loadPersonPromiseCountFunc()) item.keys.first: item.values.first
    };
  }
  // Widget _dueDate(Promise promise){
  //   if(promise.expectedTime != null){
  //     return Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
  //       decoration: BoxDecoration(
  //         color: Colors.transparent,
  //         borderRadius: BorderRadius.circular(12.0),
  //       ),
  //       child: Text(
  //         promise.expectedTime!.asString(true),
  //         style: const TextStyle(
  //           fontStyle: FontStyle.italic
  //         ),
  //       ),
  //     );
  //   }

  //   return Container();
  // }
}
