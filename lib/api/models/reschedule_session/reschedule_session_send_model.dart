class RescheduleSessionSendModel {
  String? slotId;

  RescheduleSessionSendModel({this.slotId});

  Map toMap() {
    return {
      "new_slot_id": slotId,
    };
  }
}
