class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int? statusCode;
  final dynamic error;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
    this.error,
  });

  // =========================
  // SUCCESS RESPONSE
  // =========================

  factory ApiResponse.success({
    required T? data,
    String message = 'Success',
    int? statusCode,
  }) {
    return ApiResponse<T>(
      success: true,
      message: message,
      data: data,
      statusCode: statusCode,
    );
  }

  // =========================
  // ERROR RESPONSE
  // =========================

  factory ApiResponse.failure({
    required String message,
    int? statusCode,
    dynamic error,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      statusCode: statusCode,
      error: error,
    );
  }

  // =========================
  // JSON PARSER
  // =========================

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic json)? parser,
    int? statusCode,
  }) {
    final rawData = json['data'];

    T? parsedData;

    if (rawData != null) {
      if (parser != null) {
        parsedData = parser(rawData);
      } else {
        parsedData = rawData as T?;
      }
    }

    return ApiResponse<T>(
      success: json['success'] == true,
      message:
          json['message']?.toString() ??
              (json['success'] == true
                  ? 'Success'
                  : 'Something went wrong'),
      data: parsedData,
      statusCode: statusCode,
      error: json['error'],
    );
  }

  // =========================
  // COPY
  // =========================

  ApiResponse<T> copyWith({
    bool? success,
    String? message,
    T? data,
    int? statusCode,
    dynamic error,
  }) {
    return ApiResponse<T>(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
      statusCode:
          statusCode ?? this.statusCode,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'ApiResponse('
        'success: $success, '
        'message: $message, '
        'statusCode: $statusCode, '
        'data: $data'
        ')';
  }
}

