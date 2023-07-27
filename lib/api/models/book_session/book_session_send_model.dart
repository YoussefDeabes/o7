class BookSessionSendModel {
  String? slotId;
  String? promoCode;
  bool? isWallet = false;

  BookSessionSendModel({this.slotId, this.promoCode, this.isWallet});

  Map toMap() {
    return {"slot_id": slotId, "promo_code": promoCode, "is_wallet": isWallet};
  }
}
