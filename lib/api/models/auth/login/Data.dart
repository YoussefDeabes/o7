import 'Claims.dart';

class Data {
  Data({
    this.userDisplayName,
    this.userId,
    this.allowedRoles,
    this.resetPasswordRequired,
    this.claims,
    this.accessToken,
    this.tokenType,
    this.expiresInSeconds,
    this.refreshToken,
    this.accessTokenType,
  });

  Data.fromJson(dynamic json) {
    userDisplayName = json['user_display_name'];
    userId = json['user_id'];
    allowedRoles = json['allowed_roles'] != null
        ? json['allowed_roles'].cast<String>()
        : [];
    resetPasswordRequired = json['reset_password_required'];
    claims = json['claims'] != null ? Claims.fromJson(json['claims']) : null;
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresInSeconds = json['expires_in_seconds'];
    refreshToken = json['refresh_token'];
    accessTokenType = json['access_token_type'];
  }
  String? userDisplayName;
  String? userId;
  List<String>? allowedRoles;
  bool? resetPasswordRequired;
  Claims? claims;
  String? accessToken;
  String? tokenType;
  int? expiresInSeconds;
  String? refreshToken;
  String? accessTokenType;
  Data copyWith({
    String? userDisplayName,
    String? userId,
    List<String>? allowedRoles,
    bool? resetPasswordRequired,
    Claims? claims,
    String? accessToken,
    String? tokenType,
    int? expiresInSeconds,
    String? refreshToken,
    String? accessTokenType,
  }) =>
      Data(
        userDisplayName: userDisplayName ?? this.userDisplayName,
        userId: userId ?? this.userId,
        allowedRoles: allowedRoles ?? this.allowedRoles,
        resetPasswordRequired:
            resetPasswordRequired ?? this.resetPasswordRequired,
        claims: claims ?? this.claims,
        accessToken: accessToken ?? this.accessToken,
        tokenType: tokenType ?? this.tokenType,
        expiresInSeconds: expiresInSeconds ?? this.expiresInSeconds,
        refreshToken: refreshToken ?? this.refreshToken,
        accessTokenType: accessTokenType ?? this.accessTokenType,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_display_name'] = userDisplayName;
    map['user_id'] = userId;
    map['allowed_roles'] = allowedRoles;
    map['reset_password_required'] = resetPasswordRequired;
    if (claims != null) {
      map['claims'] = claims?.toJson();
    }
    map['access_token'] = accessToken;
    map['token_type'] = tokenType;
    map['expires_in_seconds'] = expiresInSeconds;
    map['refresh_token'] = refreshToken;
    map['access_token_type'] = accessTokenType;
    return map;
  }
}
