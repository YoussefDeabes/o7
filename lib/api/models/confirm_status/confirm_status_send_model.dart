class ConfirmStatusSendModel {
  int? sessionId;
  int? sessionStatus;
  String? clientComment;
  String? reason;

  ConfirmStatusSendModel(
      {this.sessionId, this.sessionStatus, this.clientComment, this.reason});

  Map toMap() {
    return {
      "session_id": sessionId,
      "session_status": sessionStatus,
      "client_comment": clientComment,
      "reason": reason,
    };
  }
}
