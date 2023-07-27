import 'package:o7therapy/api/errors/network_exceptions.dart';

class UnProcessableEntity extends NetworkExceptions {
  UnProcessableEntity(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String get customErrorMessage => "Unprocessable Entity";
}

class RequestCancelled extends NetworkExceptions {
  RequestCancelled(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String get customErrorMessage => "Request Cancelled";
}

class UnauthorizedRequest implements NetworkExceptions {
  UnauthorizedRequest();

  @override
  String get customErrorMessage => errorMsg;

  @override
  int? errorCode = -1;

  @override
  String errorMsg = "Session expired";

  @override
  String errorDetails = "Session expired";

  @override
  String getErrorMassage() {
    return errorMsg;
  }
}

class ResponseError extends NetworkExceptions {
  ResponseError(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String get customErrorMessage => errorDetails ?? "";
}

class NotFound extends NetworkExceptions {
  NotFound(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String get customErrorMessage => "Not Found";
}

class RequestTimeout extends NetworkExceptions {
  RequestTimeout(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String get customErrorMessage => "Connection request timeout";
}

class SendTimeout extends NetworkExceptions {
  SendTimeout(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String get customErrorMessage => "Send timeout in connection with API server";
}

class Conflict extends NetworkExceptions {
  Conflict(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String get customErrorMessage => "Error due to a conflict";
}

class InternalServerError extends NetworkExceptions {
  InternalServerError(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String get customErrorMessage => "Internal Server Error";
}

class ServiceUnavailable extends NetworkExceptions {
  ServiceUnavailable(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String get customErrorMessage => 'Service unavailable';
}

class UnexpectedError implements NetworkExceptions {
  UnexpectedError();

  @override
  String get customErrorMessage => errorMsg;

  @override
  int? errorCode = -1;

  @override
  String errorMsg = "Unexpected error occurred";

  @override
  String errorDetails = "Unexpected error occurred";

  @override
  String getErrorMassage() {
    return errorMsg;
  }
}

class UnExpectedError implements NetworkExceptions {
  UnExpectedError();

  @override
  String get customErrorMessage => errorMsg;

  @override
  int? errorCode = -1;

  @override
  String errorMsg = "Unexpected error";

  @override
  String errorDetails = "Unexpected error";

  @override
  String getErrorMassage() {
    return errorMsg;
  }
}

class NoInternetConnection implements NetworkExceptions {
  NoInternetConnection();

  @override
  String get customErrorMessage => errorMsg;

  @override
  int? errorCode = -1;

  @override
  String errorMsg = "No internet connection";

  @override
  String errorDetails = "No internet connection";

  @override
  String getErrorMassage() {
    return errorMsg;
  }
}
