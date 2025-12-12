import 'package:dio/dio.dart';
import '../../config/constants.dart';
import '../../services/local_storage_service.dart';

class ApiClient {
  ApiClient._internal();
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio dio;

  Future<void> init() async {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.domainBE,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await LocalStorageService.instance.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (e, handler) {
          // TODO: handle refresh token
          return handler.next(e);
        },
      ),
    );
  }
}