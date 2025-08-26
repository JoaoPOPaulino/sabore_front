import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants.dart';

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier(ref);
});

final isFirstLoginProvider = StateProvider<bool>((ref) {
  return true; // Altere dinamicamente com base no JWT
});

class AuthNotifier extends StateNotifier<bool> {
  final Ref ref;
  final storage = FlutterSecureStorage();
  final Dio _dio = Dio(BaseOptions(baseUrl: apiUrl));

  AuthNotifier(this.ref) : super(false); // Inicialmente não logado

  Future<void> checkAuthStatus() async {
    final jwt = await storage.read(key: 'jwt');
    if (jwt != null) {
      try {
        final response = await _dio.get(
          '/auth/validate',
          options: Options(headers: {'Authorization': 'Bearer $jwt'}),
        );
        state = response.statusCode == 200;

        // Verifica se é o primeiro login (pode vir do backend ou storage)
        final isFirst = await storage.read(key: 'isFirstLogin') ?? 'true';
        ref.read(isFirstLoginProvider.notifier).state = isFirst == 'true';
      } catch (e) {
        await logout(); // Token inválido, faz logout
      }
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      final jwt = response.data['token']; // Ajuste conforme a resposta da API
      await storage.write(key: 'jwt', value: jwt);
      await storage.write(key: 'isFirstLogin', value: response.data['isFirstLogin']?.toString() ?? 'true');
      state = true;
      await checkAuthStatus(); // Atualiza o estado após login
    } catch (e) {
      throw Exception('Erro no login: $e');
    }
  }

  Future<void> signup(String name, String email, String phone, String password) async {
    try {
      final response = await _dio.post(
        '/auth/signup',
        data: {'name': name, 'email': email, 'phone': phone, 'password': password},
      );
      final jwt = response.data['token'];
      await storage.write(key: 'jwt', value: jwt);
      await storage.write(key: 'isFirstLogin', value: 'true');
      state = true;
      await checkAuthStatus(); // Atualiza o estado após cadastro
    } catch (e) {
      throw Exception('Erro no cadastro: $e');
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'jwt');
    await storage.delete(key: 'isFirstLogin');
    state = false;
  }

  Future<void> completeProfileSetup() async {
    await storage.write(key: 'isFirstLogin', value: 'false');
    ref.read(isFirstLoginProvider.notifier).state = false;
    await checkAuthStatus(); // Atualiza o estado após configuração
  }
}