import 'package:flutter/material.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/features/people/bloc/people_bloc.dart';
import 'package:promise/features/people/bloc/people_event.dart';
import 'package:promise/features/people/ui/people_view.dart';
import 'package:promise/services/person/person.service.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context) {
   return BlocProvider<PeopleBloc>(
      create: (BuildContext context) => PeopleBloc(
      serviceLocator.get<PersonService>())
      ..add(LoadPeople()),
      child: const PeopleView()
    );
  }

}