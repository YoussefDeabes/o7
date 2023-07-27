import 'Data.dart';
import 'Expiration.dart';
import 'Persistence.dart';

/// data : [{"id":3,"client_id":"c2d1f815-e39a-4f42-89cd-9eaa9f3370c6","subscription_id":2,"subscroption_name":"Rasel Subscription","status":1,"is_active":true,"corporate_id":null,"is_poromotion":true,"paid_fees":175.00,"corporate_name":null},{"id":4,"client_id":"c2d1f815-e39a-4f42-89cd-9eaa9f3370c6","subscription_id":2,"subscroption_name":"Rasel Subscription","status":1,"is_active":true,"corporate_id":null,"is_poromotion":true,"paid_fees":175.00,"corporate_name":null},{"id":5,"client_id":"c2d1f815-e39a-4f42-89cd-9eaa9f3370c6","subscription_id":2,"subscroption_name":"Rasel Subscription","status":1,"is_active":true,"corporate_id":null,"is_poromotion":true,"paid_fees":175.00,"corporate_name":null},{"id":6,"client_id":"c2d1f815-e39a-4f42-89cd-9eaa9f3370c6","subscription_id":2,"subscroption_name":"Rasel Subscription","status":1,"is_active":true,"corporate_id":null,"is_poromotion":true,"paid_fees":175.00,"corporate_name":null},{"id":7,"client_id":"c2d1f815-e39a-4f42-89cd-9eaa9f3370c6","subscription_id":2,"subscroption_name":"Rasel Subscription","status":1,"is_active":true,"corporate_id":null,"is_poromotion":true,"paid_fees":175.00,"corporate_name":null},{"id":8,"client_id":"c2d1f815-e39a-4f42-89cd-9eaa9f3370c6","subscription_id":2,"subscroption_name":"Rasel Subscription","status":1,"is_active":true,"corporate_id":null,"is_poromotion":true,"paid_fees":175.00,"corporate_name":null},{"id":9,"client_id":"c2d1f815-e39a-4f42-89cd-9eaa9f3370c6","subscription_id":2,"subscroption_name":"Rasel Subscription","status":1,"is_active":true,"corporate_id":null,"is_poromotion":true,"paid_fees":175.00,"corporate_name":null},{"id":10,"client_id":"c2d1f815-e39a-4f42-89cd-9eaa9f3370c6","subscription_id":2,"subscroption_name":"Rasel Subscription","status":1,"is_active":true,"corporate_id":null,"is_poromotion":true,"paid_fees":175.00,"corporate_name":null},{"id":11,"client_id":"c2d1f815-e39a-4f42-89cd-9eaa9f3370c6","subscription_id":2,"subscroption_name":"Rasel Subscription","status":1,"is_active":true,"corporate_id":null,"is_poromotion":true,"paid_fees":175.00,"corporate_name":null},{"id":12,"client_id":"c2d1f815-e39a-4f42-89cd-9eaa9f3370c6","subscription_id":2,"subscroption_name":"Rasel Subscription","status":1,"is_active":true,"corporate_id":null,"is_poromotion":true,"paid_fees":175.00,"corporate_name":null},{"id":13,"client_id":"c2d1f815-e39a-4f42-89cd-9eaa9f3370c6","subscription_id":2,"subscroption_name":"Rasel Subscription","status":1,"is_active":true,"corporate_id":null,"is_poromotion":true,"paid_fees":175.00,"corporate_name":null},{"id":14,"client_id":"c2d1f815-e39a-4f42-89cd-9eaa9f3370c6","subscription_id":2,"subscroption_name":"Rasel Subscription","status":1,"is_active":true,"corporate_id":null,"is_poromotion":true,"paid_fees":175.00,"corporate_name":null},{"id":15,"client_id":"c2d1f815-e39a-4f42-89cd-9eaa9f3370c6","subscription_id":2,"subscroption_name":"Rasel Subscription","status":1,"is_active":true,"corporate_id":null,"is_poromotion":true,"paid_fees":175.00,"corporate_name":null},{"id":32,"client_id":"c2d1f815-e39a-4f42-89cd-9eaa9f3370c6","subscription_id":2,"subscroption_name":"Rasel Subscription","status":1,"is_active":true,"corporate_id":null,"is_poromotion":true,"paid_fees":175.00,"corporate_name":null},{"id":35,"client_id":"c2d1f815-e39a-4f42-89cd-9eaa9f3370c6","subscription_id":2,"subscroption_name":"Rasel Subscription","status":1,"is_active":true,"corporate_id":null,"is_poromotion":true,"paid_fees":175.00,"corporate_name":null},{"id":36,"client_id":"c2d1f815-e39a-4f42-89cd-9eaa9f3370c6","subscription_id":2,"subscroption_name":"Rasel Subscription","status":1,"is_active":true,"corporate_id":null,"is_poromotion":true,"paid_fees":175.00,"corporate_name":null},{"id":37,"client_id":"c2d1f815-e39a-4f42-89cd-9eaa9f3370c6","subscription_id":2,"subscroption_name":"Rasel Subscription","status":1,"is_active":true,"corporate_id":null,"is_poromotion":true,"paid_fees":175.00,"corporate_name":null},{"id":38,"client_id":"c2d1f815-e39a-4f42-89cd-9eaa9f3370c6","subscription_id":2,"subscroption_name":"Rasel Subscription","status":1,"is_active":true,"corporate_id":null,"is_poromotion":true,"paid_fees":175.00,"corporate_name":null},{"id":41,"client_id":"c2d1f815-e39a-4f42-89cd-9eaa9f3370c6","subscription_id":2,"subscroption_name":"Rasel Subscription","status":1,"is_active":true,"corporate_id":null,"is_poromotion":true,"paid_fees":175.00,"corporate_name":null},{"id":50,"client_id":"c2d1f815-e39a-4f42-89cd-9eaa9f3370c6","subscription_id":2,"subscroption_name":"Rasel Subscription","status":2,"is_active":true,"corporate_id":null,"is_poromotion":true,"paid_fees":175.00,"corporate_name":null}]
/// error_code : 0
/// error_msg : ""
/// error_details : ""
/// expiration : {"is_allowed":false,"duration":0,"method":0,"mode":0,"is_session_expiry":false}
/// persistence : {"scope":0,"is_encrypted":false}
/// total_seconds : 0

class RasselClientSubscriptions {
  RasselClientSubscriptions({
      this.data, 
      this.errorCode, 
      this.errorMsg, 
      this.errorDetails, 
      this.expiration, 
      this.persistence, 
      this.totalSeconds,});

  RasselClientSubscriptions.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    errorCode = json['error_code'];
    errorMsg = json['error_msg'];
    errorDetails = json['error_details'];
    expiration = json['expiration'] != null ? Expiration.fromJson(json['expiration']) : null;
    persistence = json['persistence'] != null ? Persistence.fromJson(json['persistence']) : null;
    totalSeconds = json['total_seconds'];
  }
  List<Data>? data;
  num? errorCode;
  String? errorMsg;
  String? errorDetails;
  Expiration? expiration;
  Persistence? persistence;
  num? totalSeconds;
RasselClientSubscriptions copyWith({  List<Data>? data,
  num? errorCode,
  String? errorMsg,
  String? errorDetails,
  Expiration? expiration,
  Persistence? persistence,
  num? totalSeconds,
}) => RasselClientSubscriptions(  data: data ?? this.data,
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
      map['data'] = data?.map((v) => v.toJson()).toList();
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