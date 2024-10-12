import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:salama_users/app/network/api_client.dart';
import 'package:salama_users/app/network/api_errors.dart';
import 'package:salama_users/app/utils/app_snack_bar.dart';
import 'package:salama_users/app/utils/logger.dart';
import 'package:salama_users/locator.dart';

class AuthNotifier extends ChangeNotifier {
  final _api = getIt<DioManager>();
  final _errorHandler = getIt<ErrorHandler>();
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _loginData;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get loginData => _loginData;

  Future<void> login(
    BuildContext context, {
    required String identity,
    required String password,
    required String userType,
    required String device,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notify listeners to update UI

    try {
      Response response = await _api.dio.post(
        '/taxi/auth/login',
        data: {
          'identity': identity,
          'password': password,
          'userType': userType,
          'device': device,
        },
      );

      if (response.statusCode == 200) {
        _loginData = response.data['data'];
        Logger().d(_loginData);
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to login';
      }
    } on DioException catch (e) {
      var error = _errorHandler.handleError(e);
      if (context.mounted) {
        AppSnackbar.error(context, message: error);
      }
    } catch (e) {
      var error = _errorHandler.handleError(e);
      if (context.mounted) {
        AppSnackbar.error(context, message: error);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
