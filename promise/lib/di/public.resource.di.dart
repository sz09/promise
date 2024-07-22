import 'package:get_it/get_it.dart';
import 'package:promise/networks/dio/dio.client.dart';
import 'package:promise/repositories/public/story/story.public.local.repository.dart';
import 'package:promise/repositories/public/story/story.public.remote.repository.dart';
import 'package:promise/services/public/story/story.service.dart';

extension PulicResourceDIExtension on GetIt {
  GetIt registerDIForPublicResources(DioClient client){
    final storyPublicRemoteRepository = StoryPublicRemoteRepository(client: client);
    final storyPublicLocalRepository = StoryPublicLocalRepository();
    this..registerSingleton<StoryPublicRemoteRepository>(storyPublicRemoteRepository)
        ..registerSingleton<StoryPublicLocalRepository>(storyPublicLocalRepository)
        ..registerSingleton<StoryService>(StoryService(remoteRepository: storyPublicRemoteRepository, localRepository: storyPublicLocalRepository,));
    return this;
  }
}