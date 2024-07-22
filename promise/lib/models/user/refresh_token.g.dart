part of 'refresh_token.dart';

RefreshToken _$RefreshTokenFromJson(Map<String, dynamic> json) {
  if (json.containsKey('refresh_token_issued_in')) {
    var issuedIn = DateTime.parse(json['refresh_token_issued_in'] as String);
    var refreshTokeLifetime = json['refresh_token_lifetime'] as int;
    //                                 seconds             * (to millisecond) * (to ticks)  
    final refreshTokeLifetimeInTicks = refreshTokeLifetime * 1000             * 10000 ;
    var localDate = issuedIn.toLocal();
    return RefreshToken(
      json['refresh_token'] as String,
      localDate.ticksSinceEpoch + refreshTokeLifetimeInTicks,
    );
  } else {
    var tokenFromDevice = json['refresh_token'] as Map<String, dynamic>;

    return RefreshToken(tokenFromDevice['refresh_token'] as String,
        tokenFromDevice['expires_in'] as int);
  }
}

Map<String, dynamic> _$RefreshTokenToJson(RefreshToken instance) =>
    <String, dynamic>{
      'refresh_token': instance.token,
      'expires_in': instance.expiresAt,
    };
