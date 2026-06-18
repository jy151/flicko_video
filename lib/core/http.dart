import 'package:dio/dio.dart';
import 'package:flicko_video/hive/auth/auth_box.dart';

class Http {
  static final Http _instance = Http._internal();
  factory Http() => _instance;

  late final Dio _dio;

  Http._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://polenetrendshops.com/api/v1/',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = AuthBox.token;
          if (token.isNotEmpty) {
            options.headers['Authorization'] = token;
          }
          if (_userAgentClient != null) {
            options.headers['User-Agent-Client'] = _userAgentClient;
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  String? _userAgentClient;
  Future<bool>? _guestLoginRequest;

  /// 格式: {guid}/{platform}/{version}
  void setUserAgentClient(String? client) => _userAgentClient = client;

  void setBaseUrl(String url) {
    _dio.options.baseUrl = url;
  }

  Future<ApiResponse> get(
    String path, {
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
  }) async {
    return _request(
      () => _dio.get(path, queryParameters: params, cancelToken: cancelToken),
      path: path,
    );
  }

  Future<ApiResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
  }) async {
    return _request(
      () => _dio.post(
        path,
        data: data,
        queryParameters: params,
        cancelToken: cancelToken,
      ),
      path: path,
    );
  }

  Future<ApiResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
  }) async {
    return _request(
      () => _dio.put(
        path,
        data: data,
        queryParameters: params,
        cancelToken: cancelToken,
      ),
      path: path,
    );
  }

  Future<ApiResponse> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
  }) async {
    return _request(
      () => _dio.delete(
        path,
        data: data,
        queryParameters: params,
        cancelToken: cancelToken,
      ),
      path: path,
    );
  }

  Future<ApiResponse> upload(
    String path, {
    required FormData data,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    return _request(
      () => _dio.post(
        path,
        data: data,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      ),
      path: path,
    );
  }

  Future<ApiResponse> _request(
    Future<Response> Function() request, {
    required String path,
  }) async {
    try {
      final response = await request();
      final map = response.data as Map<String, dynamic>?;
      if (map == null) {
        return ApiResponse(code: -1, message: 'Empty response');
      }
      final apiResponse = ApiResponse.fromJson(map);
      if (apiResponse.isUnauthorized && !_isAuthRequest(path)) {
        await _loginAsGuestAfterUnauthorized();
      }
      return apiResponse;
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final apiResponse = ApiResponse.fromJson(data);
        if (apiResponse.isUnauthorized && !_isAuthRequest(path)) {
          await _loginAsGuestAfterUnauthorized();
        }
        return apiResponse;
      }
      if (e.response?.statusCode == 401 && !_isAuthRequest(path)) {
        await _loginAsGuestAfterUnauthorized();
      }
      return ApiResponse(
        code: e.response?.statusCode ?? -1,
        message: e.message ?? 'Network error',
      );
    }
  }

  Future<void> _loginAsGuestAfterUnauthorized() async {
    _guestLoginRequest ??= AuthBox.clear()
        .then((_) => AuthBox.login(source: 'guest'))
        .whenComplete(() => _guestLoginRequest = null);
    await _guestLoginRequest;
  }

  bool _isAuthRequest(String path) {
    return path.startsWith('/auth/');
  }
}

class ApiResponse {
  final int code;
  final dynamic data;
  final String message;
  final int? time;

  ApiResponse({required this.code, this.data, this.message = '', this.time});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      code: json['code'] as int? ?? -1,
      data: json['data'],
      message: (json['message'] ?? json['msg']) as String? ?? '',
      time: json['time'] as int?,
    );
  }

  bool get isSuccess => code == 200 || code == 1 || code == 0;

  bool get isUnauthorized => code == 401;
}
