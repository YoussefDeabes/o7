import 'package:dio/dio.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';

const String errorCodeKeyName = "errorCode";

class DioFirebasePerformanceInterceptor extends Interceptor {
  DioFirebasePerformanceInterceptor();

  /// key: requestKey hash code,
  /// value: metric
  final _map = <int, HttpMetric>{};

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final metric = FirebasePerformance.instance.newHttpMetric(
        options.path,
        options.method.asHttpMethod(),
      );
      final requestKey = options.extra.hashCode;
      _map[requestKey] = metric;
      await metric.start();

      final requestContentLength = _getRequestContentLength(options);
      if (requestContentLength != null) {
        metric.requestPayloadSize = requestContentLength;
      }
    } catch (_) {}

    return super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    await stopMetric(response.requestOptions, response);
    return super.onResponse(response, handler);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    await stopMetric(err.requestOptions, err.response);
    return super.onError(err, handler);
  }

  Future<void> stopMetric(
    RequestOptions requestOptions,
    Response<dynamic>? response,
  ) async {
    try {
      final requestKey = requestOptions.extra.hashCode;
      final metric = _map[requestKey];
      metric?.setResponse(response);

      metric?.putAttribute(
        errorCodeKeyName,
        (response?.data['error_code']).toString(),
      );

      await metric?.stop();
      _map.remove(requestKey);
      metric?.logHttpMetricString();
    } catch (_) {}
  }
}

int? _getRequestContentLength(RequestOptions options) {
  try {
    return options.headers.toString().length + options.data.toString().length;
  } catch (_) {
    return null;
  }
}

int? _getResponseContentLength(Response<dynamic> response) {
  try {
    /// get the content-length form the response header
    final String? lengthHeader =
        response.headers[Headers.contentLengthHeader]?.first;
    int length = int.parse(lengthHeader ?? '-1');

    /// if the length == 0 or -1 then
    /// calculate the content length = header length +  response.data length
    if (length <= 0) {
      final int headers = response.headers.toString().length;
      length = headers + response.data.toString().length;
    }
    return length;
  } catch (_) {
    return null;
  }
}

extension _ResponseHttpMetric on HttpMetric {
  void setResponse(Response<dynamic>? response) {
    if (response == null) {
      return;
    }

    final responseContentLength = _getResponseContentLength(response);
    if (responseContentLength != null) {
      responsePayloadSize = responseContentLength;
    }
    final contentType = response.headers.value.call(Headers.contentTypeHeader);
    if (contentType != null) {
      responseContentType = contentType;
    }
    if (response.statusCode != null) {
      httpResponseCode = response.statusCode;
    }
  }

  void logHttpMetricString() {
    debugPrint(
      "HttpMetric("
      "httpResponseCode: $httpResponseCode,"
      "requestPayloadSize: $requestPayloadSize,"
      "responseContentType: $responseContentType,"
      "responsePayloadSize: $responsePayloadSize,"
      "getAttributes: ${getAttributes()})",
    );
  }
}

extension _StringHttpMethod on String {
  HttpMethod asHttpMethod() {
    switch (toUpperCase()) {
      case "POST":
        return HttpMethod.Post;
      case "GET":
        return HttpMethod.Get;
      case "DELETE":
        return HttpMethod.Delete;
      case "PUT":
        return HttpMethod.Put;
      case "PATCH":
        return HttpMethod.Patch;
      case "OPTIONS":
        return HttpMethod.Options;
      default:
        return HttpMethod.Trace;
    }
  }
}
