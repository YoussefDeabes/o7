import 'package:o7therapy/api/models/guest_therapist_list/List.dart';

/// list : [{"currency":"USD","can_prescribe":true,"languages":["Arabic","English"],"tags":["stress","Anxiety","dewdwe","couple","hello","art therapys tag","Maternal Mental Health","Anger Management","sdfsdf","Suscipit debitis sun","type of 2","type of 3","type of 4","type of 5"],"id":"4f878040-b809-421d-9fac-6c9e228425d3","title":"","name":"mido min","profession":"sadasd","image":{"image_code":"IMG_2021-06-10-12_84943.png","url":"/api/identity/imgapi/IMG_2021-06-10-12_84943.png"},"biography_text_summary":"werwer","fees_per_session":300.0,"biography_video":{"url":"https://www.youtube.com/embed/j1gU2oGFayY","code":null,"name":null},"first_available_slot_date":"20221212120000","session_advance_notice_period":0,"accept_new_client":true,"years_of_experience":5},{"currency":"USD","can_prescribe":true,"languages":["Arabic","English","French"],"tags":["Accidents ertgerterterwtwerterwterwtertertewrterwtertretrewtrewterwtertretertre","Maternal Mental Health","Anger Management","sdfsdf","Suscipit debitis sun","Adult","Geriatrics","Art Therapy"],"id":"053a57a9-01fe-4d81-ac2a-8f7e7b5a88aa","title":"Dr.","name":"Emilia Clark","profession":"Therapist","image":{"image_code":"IMG_2022-10-25-10_5131.jpg","url":"/api/identity/imgapi/IMG_2022-10-25-10_5131.jpg"},"biography_text_summary":"Counseling Psychologist, Marriage and Family Therapist","fees_per_session":800.0,"biography_video":{"url":"https://www.youtube.com/embed/f4oH1FIWe7o","code":null,"name":null},"first_available_slot_date":"20221218113000","session_advance_notice_period":null,"accept_new_client":true,"years_of_experience":8},{"currency":"USD","can_prescribe":false,"languages":["Arabic","English"],"tags":[null,null,null],"id":"05fb49bb-e27a-4f24-9a1f-6b3baddfce3f","title":"","name":"Joseph Gamil","profession":"Cognitive behavioral therapist","image":{"image_code":"IMG_2020-05-16-10_51305.png","url":"/api/identity/imgapi/IMG_2020-05-16-10_51305.png"},"biography_text_summary":"Cognitive behavioral therapist that can treat people from  Geriatric therapy","fees_per_session":300.0,"biography_video":{"url":"https://www.youtube.com/embed/6765g","code":null,"name":null},"first_available_slot_date":null,"session_advance_notice_period":null,"accept_new_client":true,"years_of_experience":7},{"currency":"USD","can_prescribe":false,"languages":["English"],"tags":["Anger Management","sdfsdf","xxxx","Geriatrics"],"id":"073b325c-7f27-4c19-8a2c-9b0867677bc8","title":"Prof. Dr.","name":"Deacon Gonzalez","profession":"Deserunt esse venia","image":{"image_code":"IMG_2022-01-16-12_39897.png","url":"/api/identity/imgapi/IMG_2022-01-16-12_39897.png"},"biography_text_summary":"Sit enim minus sunt exercitationem eius nobis est","fees_per_session":50.0,"biography_video":{"url":"https://www.youtube.com/embed/LHNctz7E7VA","code":null,"name":null},"first_available_slot_date":null,"session_advance_notice_period":0,"accept_new_client":true,"years_of_experience":3},{"currency":"USD","can_prescribe":false,"languages":["Arabic","English"],"tags":[null,null,null],"id":"5034a8c9-bec1-4fc8-99a6-d54fbb986262","title":"Dr.","name":"Aya Taha3","profession":"Addiction s","image":{"image_code":"IMG_2020-02-13-07_67671.png","url":"/api/identity/imgapi/IMG_2020-02-13-07_67671.png"},"biography_text_summary":"Addiction therapy","fees_per_session":20.0,"biography_video":{"url":"https://www.youtube.com/embed/_h5FsJ3ppQQ%22","code":null,"name":null},"first_available_slot_date":null,"session_advance_notice_period":0,"accept_new_client":true,"years_of_experience":4}]
/// total_count : 112
/// has_more : true

class Data {
  Data({
      this.list, 
      this.totalCount, 
      this.hasMore,});

  Data.fromJson(dynamic json) {
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list?.add(TherapistsList.fromJson(v));
      });
    }
    totalCount = json['total_count'];
    hasMore = json['has_more'];
  }
  List<TherapistsList>? list;
  num? totalCount;
  bool? hasMore;
Data copyWith({  List<TherapistsList>? list,
  num? totalCount,
  bool? hasMore,
}) => Data(  list: list ?? this.list,
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