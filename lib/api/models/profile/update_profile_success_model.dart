/// error_code : 0
/// error_msg : ""
/// error_details : ""
/// expiration : {"is_allowed":false,"duration":0,"method":0,"mode":0,"is_session_expiry":false}
/// persistence : {"scope":0,"is_encrypted":false}
/// total_seconds : 0

class UpdateProfileSuccessModel {
  UpdateProfileSuccessModel({
    int? errorCode,
    String? errorMsg,
    String? errorDetails,
    Expiration? expiration,
    Persistence? persistence,
    int? totalSeconds,
  }) {
    _errorCode = errorCode;
    _errorMsg = errorMsg;
    _errorDetails = errorDetails;
    _expiration = expiration;
    _persistence = persistence;
    _totalSeconds = totalSeconds;
  }

  UpdateProfileSuccessModel.fromJson(dynamic json) {
    _errorCode = json['error_code'];
    _errorMsg = json['error_msg'];
    _errorDetails = json['error_details'];
    _expiration = json['expiration'] != null
        ? Expiration.fromJson(json['expiration'])
        : null;
    _persistence = json['persistence'] != null
        ? Persistence.fromJson(json['persistence'])
        : null;
    _totalSeconds = json['total_seconds'];
  }
  int? _errorCode;
  String? _errorMsg;
  String? _errorDetails;
  Expiration? _expiration;
  Persistence? _persistence;
  int? _totalSeconds;
  UpdateProfileSuccessModel copyWith({
    int? errorCode,
    String? errorMsg,
    String? errorDetails,
    Expiration? expiration,
    Persistence? persistence,
    int? totalSeconds,
  }) =>
      UpdateProfileSuccessModel(
        errorCode: errorCode ?? _errorCode,
        errorMsg: errorMsg ?? _errorMsg,
        errorDetails: errorDetails ?? _errorDetails,
        expiration: expiration ?? _expiration,
        persistence: persistence ?? _persistence,
        totalSeconds: totalSeconds ?? _totalSeconds,
      );
  int? get errorCode => _errorCode;
  String? get errorMsg => _errorMsg;
  String? get errorDetails => _errorDetails;
  Expiration? get expiration => _expiration;
  Persistence? get persistence => _persistence;
  int? get totalSeconds => _totalSeconds;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error_code'] = _errorCode;
    map['error_msg'] = _errorMsg;
    map['error_details'] = _errorDetails;
    if (_expiration != null) {
      map['expiration'] = _expiration?.toJson();
    }
    if (_persistence != null) {
      map['persistence'] = _persistence?.toJson();
    }
    map['total_seconds'] = _totalSeconds;
    return map;
  }
}

/// scope : 0
/// is_encrypted : false

class Persistence {
  Persistence({
    int? scope,
    bool? isEncrypted,
  }) {
    _scope = scope;
    _isEncrypted = isEncrypted;
  }

  Persistence.fromJson(dynamic json) {
    _scope = json['scope'];
    _isEncrypted = json['is_encrypted'];
  }
  int? _scope;
  bool? _isEncrypted;
  Persistence copyWith({
    int? scope,
    bool? isEncrypted,
  }) =>
      Persistence(
        scope: scope ?? _scope,
        isEncrypted: isEncrypted ?? _isEncrypted,
      );
  int? get scope => _scope;
  bool? get isEncrypted => _isEncrypted;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['scope'] = _scope;
    map['is_encrypted'] = _isEncrypted;
    return map;
  }
}

/// is_allowed : false
/// duration : 0
/// method : 0
/// mode : 0
/// is_session_expiry : false

class Expiration {
  Expiration({
    bool? isAllowed,
    int? duration,
    int? method,
    int? mode,
    bool? isSessionExpiry,
  }) {
    _isAllowed = isAllowed;
    _duration = duration;
    _method = method;
    _mode = mode;
    _isSessionExpiry = isSessionExpiry;
  }

  Expiration.fromJson(dynamic json) {
    _isAllowed = json['is_allowed'];
    _duration = json['duration'];
    _method = json['method'];
    _mode = json['mode'];
    _isSessionExpiry = json['is_session_expiry'];
  }
  bool? _isAllowed;
  int? _duration;
  int? _method;
  int? _mode;
  bool? _isSessionExpiry;
  Expiration copyWith({
    bool? isAllowed,
    int? duration,
    int? method,
    int? mode,
    bool? isSessionExpiry,
  }) =>
      Expiration(
        isAllowed: isAllowed ?? _isAllowed,
        duration: duration ?? _duration,
        method: method ?? _method,
        mode: mode ?? _mode,
        isSessionExpiry: isSessionExpiry ?? _isSessionExpiry,
      );
  bool? get isAllowed => _isAllowed;
  int? get duration => _duration;
  int? get method => _method;
  int? get mode => _mode;
  bool? get isSessionExpiry => _isSessionExpiry;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_allowed'] = _isAllowed;
    map['duration'] = _duration;
    map['method'] = _method;
    map['mode'] = _mode;
    map['is_session_expiry'] = _isSessionExpiry;
    return map;
  }
}
