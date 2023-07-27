/// title_en : "string"
/// title_ar : "string"
/// group_name_en : "string"
/// group_name_ar : "string"

class TherapistTags {
  TherapistTags({
      this.titleEn, 
      this.titleAr, 
      this.groupNameEn, 
      this.groupNameAr,});

  TherapistTags.fromJson(dynamic json) {
    titleEn = json['title_en'];
    titleAr = json['title_ar'];
    groupNameEn = json['group_name_en'];
    groupNameAr = json['group_name_ar'];
  }
  String? titleEn;
  String? titleAr;
  String? groupNameEn;
  String? groupNameAr;
TherapistTags copyWith({  String? titleEn,
  String? titleAr,
  String? groupNameEn,
  String? groupNameAr,
}) => TherapistTags(  titleEn: titleEn ?? this.titleEn,
  titleAr: titleAr ?? this.titleAr,
  groupNameEn: groupNameEn ?? this.groupNameEn,
  groupNameAr: groupNameAr ?? this.groupNameAr,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title_en'] = titleEn;
    map['title_ar'] = titleAr;
    map['group_name_en'] = groupNameEn;
    map['group_name_ar'] = groupNameAr;
    return map;
  }

}