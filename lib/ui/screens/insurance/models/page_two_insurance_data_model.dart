import 'package:equatable/equatable.dart';
import 'package:o7therapy/api/models/insurance/insurance_providers_list/insurance_providers_list.dart';

class PageTwoInsuranceDataModel extends Equatable {
  final ProviderData? providerData;
  final int? membershipNo;
  final DateTime? expirationDate;
  const PageTwoInsuranceDataModel({
    this.providerData,
    this.membershipNo,
    this.expirationDate,
  });

  static const PageTwoInsuranceDataModel init = PageTwoInsuranceDataModel();

  PageTwoInsuranceDataModel copyWith({
    ProviderData? providerData,
    int? membershipNo,
    DateTime? expirationDate,
  }) {
    return PageTwoInsuranceDataModel(
      providerData: providerData ??
          (this.providerData != null ? this.providerData!.copyWith() : null),
      membershipNo: membershipNo ?? this.membershipNo,
      expirationDate: expirationDate ?? this.expirationDate,
    );
  }

  @override
  String toString() =>
      'AddNewInsuranceDataModel(providerData: $providerData, membershipNo: $membershipNo, expirationDate: $expirationDate)';

  @override
  List<Object?> get props => [providerData, membershipNo, expirationDate];
}
