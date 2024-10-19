import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:salama_users/app/services/db_service.dart';
import 'package:salama_users/app/utils/logger.dart';
import 'package:salama_users/locator.dart';

final _db = getIt<DBService>();

class DioManager {
  late Dio _dio;
  late String? tokenProvider;
  BuildContext? context;

  DioManager(this.tokenProvider) {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://100.25.177.226',
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $tokenProvider',
        'Content-Type': 'application/json',
        //   'public_key': 'AS_PUBLIC_HtqFHcL1LLmqt',
        //   'secret_key': 'AS_SECRET_29MOHf8Ff2ImH',
        //   'slug': 'user_version_1.0_android',
        //   'user_type': 'user',
        //   'version': '1.0'
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async{
        // Attach access token to headers
        final token = await _db.getToken();
        logger.d(token);
        final accessToken = token ?? tokenProvider;

        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }

        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Handle token refresh if needed
        if (response.statusCode == 401) {
          if (context != null) {
            if (context!.mounted) {
              // _db.clear();
            }
          }
        }

        return handler.next(response);
      },
    ));
  }

  Dio get dio => _dio;
}
