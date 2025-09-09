import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

final isFirstLoginProvider = StateProvider<bool>((ref) {
  return true;
});

// Estado de autenticação mais robusto
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final bool isInitialized;

  AuthState({
    required this.isAuthenticated,
    this.isLoading = false,
    this.isInitialized = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    bool? isInitialized,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  final storage = FlutterSecureStorage();
  final Dio _dio = Dio(BaseOptions(baseUrl: apiUrl));

  AuthNotifier(this.ref) : super(AuthState(isAuthenticated: false)) {
    // Checa o status de autenticação na inicialização
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    state = state.copyWith(isLoading: true);
    await checkAuthStatus();
    state = state.copyWith(isLoading: false, isInitialized: true);
  }

  Future<void> checkAuthStatus() async {
    print('🔍 Checking auth status...');
    final jwt = await storage.read(key: 'jwt');

    if (jwt != null) {
      print('🔑 JWT found: $jwt');
      try {
        // Como estamos usando token fake, vamos simular validação
        if (jwt == 'fake-jwt-token') {
          state = state.copyWith(isAuthenticated: true);

          // Verifica se é o primeiro login
          final isFirst = await storage.read(key: 'isFirstLogin') ?? 'true';
          ref.read(isFirstLoginProvider.notifier).state = isFirst == 'true';

          print('✅ User authenticated. First login: $isFirst');
        } else {
          print('❌ Invalid token, logging out');
          await logout();
        }
      } catch (e) {
        print('❌ Error validating token: $e');
        await logout();
      }
    } else {
      print('❌ No JWT found');
      state = state.copyWith(isAuthenticated: false);
    }
  }

  Future<void> login(String email, String password) async {
    print('🔐 Attempting login with: $email');
    state = state.copyWith(isLoading: true);

    try {
      // Simulação de login com usuário fake
      if (email == 'test@example.com' && password == 'password123') {
        final jwt = 'fake-jwt-token';
        await storage.write(key: 'jwt', value: jwt);
        await storage.write(key: 'isFirstLogin', value: 'true');

        state = state.copyWith(isAuthenticated: true, isLoading: false);
        ref.read(isFirstLoginProvider.notifier).state = true;

        print('✅ Login successful');
      } else {
        throw Exception('Credenciais inválidas');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      throw Exception('Erro no login: $e');
    }
  }

  Future<void> signup(String name, String email, String phone, String password) async {
    print('📝 Attempting signup with: $email');
    state = state.copyWith(isLoading: true);

    try {
      // Simulação de cadastro
      if (email == 'existing@example.com') {
        throw Exception('E-mail já em uso');
      }

      final jwt = 'fake-jwt-token';
      await storage.write(key: 'jwt', value: jwt);
      await storage.write(key: 'isFirstLogin', value: 'true');

      state = state.copyWith(isAuthenticated: true, isLoading: false);
      ref.read(isFirstLoginProvider.notifier).state = true;

      print('✅ Signup successful');
    } catch (e) {
      state = state.copyWith(isLoading: false);
      throw Exception('Erro no cadastro: $e');
    }
  }

  Future<void> logout() async {
    print('🚪 Logging out...');
    await storage.delete(key: 'jwt');
    await storage.delete(key: 'isFirstLogin');
    state = state.copyWith(isAuthenticated: false);
    ref.read(isFirstLoginProvider.notifier).state = true;
    print('✅ Logout complete');
  }

  Future<void> completeProfileSetup() async {
    print('✅ Profile setup completed');
    await storage.write(key: 'isFirstLogin', value: 'false');
    ref.read(isFirstLoginProvider.notifier).state = false;
  }

  // Método para testar a autenticação
  void forceLogin() async {
    print('🧪 Force login for testing...');
    final jwt = 'fake-jwt-token';
    await storage.write(key: 'jwt', value: jwt);
    await storage.write(key: 'isFirstLogin', value: 'false'); // Pula o profile setup

    state = state.copyWith(isAuthenticated: true);
    ref.read(isFirstLoginProvider.notifier).state = false;
    print('✅ Force login complete');
  }
}