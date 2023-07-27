import 'dart:convert';

class UsersDismissedRasselCardModel {
  final List<String> usersMails;

  UsersDismissedRasselCardModel(this.usersMails);

  UsersDismissedRasselCardModel copyWith({
    List<String>? usersMails,
  }) {
    return UsersDismissedRasselCardModel(
      usersMails ?? this.usersMails,
    );
  }

  Map<String, dynamic> toMap() {
    return {'usersMails': usersMails};
  }

  factory UsersDismissedRasselCardModel.fromMap(Map<String, dynamic> map) {
    return UsersDismissedRasselCardModel(
      List<String>.from(map['usersMails']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UsersDismissedRasselCardModel.fromJson(String source) =>
      UsersDismissedRasselCardModel.fromMap(json.decode(source));

  @override
  String toString() => 'UsersDismissedRasselCard(usersMails: $usersMails)';
}
