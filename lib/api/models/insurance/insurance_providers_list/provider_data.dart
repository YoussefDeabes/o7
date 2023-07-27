class ProviderData {
  ProviderData({
    required this.providerId,
    required this.providerName,
  });

  final int providerId;
  final String providerName;

  ProviderData copyWith({
    int? providerId,
    String? providerName,
  }) =>
      ProviderData(
        providerId: providerId ?? this.providerId,
        providerName: providerName ?? this.providerName,
      );

  factory ProviderData.fromJson(json) => ProviderData(
        providerId: json["provider_id"],
        providerName: json["provider_name"],
      );

  Map<String, dynamic> toJson() => {
        "provider_id": providerId,
        "provider_name": providerName,
      };

  @override
  String toString() =>
      'ProviderData(providerId: $providerId, providerName: $providerName)';
}
