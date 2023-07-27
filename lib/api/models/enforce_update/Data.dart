class Data {
  Data({
      this.isLatest, 
      this.forceUpdate, 
      this.storeUrl,});

  Data.fromJson(dynamic json) {
    isLatest = json['is_latest'];
    forceUpdate = json['force_update'];
    storeUrl = json['store_url'];
  }
  bool? isLatest;
  bool? forceUpdate;
  String? storeUrl;
Data copyWith({  bool? isLatest,
  bool? forceUpdate,
  String? storeUrl,
}) => Data(  isLatest: isLatest ?? this.isLatest,
  forceUpdate: forceUpdate ?? this.forceUpdate,
  storeUrl: storeUrl ?? this.storeUrl,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_latest'] = isLatest;
    map['force_update'] = forceUpdate;
    map['store_url'] = storeUrl;
    return map;
  }

}