/// image_code : "IMG_2021-06-14-10_44160.png"
/// url : "/api/identity/imgapi/IMG_2021-06-14-10_44160.png"

class TherapistImage {
  TherapistImage({
      this.imageCode, 
      this.url,});

  TherapistImage.fromJson(dynamic json) {
    imageCode = json['image_code'];
    url = json['url'];
  }
  String? imageCode;
  String? url;
TherapistImage copyWith({  String? imageCode,
  String? url,
}) => TherapistImage(  imageCode: imageCode ?? this.imageCode,
  url: url ?? this.url,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image_code'] = imageCode;
    map['url'] = url;
    return map;
  }

}