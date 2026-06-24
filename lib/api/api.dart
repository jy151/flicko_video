import 'package:dio/dio.dart';
import 'package:flicko_video/api/model/auth_model.dart';
import 'package:flicko_video/api/model/config_model.dart';
import 'package:flicko_video/api/model/member_model.dart';
import 'package:flicko_video/api/model/subscribe_model.dart';
import 'package:flicko_video/api/model/video_model.dart';
import 'package:flicko_video/core/http.dart';

class Api {
  static final Http _http = Http();

  // ==================== Auth ====================

  static Future<AuthResponse?> activation({
    required String source,
    String? accessToken,
    String? account,
    String? password,
    int? gender,
    String? inviterCode,
    String? inviterChannel,
    String? inviterApp,
  }) async {
    final res = await _http.post(
      '/auth/activation',
      data: {
        'source': source,
        'accessToken': ?accessToken,
        'account': ?account,
        'password': ?password,
        'gender': ?gender,
        'inviterCode': ?inviterCode,
        'inviterChannel': ?inviterChannel,
        'inviterApp': ?inviterApp,
      },
    );
    if (res.isSuccess && res.data is Map<String, dynamic>) {
      final auth = AuthResponse.fromJson(res.data as Map<String, dynamic>);

      return auth;
    }
    return null;
  }

  static Future<ApiResponse> logout() async {
    final res = await _http.get('/auth/logout');

    return res;
  }

  static Future<ApiResponse> deleteAccount() async {
    return await _http.get('/auth/del');
  }

  static Future<AuthCheckResponse?> checkToken() async {
    final res = await _http.get('/auth/check');
    if (res.isSuccess && res.data is Map<String, dynamic>) {
      return AuthCheckResponse.fromJson(res.data as Map<String, dynamic>);
    }
    return null;
  }

  // ==================== Member ====================

