import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';
import '../services/mock_auth_service.dart';
import '../services/api_service.dart';
import '../constants.dart';
import '../models/recipe.dart';

// Providers
final authServiceProvider = Provider<dynamic>((ref) {
  return USE_MOCK_SERVICES ? MockAuthService() : AuthService();
});

final apiServiceProvider = Provider((ref) => ApiService());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

final isFirstLoginProvider = StateProvider<bool>((ref) {
  return true;
});

// Provider para dados do usuário atual
final currentUserDataProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

// Provider para o usuário atual
final currentUserProvider = FutureProvider<User?>((ref) async {
  final authState = ref.watch(authProvider);
  if (!authState.isAuthenticated) return null;

  try {
    final authService = ref.read(authServiceProvider);
    final userData = await authService.getCurrentUser();
    return User.fromJson(userData);
  } catch (e) {
    print('❌ Error loading current user: $e');
    return null;
  }
});

// Estado de autenticação
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final bool isInitialized;
  final String? error;

  AuthState({
    required this.isAuthenticated,
    this.isLoading = false,
    this.isInitialized = false,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    bool? isInitialized,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  final FlutterSecureStorage storage = FlutterSecureStorage();
  late final dynamic _authService;
  late final ApiService _apiService;

  AuthNotifier(this.ref) : super(AuthState(isAuthenticated: false)) {
    _authService = ref.read(authServiceProvider);
    _apiService = ref.read(apiServiceProvider);
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    state = state.copyWith(isLoading: true);
    await checkAuthStatus();
    state = state.copyWith(isLoading: false, isInitialized: true);
  }

  Future<void> checkAuthStatus() async {
    print('🔍 Checking auth status...');

    try {
      final hasToken = await _apiService.hasToken();

      if (hasToken) {
        print('🔑 Token found, validating...');

        try {
          final userData = await _authService.getCurrentUser();
          ref.read(currentUserDataProvider.notifier).state = userData;
          state = state.copyWith(isAuthenticated: true);

          final isFirst = await storage.read(key: StorageKeys.isFirstLogin) ?? 'true';
          ref.read(isFirstLoginProvider.notifier).state = isFirst == 'true';

          print('✅ User authenticated. First login: $isFirst');
        } catch (e) {
          print('❌ Token invalid, logging out');
          await logout();
        }
      } else {
        print('❌ No token found');
        state = state.copyWith(isAuthenticated: false);
      }
    } catch (e) {
      print('❌ Error checking auth status: $e');
      state = state.copyWith(isAuthenticated: false);
    }
  }

  Future<void> login(String email, String password) async {
    print('🔐 Attempting login with: $email');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      final token = response['token'] ?? response['access'];
      if (token != null) {
        await _apiService.saveToken(token);
        await storage.write(key: StorageKeys.isFirstLogin, value: 'true');
        await storage.write(key: StorageKeys.userEmail, value: email);

        if (response['user'] != null) {
          ref.read(currentUserDataProvider.notifier).state = response['user'];
        }

        state = state.copyWith(
          isAuthenticated: true,
          isLoading: false,
        );
        ref.read(isFirstLoginProvider.notifier).state = true;

        print('✅ Login successful');
      } else {
        throw Exception('Token não recebido do servidor');
      }
    } on ApiException catch (e) {
      print('❌ Login error: ${e.message}');
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
      throw ApiException(statusCode: e.statusCode, message: e.message);
    } catch (e) {
      print('❌ Login error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Erro no login. Tente novamente.',
      );
      rethrow;
    }
  }

  Future<void> signup(
      String name,
      String email,
      String phone,
      String password,
      ) async {
    print('📝 Attempting signup with: $email');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _authService.register(
        name: name,
        email: email,
        password: password,
        phone: phone.isNotEmpty ? phone : null,
      );

      final token = response['token'] ?? response['access'];
      if (token != null) {
        await _apiService.saveToken(token);
        await storage.write(key: StorageKeys.isFirstLogin, value: 'true');
        await storage.write(key: StorageKeys.userEmail, value: email);

        if (response['user'] != null) {
          ref.read(currentUserDataProvider.notifier).state = response['user'];
        }

        state = state.copyWith(
          isAuthenticated: true,
          isLoading: false,
        );
        ref.read(isFirstLoginProvider.notifier).state = true;

        print('✅ Signup successful');
      } else {
        throw Exception('Token não recebido do servidor');
      }
    } on ApiException catch (e) {
      print('❌ Signup error: ${e.message}');
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
      throw ApiException(statusCode: e.statusCode, message: e.message);
    } catch (e) {
      print('❌ Signup error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Erro no cadastro. Tente novamente.',
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    print('🚪 Logging out...');

    try {
      await _authService.logout();
    } catch (e) {
      print('❌ Logout error: $e');
    } finally {
      await storage.delete(key: StorageKeys.jwt);
      await storage.delete(key: StorageKeys.isFirstLogin);
      await storage.delete(key: StorageKeys.userEmail);

      ref.read(currentUserDataProvider.notifier).state = null;
      state = state.copyWith(isAuthenticated: false);
      ref.read(isFirstLoginProvider.notifier).state = true;

      print('✅ Logout complete');
    }
  }

  Future<void> completeProfileSetup() async {
    print('✅ Profile setup completed');
    await storage.write(key: StorageKeys.isFirstLogin, value: 'false');
    ref.read(isFirstLoginProvider.notifier).state = false;
  }

  Future<void> forceLogin() async {
    print('🧪 Force login for testing...');
    final fakeToken = 'fake-jwt-token-for-testing';
    await _apiService.saveToken(fakeToken);
    await storage.write(key: StorageKeys.isFirstLogin, value: 'false');

    state = state.copyWith(isAuthenticated: true);
    ref.read(isFirstLoginProvider.notifier).state = false;
    print('✅ Force login complete');
  }
}