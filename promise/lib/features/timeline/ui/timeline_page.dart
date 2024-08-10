import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/features/timeline/bloc/timeline_bloc.dart';
import 'package:promise/features/timeline/bloc/timeline_event.dart';
import 'package:promise/features/timeline/ui/timeline_view.dart';
import 'package:promise/services/public/story/story.service.dart';
import 'package:promise/user/user_manager.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TimelineBloc>(
        create: (BuildContext context) => TimelineBloc(
            serviceLocator.get<StoryService>(),
            serviceLocator.get<UserManager>())
          ..add(LoadTimelines()),
        child: const TimelineView()
     );
  }
}



class TimelinePage1 extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TimelineBloc>(
        create: (BuildContext context) => TimelineBloc(
            serviceLocator.get<StoryService>(),
            serviceLocator.get<UserManager>())
          ..add(LoadTimelines()),
        child: const TimelineView()
     );
  }
}
