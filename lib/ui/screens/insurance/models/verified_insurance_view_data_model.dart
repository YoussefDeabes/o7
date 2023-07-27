import 'package:o7therapy/api/models/insurance/remaining_cap_no/remaining_cap_no_model.dart';

class VerifiedInsuranceViewDataModel {
  final DateTime expirationTime;
  final String? providerName;
  final int? cardId;
  final bool isTerminated;
  final int remainingCap;
  final int originalCap;
  const VerifiedInsuranceViewDataModel._({
    required this.expirationTime,
    this.providerName,
    this.cardId,
    required this.remainingCap,
    required this.isTerminated,
    required this.originalCap,
  });

  factory VerifiedInsuranceViewDataModel.fromRemainingCapNoModel(
    RemainingCapNoModel model,
  ) {
    return VerifiedInsuranceViewDataModel._(
      isTerminated: model.data.isTerminated,
      expirationTime: model.data.validTill,
      originalCap: model.data.orginalCap,
      providerName: null,
      cardId: null,
      remainingCap: model.data.remainingCap,
    );
  }

  VerifiedInsuranceViewDataModel copyWith({
    bool? isTerminated,
    DateTime? expirationTime,
    String? providerName,
    int? remainingCap,
    int? cardId,
    int? originalCap,
  }) {
    return VerifiedInsuranceViewDataModel._(
      isTerminated: isTerminated ?? this.isTerminated,
      expirationTime: expirationTime ?? this.expirationTime,
      providerName: providerName ?? this.providerName,
      remainingCap: remainingCap ?? this.remainingCap,
      originalCap: originalCap ?? this.originalCap,
      cardId: cardId ?? this.cardId,
    );
  }
}
