class Image {
  Image({
      this.imageCode, 
      this.url,});

  Image.fromJson(dynamic json) {
    imageCode = json['image_code'];
    url = json['url'];
  }
  String? imageCode;
  String? url;
Image copyWith({  String? imageCode,
  String? url,
}) => Image(  imageCode: imageCode ?? this.imageCode,
  url: url ?? this.url,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image_code'] = imageCode;
    map['url'] = url;
    return map;
  }

}