  static Future<Member?> getMember() async {
    final res = await _http.get('/member');
    if (res.isSuccess && res.data is Map<String, dynamic>) {
      return Member.fromJson(res.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<ApiResponse> updateMember(Map<String, dynamic> data) async {
    return await _http.put('/member', data: data);
  }

  static Future<MemberAudit?> getMemberAudit() async {
    final res = await _http.get('/member/audit');
    if (res.isSuccess && res.data is Map<String, dynamic>) {
      return MemberAudit.fromJson(res.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<ApiResponse> submitFeedback({
    required int memberId,
    required String feedbackContent,
    String? feedbackEmail,
    String? reportType,
  }) async {
    return await _http.post(
      '/member/feedback',
      data: {
        'memberId': memberId,
        'feedbackContent': feedbackContent,
        'feedbackEmail': ?feedbackEmail,
        'report_type': ?reportType,
      },
    );
  }

  // ==================== Attribution ====================

  static Future<ApiResponse> reportAttribution(
    Map<String, dynamic> data,
  ) async {
    return await _http.post('/attribution/adjust/clientios', data: data);
  }

  // ==================== Config ====================

  static Future<AiModelConfig?> getAllAiModels() async {
    final res = await _http.get('/ai/aigc/model/credit/all');
    if (res.isSuccess && res.data is Map<String, dynamic>) {
      return AiModelConfig.fromJson(res.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<List<AiModel>> getAiModelsByType(String type) async {
    final res = await _http.get(
      '/ai/aigc/model/credit',
      params: {'type': type},
    );
    if (res.isSuccess && res.data is List) {
      return (res.data as List)
          .map((e) => AiModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  static Future<Map<String, dynamic>?> getDynamicConfig() async {
    final res = await _http.get('/comm/client/config/dynamic');
    if (res.isSuccess && res.data is Map<String, dynamic>) {
      return res.data as Map<String, dynamic>;
    }
    return null;
  }

  static Future<ApiResponse> reportBehavior(dynamic data) async {
    return await _http.post('/behavior/rept/app', data: data);
  }

  static Future<Balance?> getBalance(int memberId) async {
    final res = await _http.get(
      '/ai/aigc/model/balance',
      params: {'member_id': memberId},
    );
    if (res.isSuccess && res.data is Map<String, dynamic>) {
      return Balance.fromJson(res.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<OrderCheckResponse?> checkOrder(String orderId) async {
    final res = await _http.get(
      '/config/order_check',
      params: {'order_id': orderId},
    );
    if (res.data is Map<String, dynamic>) {
      return OrderCheckResponse.fromJson(res.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<ApiResponse> checkAigcModelOrder(String orderId) async {
    return await _http.get(
      '/ai/aigc/model/order/check',
      params: {'order_id': orderId},
    );
  }

  static Future<OrderCreateResponse?> createOrder({
    required int productId,
    required String payType,
  }) async {
    final res = await _http.post(
      '/config/order_create',
      data: {'product_id': productId, 'pay_type': payType},
    );
    if (res.data is Map<String, dynamic>) {
      return OrderCreateResponse.fromJson(res.data as Map<String, dynamic>);
    }
    return null;
  }

  // ==================== Subscribe ====================

  static Future<SubscribeInfo?> getSubscribeInfo() async {
    final res = await _http.get('/payment/subscribe');
    if (res.isSuccess && res.data is Map<String, dynamic>) {
      return SubscribeInfo.fromJson(res.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<ApiResponse> applePay({
    required String receipt,
    required String productId,
  }) async {
    return await _http.post(
      '/auth/applePay',
      data: {'receipt': receipt, 'productId': productId},
    );
  }

  // ==================== Video ====================

  static Future<CreativeHome?> getCreativeHome() async {
    final res = await _http.get('/video/creative/home');
    if (res.isSuccess && res.data is Map<String, dynamic>) {
      return CreativeHome.fromJson(res.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<List<Work>> getAllWorks() async {
    final res = await _http.get('/video/work/all');
    if (res.isSuccess && res.data is List) {
      return (res.data as List)
          .map((e) => Work.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  static Future<List<Work>> getVideoWorks() async {
    final res = await _http.get('/ai/work/all');
    if (res.isSuccess && res.data is List) {
      return (res.data as List)
          .map((e) => Work.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  static Future<List<Work>> getImageWorks() async {
    final res = await _http.get('/video/work/image');
    if (res.isSuccess && res.data is List) {
      return (res.data as List)
          .map((e) => Work.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  static Future<Work?> getVideoWorkDetail(int id) async {
    final res = await _http.get('/video/creative/$id');
    if (res.isSuccess && res.data is Map<String, dynamic>) {
      return Work.fromJson(res.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<Work?> getImageWorkDetail(int id) async {
    final res = await _http.get('/video/work/image/$id');
    if (res.isSuccess && res.data is Map<String, dynamic>) {
      return Work.fromJson(res.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<ApiResponse> deleteWork(int id) async {
    return await _http.delete('/video/creative/$id');
  }

  static Future<String?> uploadImage(String imagePath) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(imagePath),
    });
    final res = await _http.upload('/video/image/upload', data: formData);
    if (res.isSuccess && res.data is String) {
      return res.data as String;
    }
    return null;
  }

  static Future<AiCreateResponse?> createAiTask({
    required String type,
    String? prompt,
    String? image,
    int? styleId,
    int? duration,
    int? templateId,
  }) async {
    final res = await _http.post(
      '/ai/work',
      data: {
        'type': type,
        'prompt': ?prompt,
        'image': ?image,
        'parameters': {'styleId': ?styleId, 'duration': ?duration},
        'templateId': ?templateId,
      },
    );
    if (res.isSuccess && res.data is Map<String, dynamic>) {
      final data = Map<String, dynamic>.from(res.data as Map<String, dynamic>);
      data['type'] ??= type;
      return AiCreateResponse.fromJson(data);
    }
    if (!res.isSuccess) {
      throw ApiException(res.message);
    }
    return null;
  }

  static Future<AiStatusResponse?> getAiTaskStatus({
    required String promptId,
    required int type,
  }) async {
    final res = await _http.get(
      '/video/creative/status',
      params: {'prompt_id': promptId, 'type': type},
    );
    if (res.isSuccess && res.data is Map<String, dynamic>) {
      return AiStatusResponse.fromJson(res.data as Map<String, dynamic>);
    }
    return null;
  }

  static Future<List<ShowcaseCategory>> getShowcaseCategories() async {
    final res = await _http.get('/ai/aigc/recommend/discover/work');
    if (res.isSuccess && res.data is List) {
      return (res.data as List)
          .map((e) => ShowcaseCategory.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  static Future<List<Work>> getShowcaseWorks({
    int categoryId = 0,
    String sort = 'latest',
    int size = 20,
    int lastId = 0,
  }) async {
    final res = await _http.get(
      '/ai/aigc/recommend/discover/work',
      params: {
        'categoryId': categoryId,
        'sort': sort,
        'size': size,
        'lastId': lastId,
      },
    );
    if (res.isSuccess && res.data is List) {
      return (res.data as List)
          .map((e) => Work.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() {
    return message.isEmpty ? 'ApiException' : message;
  }
}
