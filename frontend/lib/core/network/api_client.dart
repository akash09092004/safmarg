import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import 'api_response.dart';

class ApiClient {
  ApiClient._();

  static final ApiClient instance =
      ApiClient._();

  final http.Client _client =
      http.Client();

  String? _token;

  // =========================
  // TOKEN
  // =========================

  void setToken(String? token) {
    _token = token;
  }

  String? get token => _token;

  void clearToken() {
    _token = null;
  }

  // =========================
  // HEADERS
  // =========================

  Map<String, String> _headers({
    bool requiresAuth = false,
    Map<String, String>?
        additionalHeaders,
  }) {
    final headers = <String, String>{
      'Content-Type':
          'application/json',
      'Accept':
          'application/json',
    };

    if (requiresAuth &&
        _token != null &&
        _token!.isNotEmpty) {
      headers['Authorization'] =
          'Bearer $_token';
    }

    if (additionalHeaders != null) {
      headers.addAll(
        additionalHeaders,
      );
    }

    return headers;
  }

  // =========================
  // GET
  // =========================

  Future<ApiResponse<dynamic>> get(
    String url, {
    Map<String, String>?
        queryParameters,
    bool requiresAuth = false,
    Map<String, String>?
        headers,
  }) async {
    try {
      Uri uri = Uri.parse(url);

      if (queryParameters != null &&
          queryParameters.isNotEmpty) {
        uri = uri.replace(
          queryParameters: {
            ...uri.queryParameters,
            ...queryParameters,
          },
        );
      }

      _logRequest(
        method: 'GET',
        url: uri.toString(),
      );

      final response =
          await _client
              .get(
                uri,
                headers: _headers(
                  requiresAuth:
                      requiresAuth,
                  additionalHeaders:
                      headers,
                ),
              )
              .timeout(
                ApiConstants
                    .connectionTimeout,
              );

      return _handleResponse(
        response,
      );
    } on TimeoutException catch (
        error) {
      return ApiResponse.failure(
        message:
            'Request timeout. Please try again.',
        error: error,
      );
    } catch (error) {
      return ApiResponse.failure(
        message:
            'Network error. Please try again.',
        error: error,
      );
    }
  }

  // =========================
  // POST
  // =========================

