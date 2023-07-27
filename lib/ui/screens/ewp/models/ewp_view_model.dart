import 'package:o7therapy/api/models/ewp/ewp_remaining_cap_no_wrapper.dart';

class EwpViewModel {
  EwpViewModel({
    required this.remainingCap,
    required this.validTill,
    required this.orginalCap,
    required this.discountAmount,
    required this.corporateName,
  });

  final int? remainingCap;
  final DateTime? validTill;
  final int? orginalCap;
  final double? discountAmount;
  final String? corporateName;

  factory EwpViewModel.fromEwpRemainingCapNoWrapper(
    EwpRemainingCapNoWrapper wrapper,
  ) {
    Data? data = wrapper.data;
    return EwpViewModel(
      remainingCap: data?.remainingCap,
      validTill: data?.validTill,
      orginalCap: data?.orginalCap,
      discountAmount: data?.discountAmount,
      corporateName: data?.corporateName,
    );
  }
}
