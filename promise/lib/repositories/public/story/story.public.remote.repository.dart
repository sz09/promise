import 'package:promise/models/story/story.model.dart';
import 'package:promise/repositories/public/base/base.public.remote.repository.dart';

class StoryPublicRemoteRepository extends BasePublicRemoteRepository<Story> {
  StoryPublicRemoteRepository({required super.client});
  
  @override
  String path = "/stories";
  
  @override
  Story Function(Map<String, dynamic> p1) itemFactoryMethod = Story.fromJson;

}