  Future<ApiResponse<dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
    Map<String, String>?
        headers,
  }) async {
    try {
      final uri = Uri.parse(url);

      _logRequest(
        method: 'POST',
        url: uri.toString(),
        body: body,
      );

      final response =
          await _client
              .post(
                uri,
                headers: _headers(
                  requiresAuth:
                      requiresAuth,
                  additionalHeaders:
                      headers,
                ),
                body: body == null
                    ? null
                    : jsonEncode(
                        body,
                      ),
              )
              .timeout(
                ApiConstants
                    .connectionTimeout,
              );

      return _handleResponse(
        response,
      );
    } on TimeoutException catch (
        error) {
      return ApiResponse.failure(
        message:
            'Request timeout. Please try again.',
        error: error,
      );
    } catch (error) {
      return ApiResponse.failure(
        message:
            'Network error. Please try again.',
        error: error,
      );
    }
  }

  // =========================
  // PUT
  // =========================

  Future<ApiResponse<dynamic>> put(
    String url, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
    Map<String, String>?
        headers,
  }) async {
    try {
      final uri = Uri.parse(url);

      _logRequest(
        method: 'PUT',
        url: uri.toString(),
        body: body,
      );

      final response =
          await _client
              .put(
                uri,
                headers: _headers(
                  requiresAuth:
                      requiresAuth,
                  additionalHeaders:
                      headers,
                ),
                body: body == null
                    ? null
                    : jsonEncode(
                        body,
                      ),
              )
              .timeout(
                ApiConstants
                    .connectionTimeout,
              );

      return _handleResponse(
        response,
      );
    } on TimeoutException catch (
        error) {
      return ApiResponse.failure(
        message:
            'Request timeout. Please try again.',
        error: error,
      );
    } catch (error) {
      return ApiResponse.failure(
        message:
            'Network error. Please try again.',
        error: error,
      );
    }
  }

  // =========================
  // PATCH
  // =========================

  Future<ApiResponse<dynamic>> patch(
    String url, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
    Map<String, String>?
        headers,
  }) async {
    try {
      final uri = Uri.parse(url);

      _logRequest(
        method: 'PATCH',
        url: uri.toString(),
        body: body,
      );

      final response =
          await _client
              .patch(
                uri,
                headers: _headers(
                  requiresAuth:
                      requiresAuth,
                  additionalHeaders:
                      headers,
                ),
                body: body == null
                    ? null
                    : jsonEncode(
                        body,
                      ),
              )
              .timeout(
                ApiConstants
                    .connectionTimeout,
              );

      return _handleResponse(
        response,
      );
    } on TimeoutException catch (
        error) {
      return ApiResponse.failure(
        message:
            'Request timeout. Please try again.',
        error: error,
      );
    } catch (error) {
      return ApiResponse.failure(
        message:
            'Network error. Please try again.',
        error: error,
      );
    }
  }

  // =========================
  // DELETE
  // =========================

  Future<ApiResponse<dynamic>> delete(
    String url, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
    Map<String, String>?
        headers,
  }) async {
    try {
      final uri = Uri.parse(url);

      _logRequest(
        method: 'DELETE',
        url: uri.toString(),
        body: body,
      );

      final request =
          http.Request(
        'DELETE',
        uri,
      );

      request.headers.addAll(
        _headers(
          requiresAuth:
              requiresAuth,
          additionalHeaders:
              headers,
        ),
      );

      if (body != null) {
        request.body = jsonEncode(
          body,
        );
      }

      final streamedResponse =
          await _client
              .send(request)
              .timeout(
                ApiConstants
                    .connectionTimeout,
              );

      final response =
          await http.Response
              .fromStream(
        streamedResponse,
      );

      return _handleResponse(
        response,
      );
    } on TimeoutException catch (
        error) {
      return ApiResponse.failure(
        message:
            'Request timeout. Please try again.',
        error: error,
      );
    } catch (error) {
      return ApiResponse.failure(
        message:
            'Network error. Please try again.',
        error: error,
      );
    }
  }

  // =========================
  // RESPONSE HANDLER
  // =========================

  ApiResponse<dynamic>
      _handleResponse(
    http.Response response,
  ) {
    _logResponse(response);

    dynamic decoded;

    try {
      if (response.body.isEmpty) {
        decoded =
            <String, dynamic>{};
      } else {
        decoded =
            jsonDecode(
          response.body,
        );
      }
    } catch (_) {
      return ApiResponse.failure(
        message:
            'Invalid server response',
        statusCode:
            response.statusCode,
        error: response.body,
      );
    }

    if (decoded
        is Map<String, dynamic>) {
      final success =
          decoded['success'] ==
              true;

      final message =
          decoded['message']
                  ?.toString() ??
              _defaultMessage(
                response
                    .statusCode,
              );

      if (response.statusCode >=
              200 &&
          response.statusCode <
              300 &&
          success) {
        return ApiResponse.success(
          data: decoded['data'],
          message: message,
          statusCode:
              response.statusCode,
        );
      }

      return ApiResponse.failure(
        message: message,
        statusCode:
            response.statusCode,
        error:
            decoded['errors'] ??
                decoded['error'] ??
                decoded,
      );
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return ApiResponse.success(
        data: decoded,
        message: 'Success',
        statusCode:
            response.statusCode,
      );
    }

    return ApiResponse.failure(
      message: _defaultMessage(
        response.statusCode,
      ),
      statusCode:
          response.statusCode,
      error: decoded,
    );
  }

  // =========================
  // DEFAULT ERROR MESSAGE
  // =========================

  String _defaultMessage(
    int statusCode,
  ) {
    switch (statusCode) {
      case 400:
        return 'Bad request';

      case 401:
        return 'Unauthorized. Please login again.';

      case 403:
        return 'You do not have permission.';

      case 404:
        return 'Requested data not found.';

      case 409:
        return 'Conflict. Please try again.';

      case 422:
        return 'Validation failed.';

      case 500:
        return 'Server error. Please try again.';

      default:
        return 'Something went wrong.';
    }
  }

  // =========================
  // DEBUG REQUEST LOG
  // =========================

  void _logRequest({
    required String method,
    required String url,
    dynamic body,
  }) {
    if (!kDebugMode) {
      return;
    }

    debugPrint(
      '================ API REQUEST ================',
    );

    debugPrint(
      '$method $url',
    );

    if (body != null) {
      debugPrint(
        'BODY: ${jsonEncode(body)}',
      );
    }

    debugPrint(
      '=============================================',
    );
  }

  // =========================
  // DEBUG RESPONSE LOG
  // =========================

  void _logResponse(
    http.Response response,
  ) {
    if (!kDebugMode) {
      return;
    }

    debugPrint(
      '=============== API RESPONSE ===============',
    );

    debugPrint(
      'STATUS: ${response.statusCode}',
    );

    debugPrint(
      'BODY: ${response.body}',
    );

    debugPrint(
      '============================================',
    );
  }

  // =========================
  // CLOSE CLIENT
  // =========================

  void close() {
    _client.close();
  }
}

