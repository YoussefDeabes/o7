import 'package:dio/dio.dart';

final LogInterceptor customLoginInterceptor =
    LogInterceptor(responseBody: true, requestBody: true, error: true);
