import 'package:dio/dio.dart';
import 'package:salama_users/app/network/api_client.dart';
import 'package:salama_users/locator.dart';

class ApiService {
  final _api = getIt<DioManager>();

  Future<Map<String, dynamic>> login({
    required String identity,
    required String password,
    required String userType,
    required String device,
  }) async {
    try {
      Response response = await _api.dio.post(
        '/login', // Endpoint for login
        data: {
          'identity': identity,
          'password': password,
          'userType': userType,
          'device': device,
        },
      );

      if (response.statusCode == 200) {
        return {
          'status': 'success',
          'message': response.data['message'],
          'data': response.data['data'],
        };
      } else {
        return {
          'status': 'error',
          'message': 'Failed to login',
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }
}
