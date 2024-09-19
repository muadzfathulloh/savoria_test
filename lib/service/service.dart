import 'dart:convert';
import 'dart:io';
import 'package:dio/io.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as dev;


class AppService {
  const AppService(this._baseUrl);

  final String _baseUrl;

  Dio create() {
    final dio = Dio(_createBaseOptions());
    if (kDebugMode) {
      dio.interceptors.add(DioLoggingInterceptor());
    }
    if (!kIsWeb) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        return HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
      };
    }

    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      final cancelToken = CancelToken();
      handler.next(options..cancelToken = cancelToken);
    }));

    return dio;
  }

  BaseOptions _createBaseOptions() {
    return BaseOptions(
      baseUrl: _baseUrl,
    );
  }
}

class DioLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    dev.log("┌----- Request ------------------------------------------------------------------");
    dev.log('| [DIO] ${options.method} ${options.uri}');
    if (options.data != null) {
      dev.log('| ${options.data.toString()}');
    }
    dev.log('| Headers:');
    options.headers.forEach((key, value) {
      dev.log('|\t$key: $value');
    });
    dev.log("└--------------------------------------------------------------------------------");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    dev.log("┌----- Response -----------------------------------------------------------------");
    dev.log("| [DIO] ${response.statusCode} ${response.statusMessage} ${response.requestOptions.uri}");
    final responseData = response.data;
    if (responseData != null) {
      if (responseData is Map) {
        final jsonResponse = jsonEncode(responseData);
        dev.log('| $jsonResponse');
      } else {
        dev.log('| ${response.data.toString()}');
      }
    }
    dev.log("└--------------------------------------------------------------------------------");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    dev.log("[DIO] Error: ${err.error}: ${err.response.toString()}");

    //print status code
    dev.log('statusCode: ${err.response?.statusCode}');

    if (err.response?.statusCode == 401) {
      dev.log('Unauthorized request');
    }

    super.onError(err, handler);
  }
}
