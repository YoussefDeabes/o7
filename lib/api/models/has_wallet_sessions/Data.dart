import 'package:o7therapy/api/models/has_wallet_sessions/List.dart';

/// list : [{"therapist_id":"0e8d8019-5b1a-499c-92ea-a564550eeab6","therapist_name":"Zaina Hossam","therapist_profession":"En","therapist_image":{"image_code":"IMG_2021-06-14-10_44160.png","url":"/api/identity/imgapi/IMG_2021-06-14-10_44160.png"},"fees_per_session":6000.00,"fees_per_international_session":9000.00,"first_available_slot_date":null,"session_advance_notice_period":null,"currency":"EGP","patient_wallet":[{"id":19,"duration":50.00}]}]
/// total_count : 1
/// has_more : false

class WalletSessionsData {
  WalletSessionsData({
    this.list,
    this.totalCount,
    this.hasMore,
  });

  WalletSessionsData.fromJson(dynamic json) {
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list?.add(HasWalletSessionsList.fromJson(v));
      });
    }
    totalCount = json['total_count'];
    hasMore = json['has_more'];
  }

  List<HasWalletSessionsList>? list;
  int? totalCount;
  bool? hasMore;

  WalletSessionsData copyWith({
    List<HasWalletSessionsList>? list,
    int? totalCount,
    bool? hasMore,
  }) =>
      WalletSessionsData(
        list: list ?? this.list,
        totalCount: totalCount ?? this.totalCount,
        hasMore: hasMore ?? this.hasMore,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (list != null) {
      map['list'] = list?.map((v) => v.toJson()).toList();
    }
    map['total_count'] = totalCount;
    map['has_more'] = hasMore;
    return map;
  }
}
