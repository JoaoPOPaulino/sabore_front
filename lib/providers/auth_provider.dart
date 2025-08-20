import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false); // Inicialmente não logado
  final storage = FlutterSecureStorage();

  Future<void> checkAuthStatus() async {
    final jwt = await storage.read(key: 'jwt');
    state = jwt != null;
  }

  Future<void> login(String email, String password) async {
    // Simula chamada de API (substitua pelo Dio)
    await storage.write(key: 'jwt', value: 'mock_token');
    state = true;
  }

  Future<void> signup(String name, String email, String phone, String password) async {
    await storage.write(key: 'jwt', value: 'mock_token');
    state = true;
  }

  Future<void> logout() async {
    await storage.delete(key: 'jwt');
    state = false;
  }
}