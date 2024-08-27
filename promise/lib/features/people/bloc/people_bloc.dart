import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:promise/features/people/bloc/people_event.dart';
import 'package:promise/services/person/person.service.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/user/user_manager.dart';

import 'people_state.dart';

export 'people_state.dart';

class PeopleBloc extends Bloc<PeopleEvent, PeopleState> {
  final PersonService _personService;
  final UserManager _userManager;

  PeopleBloc(this._personService, this._userManager)
      : super(PeopleLoadInProgress()) {
    on<LoadPeople>(_onLoadPeople);
  }

  FutureOr<void> _onLoadPeople(
      LoadPeople memory, Emitter<PeopleState> emit) async {
    Log.d('PeopleCubit - Load all people');
    emit(PeopleLoadInProgress());
    try {
      final people = await _personService.fetchAsync();
      emit(PeopleLoadSuccess(people.data));
    } catch (exp) {
      emit(PeopleLoadFailure(error: exp));
    }
  }
}
