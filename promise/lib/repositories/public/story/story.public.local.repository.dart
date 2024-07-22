
import 'package:promise/models/story/story.model.dart';
import 'package:promise/repositories/public/base/base.public.local.repository.dart';

class StoryPublicLocalRepository extends BasePublicLocalRepository<Story> {
  StoryPublicLocalRepository({super.useLocalDatabase, super.localDatabase});

}