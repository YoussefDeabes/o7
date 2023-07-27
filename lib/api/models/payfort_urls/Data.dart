class Data {
  Data({
      this.messagingEnableWhiteList, 
      this.messagingWhiteList, 
      this.messagingMessageDelayValue, 
      this.identityWordPressUrl, 
      this.identityChattingAdminId, 
      this.identityChattingAdminName, 
      this.identityMinSessionAdvanceNoticePeriodInHours, 
      this.identityMaxSessionAdvanceNoticePeriodInHours, 
      this.accountingServiceO7MerchantCode, 
      this.accountingServiceCancelationEligibleFullRefundMinHours, 
      this.accountingServiceCancelationEligiblePartialRefundMinHours, 
      this.accountingServiceSessionRefundInvoiceTypeCode, 
      this.accountingServiceEGPPatientPayableInvoiceTrxSubTypeCode, 
      this.accountingServiceUSDPatientPayableInvoiceTrxSubTypeCode, 
      this.accountingServiceRescheduleSessionNoPenaltyMinHours, 
      this.accountingServiceRescheduleSessionPartialPenaltyMinHours, 
      this.paymentServicePayFortPaymentUrl, 
      this.paymentServicePayFortPaymentReturnUrl, 
      this.paymentServicePayFortPurchaseFailureUrl, 
      this.paymentServicePayFortCancelSessionPaymentReturnUrl, 
      this.paymentServicePayFortCancelSessionPurchase, 
      this.sessionsSessionDuration, 
      this.sessionsSlotAdvanceNoticePeriod, 
      this.sessionsSessionsGapsDuration, 
      this.sessionsPostSessionAllowedEditDurationInHours, 
      this.sessionsRescheduleSessionNoPenaltyMinHours, 
      this.sessionsRescheduleSessionPartialPenaltyMinHours, 
      this.sessionsMaxReferredToCount, 
      this.sessionsSessionMaxDuration, 
      this.sessionsMinRepeatedSlots, 
      this.sessionsMaxRepeatedSlots, 
      this.sessionsSessionVideoCallResolution, 
      this.sessionsExcludedEmailsFromReport, 
      this.chattingSendbirdAppId, 
      this.chattingChattingAdminId, 
      this.chattingChattingAdminName, 
      this.creditcardPayfortCreateTokenReturnUrl,});

  Data.fromJson(dynamic json) {
    messagingEnableWhiteList = json['messaging_EnableWhiteList'];
    messagingWhiteList = json['messaging_WhiteList'];
    messagingMessageDelayValue = json['messaging_MessageDelayValue'];
    identityWordPressUrl = json['identity_WordPressUrl'];
    identityChattingAdminId = json['identity_ChattingAdminId'];
    identityChattingAdminName = json['identity_ChattingAdminName'];
    identityMinSessionAdvanceNoticePeriodInHours = json['identity_MinSessionAdvanceNoticePeriodInHours'];
    identityMaxSessionAdvanceNoticePeriodInHours = json['identity_MaxSessionAdvanceNoticePeriodInHours'];
    accountingServiceO7MerchantCode = json['AccountingService_O7MerchantCode'];
    accountingServiceCancelationEligibleFullRefundMinHours = json['AccountingService_CancelationEligibleFullRefundMinHours'];
    accountingServiceCancelationEligiblePartialRefundMinHours = json['AccountingService_CancelationEligiblePartialRefundMinHours'];
    accountingServiceSessionRefundInvoiceTypeCode = json['AccountingService_SessionRefundInvoiceTypeCode'];
    accountingServiceEGPPatientPayableInvoiceTrxSubTypeCode = json['AccountingService_EGPPatientPayableInvoiceTrxSubTypeCode'];
    accountingServiceUSDPatientPayableInvoiceTrxSubTypeCode = json['AccountingService_USDPatientPayableInvoiceTrxSubTypeCode'];
    accountingServiceRescheduleSessionNoPenaltyMinHours = json['AccountingService_RescheduleSessionNoPenaltyMinHours'];
    accountingServiceRescheduleSessionPartialPenaltyMinHours = json['AccountingService_RescheduleSessionPartialPenaltyMinHours'];
    paymentServicePayFortPaymentUrl = json['PaymentService_PayFortPaymentUrl'];
    paymentServicePayFortPaymentReturnUrl = json['PaymentService_PayFortPaymentReturnUrl'];
    paymentServicePayFortPurchaseFailureUrl = json['PaymentService_PayFortPurchaseFailureUrl'];
    paymentServicePayFortCancelSessionPaymentReturnUrl = json['PaymentService_PayFortCancelSessionPaymentReturnUrl'];
    paymentServicePayFortCancelSessionPurchase = json['PaymentService_PayFortCancelSessionPurchase'];
    sessionsSessionDuration = json['sessions_SessionDuration'];
    sessionsSlotAdvanceNoticePeriod = json['sessions_SlotAdvanceNoticePeriod'];
    sessionsSessionsGapsDuration = json['sessions_SessionsGapsDuration'];
    sessionsPostSessionAllowedEditDurationInHours = json['sessions_PostSessionAllowedEditDurationInHours'];
    sessionsRescheduleSessionNoPenaltyMinHours = json['sessions_RescheduleSessionNoPenaltyMinHours'];
    sessionsRescheduleSessionPartialPenaltyMinHours = json['sessions_RescheduleSessionPartialPenaltyMinHours'];
    sessionsMaxReferredToCount = json['sessions_MaxReferredToCount'];
    sessionsSessionMaxDuration = json['sessions_SessionMaxDuration'];
    sessionsMinRepeatedSlots = json['sessions_MinRepeatedSlots'];
    sessionsMaxRepeatedSlots = json['sessions_MaxRepeatedSlots'];
    sessionsSessionVideoCallResolution = json['sessions_SessionVideoCallResolution'];
    sessionsExcludedEmailsFromReport = json['sessions_ExcludedEmailsFromReport'];
    chattingSendbirdAppId = json['chatting_SendbirdAppId'];
    chattingChattingAdminId = json['chatting_ChattingAdminId'];
    chattingChattingAdminName = json['chatting_ChattingAdminName'];
    creditcardPayfortCreateTokenReturnUrl = json['creditcard_PayfortCreateTokenReturnUrl'];
  }
  String? messagingEnableWhiteList;
  String? messagingWhiteList;
  String? messagingMessageDelayValue;
  String? identityWordPressUrl;
  String? identityChattingAdminId;
  String? identityChattingAdminName;
  String? identityMinSessionAdvanceNoticePeriodInHours;
  String? identityMaxSessionAdvanceNoticePeriodInHours;
  String? accountingServiceO7MerchantCode;
  String? accountingServiceCancelationEligibleFullRefundMinHours;
  String? accountingServiceCancelationEligiblePartialRefundMinHours;
  String? accountingServiceSessionRefundInvoiceTypeCode;
  String? accountingServiceEGPPatientPayableInvoiceTrxSubTypeCode;
  String? accountingServiceUSDPatientPayableInvoiceTrxSubTypeCode;
  String? accountingServiceRescheduleSessionNoPenaltyMinHours;
  String? accountingServiceRescheduleSessionPartialPenaltyMinHours;
  String? paymentServicePayFortPaymentUrl;
  String? paymentServicePayFortPaymentReturnUrl;
  String? paymentServicePayFortPurchaseFailureUrl;
  String? paymentServicePayFortCancelSessionPaymentReturnUrl;
  String? paymentServicePayFortCancelSessionPurchase;
  String? sessionsSessionDuration;
  String? sessionsSlotAdvanceNoticePeriod;
  String? sessionsSessionsGapsDuration;
  String? sessionsPostSessionAllowedEditDurationInHours;
  String? sessionsRescheduleSessionNoPenaltyMinHours;
  String? sessionsRescheduleSessionPartialPenaltyMinHours;
  String? sessionsMaxReferredToCount;
  String? sessionsSessionMaxDuration;
  String? sessionsMinRepeatedSlots;
  String? sessionsMaxRepeatedSlots;
  String? sessionsSessionVideoCallResolution;
  String? sessionsExcludedEmailsFromReport;
  String? chattingSendbirdAppId;
  String? chattingChattingAdminId;
  String? chattingChattingAdminName;
  String? creditcardPayfortCreateTokenReturnUrl;
Data copyWith({  String? messagingEnableWhiteList,
  String? messagingWhiteList,
  String? messagingMessageDelayValue,
  String? identityWordPressUrl,
  String? identityChattingAdminId,
  String? identityChattingAdminName,
  String? identityMinSessionAdvanceNoticePeriodInHours,
  String? identityMaxSessionAdvanceNoticePeriodInHours,
  String? accountingServiceO7MerchantCode,
  String? accountingServiceCancelationEligibleFullRefundMinHours,
  String? accountingServiceCancelationEligiblePartialRefundMinHours,
  String? accountingServiceSessionRefundInvoiceTypeCode,
  String? accountingServiceEGPPatientPayableInvoiceTrxSubTypeCode,
  String? accountingServiceUSDPatientPayableInvoiceTrxSubTypeCode,
  String? accountingServiceRescheduleSessionNoPenaltyMinHours,
  String? accountingServiceRescheduleSessionPartialPenaltyMinHours,
  String? paymentServicePayFortPaymentUrl,
  String? paymentServicePayFortPaymentReturnUrl,
  String? paymentServicePayFortPurchaseFailureUrl,
  String? paymentServicePayFortCancelSessionPaymentReturnUrl,
  String? paymentServicePayFortCancelSessionPurchase,
  String? sessionsSessionDuration,
  String? sessionsSlotAdvanceNoticePeriod,
  String? sessionsSessionsGapsDuration,
  String? sessionsPostSessionAllowedEditDurationInHours,
  String? sessionsRescheduleSessionNoPenaltyMinHours,
  String? sessionsRescheduleSessionPartialPenaltyMinHours,
  String? sessionsMaxReferredToCount,
  String? sessionsSessionMaxDuration,
  String? sessionsMinRepeatedSlots,
  String? sessionsMaxRepeatedSlots,
  String? sessionsSessionVideoCallResolution,
  String? sessionsExcludedEmailsFromReport,
  String? chattingSendbirdAppId,
  String? chattingChattingAdminId,
  String? chattingChattingAdminName,
  String? creditcardPayfortCreateTokenReturnUrl,
}) => Data(  messagingEnableWhiteList: messagingEnableWhiteList ?? this.messagingEnableWhiteList,
  messagingWhiteList: messagingWhiteList ?? this.messagingWhiteList,
  messagingMessageDelayValue: messagingMessageDelayValue ?? this.messagingMessageDelayValue,
  identityWordPressUrl: identityWordPressUrl ?? this.identityWordPressUrl,
  identityChattingAdminId: identityChattingAdminId ?? this.identityChattingAdminId,
  identityChattingAdminName: identityChattingAdminName ?? this.identityChattingAdminName,
  identityMinSessionAdvanceNoticePeriodInHours: identityMinSessionAdvanceNoticePeriodInHours ?? this.identityMinSessionAdvanceNoticePeriodInHours,
  identityMaxSessionAdvanceNoticePeriodInHours: identityMaxSessionAdvanceNoticePeriodInHours ?? this.identityMaxSessionAdvanceNoticePeriodInHours,
  accountingServiceO7MerchantCode: accountingServiceO7MerchantCode ?? this.accountingServiceO7MerchantCode,
  accountingServiceCancelationEligibleFullRefundMinHours: accountingServiceCancelationEligibleFullRefundMinHours ?? this.accountingServiceCancelationEligibleFullRefundMinHours,
  accountingServiceCancelationEligiblePartialRefundMinHours: accountingServiceCancelationEligiblePartialRefundMinHours ?? this.accountingServiceCancelationEligiblePartialRefundMinHours,
  accountingServiceSessionRefundInvoiceTypeCode: accountingServiceSessionRefundInvoiceTypeCode ?? this.accountingServiceSessionRefundInvoiceTypeCode,
  accountingServiceEGPPatientPayableInvoiceTrxSubTypeCode: accountingServiceEGPPatientPayableInvoiceTrxSubTypeCode ?? this.accountingServiceEGPPatientPayableInvoiceTrxSubTypeCode,
  accountingServiceUSDPatientPayableInvoiceTrxSubTypeCode: accountingServiceUSDPatientPayableInvoiceTrxSubTypeCode ?? this.accountingServiceUSDPatientPayableInvoiceTrxSubTypeCode,
  accountingServiceRescheduleSessionNoPenaltyMinHours: accountingServiceRescheduleSessionNoPenaltyMinHours ?? this.accountingServiceRescheduleSessionNoPenaltyMinHours,
  accountingServiceRescheduleSessionPartialPenaltyMinHours: accountingServiceRescheduleSessionPartialPenaltyMinHours ?? this.accountingServiceRescheduleSessionPartialPenaltyMinHours,
  paymentServicePayFortPaymentUrl: paymentServicePayFortPaymentUrl ?? this.paymentServicePayFortPaymentUrl,
  paymentServicePayFortPaymentReturnUrl: paymentServicePayFortPaymentReturnUrl ?? this.paymentServicePayFortPaymentReturnUrl,
  paymentServicePayFortPurchaseFailureUrl: paymentServicePayFortPurchaseFailureUrl ?? this.paymentServicePayFortPurchaseFailureUrl,
  paymentServicePayFortCancelSessionPaymentReturnUrl: paymentServicePayFortCancelSessionPaymentReturnUrl ?? this.paymentServicePayFortCancelSessionPaymentReturnUrl,
  paymentServicePayFortCancelSessionPurchase: paymentServicePayFortCancelSessionPurchase ?? this.paymentServicePayFortCancelSessionPurchase,
  sessionsSessionDuration: sessionsSessionDuration ?? this.sessionsSessionDuration,
  sessionsSlotAdvanceNoticePeriod: sessionsSlotAdvanceNoticePeriod ?? this.sessionsSlotAdvanceNoticePeriod,
  sessionsSessionsGapsDuration: sessionsSessionsGapsDuration ?? this.sessionsSessionsGapsDuration,
  sessionsPostSessionAllowedEditDurationInHours: sessionsPostSessionAllowedEditDurationInHours ?? this.sessionsPostSessionAllowedEditDurationInHours,
  sessionsRescheduleSessionNoPenaltyMinHours: sessionsRescheduleSessionNoPenaltyMinHours ?? this.sessionsRescheduleSessionNoPenaltyMinHours,
  sessionsRescheduleSessionPartialPenaltyMinHours: sessionsRescheduleSessionPartialPenaltyMinHours ?? this.sessionsRescheduleSessionPartialPenaltyMinHours,
  sessionsMaxReferredToCount: sessionsMaxReferredToCount ?? this.sessionsMaxReferredToCount,
  sessionsSessionMaxDuration: sessionsSessionMaxDuration ?? this.sessionsSessionMaxDuration,
  sessionsMinRepeatedSlots: sessionsMinRepeatedSlots ?? this.sessionsMinRepeatedSlots,
  sessionsMaxRepeatedSlots: sessionsMaxRepeatedSlots ?? this.sessionsMaxRepeatedSlots,
  sessionsSessionVideoCallResolution: sessionsSessionVideoCallResolution ?? this.sessionsSessionVideoCallResolution,
  sessionsExcludedEmailsFromReport: sessionsExcludedEmailsFromReport ?? this.sessionsExcludedEmailsFromReport,
  chattingSendbirdAppId: chattingSendbirdAppId ?? this.chattingSendbirdAppId,
  chattingChattingAdminId: chattingChattingAdminId ?? this.chattingChattingAdminId,
  chattingChattingAdminName: chattingChattingAdminName ?? this.chattingChattingAdminName,
  creditcardPayfortCreateTokenReturnUrl: creditcardPayfortCreateTokenReturnUrl ?? this.creditcardPayfortCreateTokenReturnUrl,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['messaging_EnableWhiteList'] = messagingEnableWhiteList;
    map['messaging_WhiteList'] = messagingWhiteList;
    map['messaging_MessageDelayValue'] = messagingMessageDelayValue;
    map['identity_WordPressUrl'] = identityWordPressUrl;
    map['identity_ChattingAdminId'] = identityChattingAdminId;
    map['identity_ChattingAdminName'] = identityChattingAdminName;
    map['identity_MinSessionAdvanceNoticePeriodInHours'] = identityMinSessionAdvanceNoticePeriodInHours;
    map['identity_MaxSessionAdvanceNoticePeriodInHours'] = identityMaxSessionAdvanceNoticePeriodInHours;
    map['AccountingService_O7MerchantCode'] = accountingServiceO7MerchantCode;
    map['AccountingService_CancelationEligibleFullRefundMinHours'] = accountingServiceCancelationEligibleFullRefundMinHours;
    map['AccountingService_CancelationEligiblePartialRefundMinHours'] = accountingServiceCancelationEligiblePartialRefundMinHours;
    map['AccountingService_SessionRefundInvoiceTypeCode'] = accountingServiceSessionRefundInvoiceTypeCode;
    map['AccountingService_EGPPatientPayableInvoiceTrxSubTypeCode'] = accountingServiceEGPPatientPayableInvoiceTrxSubTypeCode;
    map['AccountingService_USDPatientPayableInvoiceTrxSubTypeCode'] = accountingServiceUSDPatientPayableInvoiceTrxSubTypeCode;
    map['AccountingService_RescheduleSessionNoPenaltyMinHours'] = accountingServiceRescheduleSessionNoPenaltyMinHours;
    map['AccountingService_RescheduleSessionPartialPenaltyMinHours'] = accountingServiceRescheduleSessionPartialPenaltyMinHours;
    map['PaymentService_PayFortPaymentUrl'] = paymentServicePayFortPaymentUrl;
    map['PaymentService_PayFortPaymentReturnUrl'] = paymentServicePayFortPaymentReturnUrl;
    map['PaymentService_PayFortPurchaseFailureUrl'] = paymentServicePayFortPurchaseFailureUrl;
    map['PaymentService_PayFortCancelSessionPaymentReturnUrl'] = paymentServicePayFortCancelSessionPaymentReturnUrl;
    map['PaymentService_PayFortCancelSessionPurchase'] = paymentServicePayFortCancelSessionPurchase;
    map['sessions_SessionDuration'] = sessionsSessionDuration;
    map['sessions_SlotAdvanceNoticePeriod'] = sessionsSlotAdvanceNoticePeriod;
    map['sessions_SessionsGapsDuration'] = sessionsSessionsGapsDuration;
    map['sessions_PostSessionAllowedEditDurationInHours'] = sessionsPostSessionAllowedEditDurationInHours;
    map['sessions_RescheduleSessionNoPenaltyMinHours'] = sessionsRescheduleSessionNoPenaltyMinHours;
    map['sessions_RescheduleSessionPartialPenaltyMinHours'] = sessionsRescheduleSessionPartialPenaltyMinHours;
    map['sessions_MaxReferredToCount'] = sessionsMaxReferredToCount;
    map['sessions_SessionMaxDuration'] = sessionsSessionMaxDuration;
    map['sessions_MinRepeatedSlots'] = sessionsMinRepeatedSlots;
    map['sessions_MaxRepeatedSlots'] = sessionsMaxRepeatedSlots;
    map['sessions_SessionVideoCallResolution'] = sessionsSessionVideoCallResolution;
    map['sessions_ExcludedEmailsFromReport'] = sessionsExcludedEmailsFromReport;
    map['chatting_SendbirdAppId'] = chattingSendbirdAppId;
    map['chatting_ChattingAdminId'] = chattingChattingAdminId;
    map['chatting_ChattingAdminName'] = chattingChattingAdminName;
    map['creditcard_PayfortCreateTokenReturnUrl'] = creditcardPayfortCreateTokenReturnUrl;
    return map;
  }

}