import 'package:dio/dio.dart';

/// - [message] : nội dung lỗi hiển thị cho user / log.
/// - [statusCode] : mã HTTP (nếu có).
/// - [data] : payload server trả về (nếu muốn debug sâu hơn).
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException(
    this.message, {
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ApiException($statusCode): $message';

  /// Tạo [ApiException] từ [DioException].
  ///
  /// Dùng trong `catch (e) { throw ApiException.fromDioError(e); }`
  factory ApiException.fromDioError(DioException error) {
    int? statusCode;
    dynamic responseData;

    try {
      statusCode = error.response?.statusCode;
      responseData = error.response?.data;
    } catch (_) {}

    // DEBUG: in log để xem thật sự chuyện gì xảy ra
    // (sau này có thể thay bằng logger)
    // ignore: avoid_print
    print('DIO ERROR type = ${error.type}');
    // ignore: avoid_print
    print('DIO ERROR uri  = ${error.requestOptions.uri}');
    // ignore: avoid_print
    print('DIO ERROR raw  = ${error.error}');

    String message;

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      message = 'Kết nối máy chủ thất bại, vui lòng thử lại sau.';
    } else if (error.type == DioExceptionType.badResponse) {
      final data = error.response?.data;
      if (data is Map<String, dynamic> && data['message'] is String) {
        message = data['message'] as String;
      } else {
        message = 'Lỗi server (${statusCode ?? 'unknown'})';
      }
    } else if (error.type == DioExceptionType.connectionError) {
      // Phân tích kỹ hơn lỗi kết nối
      final raw = error.error;
      if (raw is Error || raw is Exception) {
        final rawStr = raw.toString();
        if (rawStr.contains('Failed host lookup')) {
          // DNS / domain không resolve được
          message = 'Không thể kết nối tới máy chủ. Vui lòng kiểm tra lại domain hoặc mạng.';
        } else {
          message = 'Kết nối mạng bị lỗi: $rawStr';
        }
      } else {
        message = 'Không có kết nối mạng. Vui lòng kiểm tra lại Internet.';
      }
    } else if (error.type == DioExceptionType.cancel) {
      message = 'Yêu cầu đã bị hủy.';
    } else {
      message = 'Đã xảy ra lỗi không xác định.';
    }

    return ApiException(
      message,
      statusCode: statusCode,
      data: responseData,
    );
  }

  factory ApiException.fromMessage(
    String message, {
    int? statusCode,
    dynamic data,
  }) {
    return ApiException(
      message,
      statusCode: statusCode,
      data: data,
    );
  }
}