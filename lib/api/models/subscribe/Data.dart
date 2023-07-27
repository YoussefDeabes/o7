/// user_subscription_id : 4

class Data {
  Data({
      this.userSubscriptionId,this.subscriptionFees});

  Data.fromJson(dynamic json) {
    userSubscriptionId = json['user_subscription_id'];
    subscriptionFees = json['subscription_fees'];
  }
  num? userSubscriptionId;
  num? subscriptionFees;
Data copyWith({  num? userSubscriptionId,num? subscriptionFees
}) => Data(  userSubscriptionId: userSubscriptionId ?? this.userSubscriptionId,
  subscriptionFees: subscriptionFees ?? this.subscriptionFees
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_subscription_id'] = userSubscriptionId;
    map['subscription_fees'] = subscriptionFees;
    return map;
  }

}