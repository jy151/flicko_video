import 'package:dio/dio.dart';
import 'package:flicko_video/hive/auth/auth_box.dart';

class Http {
  static final Http _instance = Http._internal();
  factory Http() => _instance;

  late final Dio _dio;

  Http._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://bridgecode.flicko.video/api/v1/',
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
    );
  }

  Future<ApiResponse> _request(Future<Response> Function() request) async {
    try {
      final response = await request();
      final map = response.data as Map<String, dynamic>?;
      if (map == null) {
        return ApiResponse(code: -1, message: 'Empty response');
      }
      return ApiResponse.fromJson(map);
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        return ApiResponse.fromJson(data);
      }
      return ApiResponse(
        code: e.response?.statusCode ?? -1,
        message: e.message ?? 'Network error',
      );
    }
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
}
