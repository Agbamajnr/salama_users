import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:salama_users/app/network/api_client.dart';
import 'package:salama_users/app/network/api_errors.dart';
import 'package:salama_users/app/services/db_service.dart';
import 'package:salama_users/app/utils/app_snack_bar.dart';
import 'package:salama_users/app/utils/logger.dart';
import 'package:salama_users/locator.dart';
import 'package:salama_users/routes/router_names.dart';
import 'package:salama_users/screens/auth/verify_user_screen.dart';
import 'package:salama_users/screens/home/home.dart';

class AuthNotifier extends ChangeNotifier {
  final _api = getIt<DioManager>();
  final _errorHandler = getIt<ErrorHandler>();
  final _db = getIt<DBService>();
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
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen()));
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

  Future<void> register(
    BuildContext context, {
    required String firstName,
    required String lastName,
    required String userType,
    required String phone,
    required String email,
    required String password,
    required String rePassword,
    String? middleName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notify listeners to update UI

    try {
      Response response = await _api.dio.post(
        '/taxi/auth/sign-up',
        data: {
          "firstName": firstName,
          "lastName": lastName,
          "middleName": middleName,
          "email": email,
          "password": password,
          "rePassword": rePassword,
          "phone": phone,
          "userType": "user"
        },
      );

      if (response.statusCode == 201) {
        _db.getToken();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VerifyotpScreen(
                  identiy: email,
                  intent: "sign_otp",
                )));
        _loginData = response.data['data'];
        if (_loginData?['token'] != null) {
          _db.saveToken(_loginData?['token']);
          _db.saveUser(_loginData?['user']);
        }
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

  Future<void> requestOtp(
    BuildContext context, {
    required String identity,
    required String intent,
    required String userType,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    // if (context.mounted) {
    //   notifyListeners();
    // }

    try {
      Response response = await _api.dio.post(
        '/taxi/auth/otp',
        data: {'email': identity, 'intent': intent, 'userType': userType},
      );

      if (response.statusCode == 200) {
        Logger().d(_loginData);
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to request otp';
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

  Future<void> verifyAccount(
    BuildContext context, {
    required String identity,
    required String intent,
    required String userType,
    required String otp,
  }) async {
    _isLoading = true;
    _errorMessage = null;

    try {
      Response response = await _api.dio.post(
        '/taxi/auth/verify-account',
        data: {
          'email': identity,
          'intent': intent,
          'userType': userType,
          'otp': otp
        },
      );

      if (response.statusCode == 200) {
        _loginData = response.data['data']['data'];
        logger.d(_loginData);
        if (_loginData?['token'] != null) {
          _db.saveToken(_loginData?['token']);
          _db.saveUser(_loginData?['user']);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeScreen()));
        }

        Logger().d(_loginData);
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to request otp';
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

  Future<void> logout(BuildContext context) async {
    bool predicate(Route<dynamic> route) {
      return route.settings.name == '/login';
    }

    _db.deleteUser();
    await Navigator.pushNamedAndRemoveUntil(context, Routes.login, predicate);
  }
}
