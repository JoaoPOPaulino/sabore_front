import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio _dio;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: ApiConfig.connectionTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.timeout,
      headers: {
        'Content-Type': ApiConfig.contentType,
        'Accept': ApiConfig.accept,
      },
    ));

    // Interceptor para adicionar token automaticamente
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: StorageKeys.jwt);
        if (token != null) {
          options.headers['Authorization'] = 'Token $token'; // ou 'Bearer $token' para JWT
        }
        print('🌐 ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ ${response.statusCode} ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (error, handler) async {
        print('❌ ${error.response?.statusCode} ${error.requestOptions.path}');

        // Tentar renovar token se 401
        if (error.response?.statusCode == 401) {
          // Implementar lógica de refresh token aqui se necessário
          // final refreshed = await _refreshToken();
          // if (refreshed) {
          //   return handler.resolve(await _retry(error.requestOptions));
          // }
        }

        return handler.next(error);
      },
    ));
  }

  // GET
  Future<Response> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      return await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST
  Future<Response> post(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      return await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT
  Future<Response> put(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      return await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PATCH
  Future<Response> patch(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      return await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE
  Future<Response> delete(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      return await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Upload de arquivo (multipart)
  Future<Response> uploadFile(
      String endpoint,
      String filePath,
      String fieldName, {
        Map<String, dynamic>? additionalData,
      }) async {
    try {
      FormData formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        ...?additionalData,
      });

      return await _dio.post(
        endpoint,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Manipulador de erros
  ApiException _handleError(DioException error) {
    String message = 'Erro desconhecido';
    int statusCode = error.response?.statusCode ?? 0;

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      message = 'Tempo de conexão esgotado';
    } else if (error.type == DioExceptionType.connectionError) {
      message = 'Erro de conexão. Verifique sua internet.';
    } else if (error.response != null) {
      final data = error.response?.data;

      if (data is Map) {
        // Tenta extrair mensagem de erro do backend
        message = data['detail'] ??
            data['message'] ??
            data['error'] ??
            _getStatusMessage(statusCode);
      } else {
        message = _getStatusMessage(statusCode);
      }
    }

    return ApiException(
      statusCode: statusCode,
      message: message,
      error: error,
    );
  }

  String _getStatusMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Requisição inválida';
      case 401:
        return 'Não autorizado. Faça login novamente.';
      case 403:
        return 'Acesso negado';
      case 404:
        return 'Recurso não encontrado';
      case 500:
        return 'Erro no servidor';
      case 503:
        return 'Serviço temporariamente indisponível';
      default:
        return 'Erro: $statusCode';
    }
  }

  // Storage helpers
  Future<void> saveToken(String token) async {
    await _storage.write(key: StorageKeys.jwt, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: StorageKeys.jwt);
  }

  Future<void> removeToken() async {
    await _storage.delete(key: StorageKeys.jwt);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

// Exception customizada
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final DioException? error;

  ApiException({
    required this.statusCode,
    required this.message,
    this.error,
  });

  @override
  String toString() => message;
}