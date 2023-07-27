import 'package:o7therapy/api/models/user_discounts/Data.dart' as user_data;
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';

class UserDiscountData {
  final bool? isCorporate;
  final bool? isInsurance;
  final bool? isFlatRate;
  final bool? hasSessionsOnWallet;
  final bool? inDebt;
  final bool? isOldClient;
  final double? discount;
  final String? companyCode;
  final ClientStatus? clientStatus;
  final String? userReferenceNumber;
  final String? corporateName;

  const UserDiscountData({
    this.isCorporate,
    this.isInsurance,
    this.isFlatRate,
    this.hasSessionsOnWallet,
    this.inDebt,
    this.isOldClient,
    this.discount,
    this.clientStatus,
    this.companyCode,
    this.userReferenceNumber,
    this.corporateName,
  });

  factory UserDiscountData.fromBackEndDataModel(user_data.Data data) {
    return UserDiscountData(
        isCorporate: data.isCorporate,
        isInsurance: data.isInsurance,
        isFlatRate: data.isFlatRate,
        hasSessionsOnWallet: data.hasSessionsOnWallet,
        inDebt: data.inDebt,
        companyCode: data.companyCode,
        clientStatus: _getClientStatus(
          isCorporate: data.isCorporate,
          isInsurance: data.isInsurance,
        ),
      discount:data.discount ,
      userReferenceNumber: data.userReferenceNumber,
      corporateName: data.corporateName,

    );
  }

  @override
  String toString() {
    return 'UserDiscountData(isCorporate: $isCorporate, isInsurance: $isInsurance, isFlatRate: $isFlatRate, hasSessionsOnWallet: $hasSessionsOnWallet, inDebt: $inDebt, isOldClient: $isOldClient, discount: $discount)';
  }

  static ClientStatus? _getClientStatus({
    bool? isCorporate,
    bool? isInsurance,
  }) {
    ClientStatus? clientStatus;
    if (isCorporate == null && isInsurance == null) {
      clientStatus = null;
    } else if (isCorporate != null && isCorporate == true) {
      clientStatus = ClientStatus.ewpClient;
    } else if (isInsurance != null && isInsurance == true) {
      clientStatus = ClientStatus.insuranceClient;
    } else {
      clientStatus = null;
    }
    return clientStatus;
  }
}
