import 'dart:io';
import 'package:dio/dio.dart';
import 'package:package_info/package_info.dart';
import 'package:savoria_test/service/service.dart';

class DioClient {
  const DioClient(this._baseUrl);

  final String _baseUrl;

  Dio create() {
    return AppService(_baseUrl).create()..interceptors.add(ApiInterceptor());
  }
}

class ApiInterceptor extends Interceptor {
  final int retries = 1;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final packageInfo = await PackageInfo.fromPlatform();

    String? platform;
    if (Platform.isAndroid) {
      platform = 'android';
    } else if (Platform.isIOS) {
      platform = 'ios';
    }

    options.headers.addAll({
      HttpHeaders.contentTypeHeader: 'application/json',
      'x-client-id': packageInfo.packageName,
      'x-client-version': packageInfo.version,
    });

    if (platform != null) {
      options.headers.putIfAbsent('x-client-platform', () => platform);
    }

    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    super.onError(err, handler);
  }
}

extension AuthRequestOptionsX on RequestOptions {
  int get _retryAttempt => (extra['auth_retry_attempt'] as int?) ?? 0;
  set _retryAttempt(final int attempt) => extra['auth_retry_attempt'] = attempt;
}
