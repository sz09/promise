/// A call that's received from the native/platform side.
typedef PlatformCallback<P> = dynamic Function(P param);

/// A call without params that's received from the native/platform side.
typedef PlatformCallbackNoParams = dynamic Function();

/// Internal. A platform call with raw unconverted params.
typedef PlatformCallbackRaw = dynamic Function(dynamic param);
