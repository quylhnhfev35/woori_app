import 'package:dio/dio.dart';
import 'package:woori_app/src/config/constants.dart';
import 'package:woori_app/src/core/models/base_response.dart';
import 'package:woori_app/src/core/network/api_client.dart';
import 'package:woori_app/src/core/network/api_exception.dart';
import 'package:woori_app/src/features/dashboard/data/dto/phong_tap_summary.dart';

class DashboardRepository {
  DashboardRepository() : _dio = ApiClient().dio;

  final Dio _dio;

  Future<PhongTapSummary> fetchSummary() async {
    try {
      final resp = await _dio.get(AppConstants.buoiTapSummaryPath);

      final data = resp.data;
      if (data is! Map<String, dynamic>) {
        throw ApiException.fromMessage(
          'Phản hồi server không hợp lệ',
          statusCode: resp.statusCode,
          data: {'raw': data},
        );
      }

      final base = BaseResponse<PhongTapSummary>.fromJson(
        data,
        (json) => PhongTapSummary.fromJson(json as Map<String, dynamic>),
      );

      if (!base.isOk) {
        throw ApiException.fromMessage(
          base.message.isNotEmpty ? base.message : 'Không lấy được tổng quan',
          statusCode: resp.statusCode,
          data: data,
        );
      }

      final summary = base.data;
      if (summary == null) {
        throw ApiException.fromMessage(
          'Thiếu data tổng quan',
          statusCode: resp.statusCode,
          data: data,
        );
      }

      return summary;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (_) {
      throw ApiException.fromMessage('Đã xảy ra lỗi khi tải tổng quan');
    }
  }

  Future<List<Map<String, dynamic>>> fetchBuoiTaps({
    int page = 1,
    int limit = 10,
    String? lopHocId,
    String? giangVienId,
    DateTime? fromDate,
    DateTime? toDate,
    String? trangThai,
  }) async {
    try {
      final resp = await _dio.get(
        AppConstants.buoiTapPath,
        queryParameters: <String, dynamic>{
          'page': page,
          'limit': limit,
          if (lopHocId != null && lopHocId.isNotEmpty) 'lopHoc': lopHocId,
          if (giangVienId != null && giangVienId.isNotEmpty)
            'giangVienPhuTrach': giangVienId,
          if (trangThai != null && trangThai.isNotEmpty) 'trangThai': trangThai,
          // NOTE: backend đang dùng query kiểu Mongo { ngay: { $gte, $lte } }
          // Nếu bạn expose đúng như vậy qua query string thì truyền nested map như dưới:
          if (fromDate != null || toDate != null)
            'ngay': <String, dynamic>{
              if (fromDate != null) r'$gte': fromDate.toIso8601String(),
              if (toDate != null) r'$lte': toDate.toIso8601String(),
            },
        },
      );

      final data = resp.data;
      if (data is! Map<String, dynamic>) {
        throw ApiException.fromMessage(
          'Phản hồi server không hợp lệ',
          statusCode: resp.statusCode,
          data: {'raw': data},
        );
      }

      // Kỳ vọng data trả về là list items
      // Nếu backend trả { data: { items: [], total: ... } } thì bạn báo mình để map lại.
      final base = BaseResponse<List<dynamic>>.fromJson(
        data,
        (json) => json as List<dynamic>,
      );

      if (!base.isOk) {
        throw ApiException.fromMessage(
          base.message.isNotEmpty ? base.message : 'Không lấy được danh sách buổi tập',
          statusCode: resp.statusCode,
          data: data,
        );
      }

      return (base.data ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (_) {
      throw ApiException.fromMessage('Đã xảy ra lỗi khi tải buổi tập');
    }
  }
}