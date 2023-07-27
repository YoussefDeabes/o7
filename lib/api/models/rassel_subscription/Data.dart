/// id : 2
/// amount : 175.0
/// name : "Rasel Subscription"
/// currency : 1

class Data {
  Data({
    required this.originalAmount,
    required this.isSupscripedBefore,
    this.id,
    this.amount,
    this.name,
    this.currency,
    this.hasActiveSubscription,
    this.expirationDate,
    this.subscriptionStatus,
  });

  factory Data.fromJson(dynamic json) {
    return Data(
      id: json['id'],
      amount: json['amount'],
      name: json['name'],
      currency: json['currency'],
      originalAmount: json["original_amount"],
      isSupscripedBefore: json["is_supscriped_before"],
      hasActiveSubscription: json["has_active_subscription"],
      expirationDate: json["expiration_date"],
      subscriptionStatus: json["subscription_status"],
    );
  }
  num? id;
  num? amount;
  String? name;
  num? currency;
  final double? originalAmount;
  final bool? isSupscripedBefore;
  final bool? hasActiveSubscription;
  final String? expirationDate;
  final int? subscriptionStatus;
  Data copyWith({
    num? id,
    num? amount,
    String? name,
    num? currency,
    bool? isSupscripedBefore,
    bool? hasActiveSubscription,
    double? originalAmount,
    int? subscriptionStatus,
    String? expirationDate,
  }) =>
      Data(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        name: name ?? this.name,
        currency: currency ?? this.currency,
        isSupscripedBefore: isSupscripedBefore ?? this.isSupscripedBefore,
        originalAmount: originalAmount ?? this.originalAmount,
        hasActiveSubscription: hasActiveSubscription ?? this.hasActiveSubscription,
        subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
        expirationDate: expirationDate ?? this.expirationDate,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['amount'] = amount;
    map['name'] = name;
    map['currency'] = currency;
    map["original_amount"] = "original_amount";
    map["is_supscriped_before"] = "is_supscriped_before";
    map["has_active_subscription"] =hasActiveSubscription;
    map["subscription_status"] = subscriptionStatus;
    map["expiration_date"] = expirationDate;
    return map;
  }
}
