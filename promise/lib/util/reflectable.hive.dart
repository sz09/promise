import 'package:reflectable/reflectable.dart';

class HiveTypeReflector extends Reflectable {
  const HiveTypeReflector()
      : super(
          metadataCapability,
          invokingCapability,
          typeCapability,
        );
}

const hiveTypeReflector = HiveTypeReflector();