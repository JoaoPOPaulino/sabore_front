import 'dart:async';

class MockAuthService {
  // Banco de dados fake em memória (persiste durante a execução do app)
  static final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'name': 'Usuario Teste',
      'email': 'test@example.com',
      'password': 'password123',
      'phone': '+5511999999999',
    }
  ];

  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(Duration(milliseconds: 800));
  }

  Future<bool> checkEmailAvailability(String email) async {
    print('🔍 [MOCK] Checking email availability: $email');
    await _simulateNetworkDelay();

    final exists = _users.any((user) => user['email'] == email.toLowerCase());
    print('${exists ? '❌' : '✅'} [MOCK] Email ${exists ? 'já existe' : 'disponível'}');

    return !exists;
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    print('📝 [MOCK] Registering user: $email');
    print('📝 [MOCK] Password: $password'); // Debug
    await _simulateNetworkDelay();

    // Verifica se email já existe
    if (_users.any((user) => user['email'] == email.toLowerCase())) {
      print('❌ [MOCK] Email already exists');
      throw Exception('Email já cadastrado');
    }

    // Cria novo usuário
    final newUser = {
      'id': '${_users.length + 1}',
      'name': name,
      'email': email.toLowerCase(),
      'password': password,
      'phone': phone,
    };

    _users.add(newUser);

    print('✅ [MOCK] User registered successfully');
    print('📋 [MOCK] Total users: ${_users.length}');
    print('📋 [MOCK] All users: ${_users.map((u) => u['email']).toList()}');

    return {
      'token': 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
      'access': 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
      'user': {
        'id': newUser['id'],
        'name': newUser['name'],
        'email': newUser['email'],
        'phone': newUser['phone'],
      }
    };
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    print('🔐 [MOCK] Login attempt: $email');
    print('🔐 [MOCK] Password: $password'); // Debug
    print('📋 [MOCK] Available users: ${_users.map((u) => '${u['email']} (${u['password']})').toList()}');
    await _simulateNetworkDelay();

    try {
      final user = _users.firstWhere(
            (u) => u['email'] == email.toLowerCase() && u['password'] == password,
      );

      print('✅ [MOCK] Login successful for: ${user['email']}');

      return {
        'token': 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
        'access': 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
        'user': {
          'id': user['id'],
          'name': user['name'],
          'email': user['email'],
          'phone': user['phone'],
        }
      };
    } catch (e) {
      print('❌ [MOCK] Login failed: Credenciais inválidas');
      throw Exception('Credenciais inválidas');
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    print('👤 [MOCK] Getting current user');
    await _simulateNetworkDelay();

    if (_users.isEmpty) {
      throw Exception('Nenhum usuário encontrado');
    }

    final user = _users.first;
    return {
      'id': user['id'],
      'name': user['name'],
      'email': user['email'],
      'phone': user['phone'],
    };
  }

  Future<void> logout() async {
    print('🚪 [MOCK] Logout');
    await _simulateNetworkDelay();
  }
}