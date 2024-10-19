import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:salama_users/app/network/api_client.dart';
import 'package:salama_users/app/network/api_errors.dart';
import 'package:salama_users/app/services/db_service.dart';
import 'package:salama_users/app/utils/app_snack_bar.dart';
import 'package:salama_users/app/utils/logger.dart';
import 'package:salama_users/data/models/available_driver.model.dart';
import 'package:salama_users/data/models/book_ride_dto.dart';
import 'package:salama_users/data/models/booking_response.dart';
import 'package:salama_users/data/models/login_data.model.dart';
import 'package:salama_users/data/models/register_dto.dart';
import 'package:salama_users/data/models/trips_model.dart' as tripsModel;
import 'package:salama_users/data/models/update_user_dto.dart';
import 'package:salama_users/locator.dart';
import 'package:salama_users/routes/router_names.dart';
import 'package:salama_users/screens/auth/verify_user_screen.dart';
import 'package:salama_users/screens/home/home.dart';
import 'package:geolocator/geolocator.dart';


class AuthNotifier extends ChangeNotifier {
  final _api = getIt<DioManager>();
  final _errorHandler = getIt<ErrorHandler>();
  final _db = getIt<DBService>();
  bool _isLoading = false;
  String? _errorMessage;
  LoginData? _loginData;

  List<AvailableDriver> _drivers = [];

  List<tripsModel.Trip> _trips= [];

  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LoginData? get loginData => _loginData;
  User? get user => _user;
  List<AvailableDriver> get drivers => _drivers;
  List<tripsModel.Trip> get trips => _trips;
  double? _lat;
  double? _lng;
  double? get lat => _lat;
  double? get lng => _lng;

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
        logger.d(response.data);
        _loginData = LoginData.fromJson(response.data['data']);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen()));
        Logger().d(_loginData);
        if(_loginData?.token != null){
          _db.saveToken(_loginData?.token ?? "");
        }

        if(_loginData?.user != null){
          _user = _loginData?.user;
          final user = User.fromJson(response.data['data']['user']);
          _db.saveUser(user);
        }
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
    BuildContext context, RegisterDto payload) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notify listeners to update UI

    try {
      Response response = await _api.dio.post(
        '/taxi/auth/sign-up',
        data: payload.toJson()
      );

      if (response.statusCode == 201) {
        _db.getToken();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VerifyotpScreen(
                  identiy: payload.email.toString(),
                  intent: "sign_otp",
                )));
        _loginData = response.data['data'];
        if (_loginData?.token != null) {
          _db.saveToken(_loginData!.token!);
          _user = _loginData?.user;
          _db.saveUser(_loginData!.user!);
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
        logger.d(response.data);
        _loginData = LoginData.fromJson(response.data['data']);
        logger.d(_loginData);
        if (_loginData?.user != null) {
          _db.saveToken(_loginData!.token!);
          _db.saveUser(_loginData!.user!);
          _user = _loginData?.user;
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
    _db.deleteToken();
    await Navigator.pushNamedAndRemoveUntil(context, Routes.login, predicate);
  }

  Future<void> fetchAccount(
      BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;

    try {
      Response response = await _api.dio.get(
        '/taxi/users',
      );

      if (response.statusCode == 200) {
        logger.d(response.data);
        final user = User.fromJson(response.data['data']);
        await _db.saveUser(user);
        _db.saveUser(user);
        _user = user;
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen()));

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


  Future<void> dashboard(
      BuildContext context, {
        required String longitude,
        required String latitude,
        required bool isActive,
        required String firebaseToken,
      }) async {
    _isLoading = true;
    _errorMessage = null;
    try {
      logger.w("running data");
      Response response = await _api.dio.put(
        '/taxi/users/dashboard',
        data: {
          'longitude': lng,
          'latitude': lat,
          'isActive': isActive,
          'firebaseToken': firebaseToken
        },
      );

      if (response.statusCode == 200) {
        logger.d(response.data);
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed, try again later';
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

  Future<void> fetchAvailableDrivers(
      BuildContext context, {
       required int  radius,
        required String latitude,
        required String longitude
        // required d
      }) async {
    _isLoading = true;
    _errorMessage = null;


    try {
      logger.d(lng);
      logger.d(lat);
      Response response = await _api.dio.get(
          '/taxi/users/available/drivers?lat=333&rad=5000&lon=211121'
        // '/taxi/users/available/drivers?lat=${latitude}&rad=${radius}&lon=${longitude}'
      );

      if (response.statusCode == 200) {
        logger.w(response.data);
        final List<dynamic> data = response.data['data'];
        final List<AvailableDriver> results = data.map((json) => AvailableDriver.fromJson(json)).toList();
        _drivers = results;
        _errorMessage = null;
        notifyListeners();
      } else {
        _errorMessage = 'Failed to fetch drivers';
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


  void getCurrentLocation(BuildContext context) async {
    final hasPermission = await _handleLocationPermission(context);

    if (!hasPermission) return;

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _lat = position.latitude ?? 0.0;
      _lng = position.longitude ?? 0.0;
      logger.d(position.longitude);
      logger.d(position.latitude);
      notifyListeners();
      // setState(() {
      //   _locationMessage = 'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
      // });
    } catch (e) {
      notifyListeners();
      // setState(() {
      //   _locationMessage = "Error: ${e.toString()}";
      // });
    }
    notifyListeners();
  }

  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> fetchAddressToCoordinates(
      BuildContext context, {
        required String longitude,
        required String latitude,
        required String radius,
        required String address,
      }) async {
    _isLoading = true;
    _errorMessage = null;
    try {
      logger.w("running data");
      Response response = await _api.dio.get('/taxi/location/address?longitude=212331&latitude=3.1211&radius=50000&address=diamond hill',);

      if (response.statusCode == 200) {
        logger.d(response.data);
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed, try again later';
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

  Future<BookingResponse?> bookRide(
      BuildContext context, BookRideDto payload) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notify listeners to update UI

    try {
      Response response = await _api.dio.post(
        '/taxi/booking',
        data: payload.toJson()
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.d(response.data);
        final data = BookingResponse.fromJson(response.data);

        return data;
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to book ride';
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


  Future<void> fetchAllTrips(
      BuildContext context, {
        required int  skip,
        required int  limit,
        // required d
      }) async {
    _isLoading = true;
    _errorMessage = null;


    try {
      logger.d(lng);
      logger.d(lat);
      Response response = await _api.dio.get(
          '/taxi/booking?skip=${skip}&limit=${limit}'
      );

      if (response.statusCode == 200) {
        logger.w(response.data);
        final List<dynamic> data = response.data['data'];
        final List<tripsModel.Trip> results = data.map((json) => tripsModel.Trip.fromJson(json)).toList();
        _trips = results;
        _errorMessage = null;
        notifyListeners();
      } else {
        _errorMessage = 'Failed to fetch trips';
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

  Future<void> updateUser(
      BuildContext context, UpdateUserDto payload) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notify listeners to update UI

    try {
      Response response = await _api.dio.put(
          '/taxi/users',
          data: payload.toJson()
      );

      if (response.statusCode == 200 || response.statusCode == 200) {
        Logger().d(response.data);
        await fetchAccount(context);
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to update';
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
