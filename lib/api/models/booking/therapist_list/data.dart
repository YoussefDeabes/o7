import 'package:o7therapy/api/models/booking/therapist_list/list_element.dart';

class Data {
  Data({
    this.list,
    this.totalCount,
    this.hasMore,
  });

  Data.fromJson(dynamic json) {
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list?.add(ListElement.fromJson(v));
      });
    }
    totalCount = json['total_count'];
    hasMore = json['has_more'];
  }

  List<ListElement>? list;
  int? totalCount;
  bool? hasMore;

  Data copyWith({
    List<ListElement>? list,
    int? totalCount,
    bool? hasMore,
  }) =>
      Data(
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
