/// url : "https://www.youtube.com/embed/j1gU2oGFayY"
/// code : null
/// name : null

class BiographyVideo {
  BiographyVideo({
      this.url, 
      this.code, 
      this.name,});

  BiographyVideo.fromJson(dynamic json) {
    url = json['url'];
    code = json['code'];
    name = json['name'];
  }
  String? url;
  dynamic code;
  dynamic name;
BiographyVideo copyWith({  String? url,
  dynamic code,
  dynamic name,
}) => BiographyVideo(  url: url ?? this.url,
  code: code ?? this.code,
  name: name ?? this.name,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    map['code'] = code;
    map['name'] = name;
    return map;
  }

}