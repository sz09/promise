import 'package:promise/models/story/story.model.dart';
import 'package:promise/services/public/base/base.service.dart';

class StoryService extends BasePublicService<Story> {
  StoryService({required super.remoteRepository, required super.localRepository});

}