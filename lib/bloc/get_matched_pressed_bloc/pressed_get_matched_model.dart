import 'dart:convert';

import 'package:flutter/foundation.dart';

class PressedGetMatchedModel {
  final List<String> pressedGetMatchedIds;
  PressedGetMatchedModel({required this.pressedGetMatchedIds});

  PressedGetMatchedModel copyWith({List<String>? pressedGetMatchedIds}) {
    return PressedGetMatchedModel(
      pressedGetMatchedIds: pressedGetMatchedIds ?? this.pressedGetMatchedIds,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'pressedGetMatchedIds': pressedGetMatchedIds});
    return result;
  }

  factory PressedGetMatchedModel.fromMap(Map<String, dynamic> map) {
    return PressedGetMatchedModel(
      pressedGetMatchedIds: List<String>.from(map['pressedGetMatchedIds']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PressedGetMatchedModel.fromJson(String source) =>
      PressedGetMatchedModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'PressedGetMatchedModel(pressedGetMatchedIds: $pressedGetMatchedIds)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PressedGetMatchedModel &&
        listEquals(other.pressedGetMatchedIds, pressedGetMatchedIds);
  }

  @override
  int get hashCode => pressedGetMatchedIds.hashCode;
}
