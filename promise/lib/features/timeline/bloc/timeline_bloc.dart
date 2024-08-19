import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:promise/features/timeline/bloc/timeline_event.dart';
import 'package:promise/features/timeline/bloc/timeline_state.dart';
import 'package:promise/features/timeline/widget/timeline.dart';
import 'package:promise/services/public/story/story.service.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/user/user_manager.dart';
import 'package:promise/util/string_util.dart';

export 'timeline_state.dart';

class TimelineBloc extends Bloc<TimelineEvent, TimelineState> {
  final StoryService _storyService;
  final UserManager _userManager;

  TimelineBloc(this._storyService, this._userManager)
      : super(TimelineLoadInProgress()) {
    on<LoadTimelines>(_onLoadTimeline);
    on<Logout>(_onLogout);
  }

  FutureOr<void> _onLoadTimeline(
      LoadTimelines promise, Emitter<TimelineState> emit) async {
    Log.d('TimelineCubit - Load all ${(TimelineItem).toPlural()}');
    emit(TimelineLoadInProgress());
    try {
      final pageResult = await _storyService.fetchAsync();
      int x = 0;
      var timelineItems = pageResult.data.map((d) => 
        TimelineItem(title: 'title ${x++}', user: d.user, description: d.content, time: DateTime.now())
      ).toList();
      emit(TimelineLoadSuccess(timelineItems));
    } catch (exp) {
      emit(TimelineLoadFailure(error: exp));
    }
  }

  FutureOr<void> _onLogout(Logout promise, Emitter<TimelineState> emit) async {
    await _userManager.logout();
  }
}
