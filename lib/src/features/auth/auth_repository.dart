// lib/src/features/auth/auth_repository.dart
import 'package:dio/dio.dart';
import 'package:woori_app/src/config/constants.dart';
import 'package:woori_app/src/core/models/base_response.dart';
import 'package:woori_app/src/core/network/api_client.dart';
import 'package:woori_app/src/core/network/api_exception.dart';
import 'package:woori_app/src/services/local_storage_service.dart';

class AuthRepository {
  AuthRepository()
      : _dio = ApiClient().dio,
        _storage = LocalStorageService.instance;

  final Dio _dio;
  final LocalStorageService _storage;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    try {
      final resp = await _dio.post(
        AppConstants.loginPath,
        data: <String, dynamic>{
          'user_name': username,
          'password': password,
        },
      );

      final raw = resp.data as Map<String, dynamic>;

      final base = BaseResponse<Map<String, dynamic>>.fromJson(
        raw,
        (json) => json as Map<String, dynamic>,
      );

      if (!base.isOk) {
        throw ApiException.fromMessage(
          base.message.isNotEmpty ? base.message : 'Đăng nhập thất bại',
          statusCode: resp.statusCode,
          data: raw,
        );
      }

      final token = base.data?['token'] as String?;

      if (token == null || token.isEmpty) {
        throw ApiException.fromMessage(
          'Token không tồn tại trong phản hồi server',
          statusCode: resp.statusCode,
          data: raw,
        );
      }

      // Lưu token vào secure storage
      await _storage.saveAccessToken(token);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException.fromMessage('Đã xảy ra lỗi khi đăng nhập');
    }
  }

  Future<void> register({
    required String username,
    required String password,
    required String hoTen,
    String? soDienThoai,
  }) async {
    try {
      final resp = await _dio.post(
        AppConstants.registerPath,
        data: <String, dynamic>{
          'user_name': username,
          'password': password,
          'hoTen': hoTen,
          if (soDienThoai != null && soDienThoai.isNotEmpty)
            'soDienThoai': soDienThoai,
        },
      );

      final raw = resp.data as Map<String, dynamic>;

      // Backend: { success, message, data: { id, user_name } }
      final base = BaseResponse<void>.fromJson(raw, null);

      if (!base.isOk) {
        throw ApiException.fromMessage(
          base.message.isNotEmpty ? base.message : 'Đăng ký thất bại',
          statusCode: resp.statusCode,
          data: raw,
        );
      }

      // Nếu cần dùng data:
      // final payload = raw['data'] as Map<String, dynamic>?;
      // final id = payload?['id'];
      // final userName = payload?['user_name'];
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException.fromMessage('Đã xảy ra lỗi khi đăng ký');
    }
  }
}