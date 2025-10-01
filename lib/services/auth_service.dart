import 'package:dio/dio.dart';
import '../constants.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  /// Login do usuário
  /// Retorna o token e dados do usuário
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      print('✅ Login successful');
      return response.data;
    } catch (e) {
      print('❌ Login error: $e');
      rethrow;
    }
  }

  /// Registro de novo usuário
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          if (phone != null) 'phone': phone,
        },
      );

      print('✅ Registration successful');
      return response.data;
    } catch (e) {
      print('❌ Registration error: $e');
      rethrow;
    }
  }

  /// Logout do usuário
  Future<void> logout() async {
    try {
      await _apiService.post(ApiEndpoints.logout);
      await _apiService.removeToken();
      print('✅ Logout successful');
    } catch (e) {
      print('❌ Logout error: $e');
      // Mesmo com erro, remove o token localmente
      await _apiService.removeToken();
    }
  }

  /// Obter perfil do usuário atual
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _apiService.get(ApiEndpoints.profile);
      return response.data;
    } catch (e) {
      print('❌ Get current user error: $e');
      rethrow;
    }
  }

  /// Atualizar perfil do usuário
  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? location,
    String? bio,
    String? profileImage,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (location != null) data['location'] = location;
      if (bio != null) data['bio'] = bio;
      if (profileImage != null) data['profile_image'] = profileImage;

      final response = await _apiService.patch(
        ApiEndpoints.updateProfile,
        data: data,
      );

      print('✅ Profile updated');
      return response.data;
    } catch (e) {
      print('❌ Update profile error: $e');
      rethrow;
    }
  }

  /// Upload de foto de perfil
  Future<Map<String, dynamic>> uploadProfileImage(String filePath) async {
    try {
      final response = await _apiService.uploadFile(
        ApiEndpoints.updateProfile,
        filePath,
        'profile_image',
      );

      print('✅ Profile image uploaded');
      return response.data;
    } catch (e) {
      print('❌ Upload profile image error: $e');
      rethrow;
    }
  }

  /// Verificar se email está disponível
  Future<bool> checkEmailAvailability(String email) async {
    try {
      final response = await _apiService.get(
        '/auth/check-email/',
        queryParameters: {'email': email},
      );

      return !(response.data['exists'] ?? false);
    } catch (e) {
      print('❌ Check email error: $e');
      return true; // Em caso de erro, permite continuar
    }
  }

  /// Verificar se está autenticado
  Future<bool> isAuthenticated() async {
    return await _apiService.hasToken();
  }

  /// Solicitar recuperação de senha
  Future<void> requestPasswordReset(String email) async {
    try {
      await _apiService.post(
        '/auth/password-reset/',
        data: {'email': email},
      );
      print('✅ Password reset email sent');
    } catch (e) {
      print('❌ Password reset error: $e');
      rethrow;
    }
  }

  /// Redefinir senha com token
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _apiService.post(
        '/auth/password-reset/confirm/',
        data: {
          'token': token,
          'password': newPassword,
        },
      );
      print('✅ Password reset successful');
    } catch (e) {
      print('❌ Password reset confirmation error: $e');
      rethrow;
    }
  }
}