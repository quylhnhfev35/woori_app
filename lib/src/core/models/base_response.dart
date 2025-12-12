class BaseResponse<T> {
  final bool success;
  final String message;
  final T? data;

  BaseResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? parser,
  ) {
    return BaseResponse<T>(
      success: json['success'] == true,
      message: json['message'] ?? '',
      data: parser != null ? parser(json['data']) : null,
    );
  }

  bool get isOk => success == true;
}