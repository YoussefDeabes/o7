import 'Data.dart';
import 'Expiration.dart';
import 'Persistence.dart';

/// data : {"biography_text":"string","years_of_experience":0,"fees_per_international_session":0,"specialties_ids":[0],"tags_ids":[0],"languages_ids":[0],"can_assess":true,"can_prescribe":true,"therapist_tags":[{"title_en":"string","title_ar":"string","group_name_en":"string","group_name_ar":"string"}],"therapist_currencies":[{"therapist_id":"string","currency_id":0,"currency":{"id":0,"currency_code":"string","currency_name_ar":"string","currency_name_en":"string"},"value":0}],"currency":"string","flat_rate":true,"is_old_client":true,"client_in_debt":true,"id":"string","title":"string","name":"string","profession":"string","image":{"image_code":"string","url":"string"},"biography_text_summary":"string","fees_per_session":0,"biography_video":{"url":"string","code":"string","name":"string"},"first_available_slot_date":"string","session_advance_notice_period":0,"accept_new_client":true}
/// error_code : 0
/// error_msg : "string"
/// error_details : "string"
/// expiration : {"is_allowed":true,"duration":0,"method":0,"mode":0,"is_session_expiry":true}
/// persistence : {"scope":0,"is_encrypted":true}
/// total_seconds : 0

class TherapistBio {
  TherapistBio({
      this.data, 
      this.errorCode, 
      this.errorMsg, 
      this.errorDetails, 
      this.expiration, 
      this.persistence, 
      this.totalSeconds,});

  TherapistBio.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    errorCode = json['error_code'];
    errorMsg = json['error_msg'];
    errorDetails = json['error_details'];
    expiration = json['expiration'] != null ? Expiration.fromJson(json['expiration']) : null;
    persistence = json['persistence'] != null ? Persistence.fromJson(json['persistence']) : null;
    totalSeconds = json['total_seconds'];
  }
  Data? data;
  int? errorCode;
  String? errorMsg;
  String? errorDetails;
  Expiration? expiration;
  Persistence? persistence;
  int? totalSeconds;
TherapistBio copyWith({  Data? data,
  int? errorCode,
  String? errorMsg,
  String? errorDetails,
  Expiration? expiration,
  Persistence? persistence,
  int? totalSeconds,
}) => TherapistBio(  data: data ?? this.data,
  errorCode: errorCode ?? this.errorCode,
  errorMsg: errorMsg ?? this.errorMsg,
  errorDetails: errorDetails ?? this.errorDetails,
  expiration: expiration ?? this.expiration,
  persistence: persistence ?? this.persistence,
  totalSeconds: totalSeconds ?? this.totalSeconds,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['error_code'] = errorCode;
    map['error_msg'] = errorMsg;
    map['error_details'] = errorDetails;
    if (expiration != null) {
      map['expiration'] = expiration?.toJson();
    }
    if (persistence != null) {
      map['persistence'] = persistence?.toJson();
    }
    map['total_seconds'] = totalSeconds;
    return map;
  }

}