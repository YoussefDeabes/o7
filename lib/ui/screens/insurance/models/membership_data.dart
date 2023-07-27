class MembershipData {
  String? _membershipNumber;

  MembershipData._();
  static final MembershipData _instance = MembershipData._();
  factory MembershipData() => _instance;

  void setData(String membershipNumber) => _membershipNumber = membershipNumber;

  String get membershipNumber => _membershipNumber ?? "";
}
