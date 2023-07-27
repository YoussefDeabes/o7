import 'package:o7therapy/util/lang/app_localization_keys.dart';

abstract class FilterList {
  final String langKey;
  const FilterList({required this.langKey});
}

class SessionStatus implements FilterList {
  const SessionStatus._({required this.langKey});

  factory SessionStatus.completed() =>
      const SessionStatus._(langKey: LangKeys.completed);
  factory SessionStatus.missedByTherapist() =>
      const SessionStatus._(langKey: LangKeys.missedByTherapist);
  factory SessionStatus.missedByMe() =>
      const SessionStatus._(langKey: LangKeys.missedByMe);
  factory SessionStatus.canceled() =>
      const SessionStatus._(langKey: LangKeys.canceled);

  @override
  final String langKey;

  static List<FilterList> get list => [
        SessionStatus.completed(),
        SessionStatus.missedByTherapist(),
        SessionStatus.missedByMe(),
        SessionStatus.canceled(),
      ];
}

class ServicesType implements FilterList {
  const ServicesType._({required this.langKey});

  factory ServicesType.oneOnOne() =>
      const ServicesType._(langKey: LangKeys.dashedOneOnOne);
  factory ServicesType.workshops() =>
      const ServicesType._(langKey: LangKeys.workshops);
  factory ServicesType.groupTherapy() =>
      const ServicesType._(langKey: LangKeys.groupTherapy);
  factory ServicesType.assessments() =>
      const ServicesType._(langKey: LangKeys.assessments);

  @override
  final String langKey;

  static List<FilterList> get list => [
        ServicesType.oneOnOne(),
        ServicesType.workshops(),
        ServicesType.groupTherapy(),
        ServicesType.assessments(),
      ];
}
// enum SessionStatus {
//   completed(langKey: LangKeys.completed),
//   missedByTherapist(langKey: LangKeys.missedByTherapist),
//   missedByMe(langKey: LangKeys.missedByMe),
//   canceled(langKey: LangKeys.canceled);

//   const SessionStatus({
//     required this.langKey,
//   });
//   final String langKey;
// }

// enum ServicesType {
//   oneOnOne(langKey: LangKeys.oneOnOne),
//   workshops(langKey: LangKeys.workshops),
//   groupTherapy(langKey: LangKeys.groupTherapy),
//   assessments(langKey: LangKeys.assessments);

//   const ServicesType({
//     required this.langKey,
//   });
//   final String langKey;
// }
