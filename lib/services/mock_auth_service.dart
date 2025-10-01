import 'dart:async';
import 'dart:io';

class MockAuthService {
  // Banco de dados fake em memória
  static final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'name': 'Usuario Teste',
      'email': 'test@example.com',
      'password': 'password123',
      'phone': '+5511999999999',
      'username': null,
      'profileImage': null,
    }
  ];

  // ID do usuário autenticado atualmente
  static String? _currentUserId;

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
    await _simulateNetworkDelay();

    if (_users.any((user) => user['email'] == email.toLowerCase())) {
      print('❌ [MOCK] Email already exists');
      throw Exception('Email já cadastrado');
    }

    final newUser = {
      'id': '${_users.length + 1}',
      'name': name,
      'email': email.toLowerCase(),
      'password': password,
      'phone': phone,
      'username': null,
      'profileImage': null,
    };

    _users.add(newUser);
    _currentUserId = newUser['id'];

    print('✅ [MOCK] User registered successfully with ID: ${newUser['id']}');

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
    await _simulateNetworkDelay();

    try {
      final user = _users.firstWhere(
            (u) => u['email'] == email.toLowerCase() && u['password'] == password,
      );

      _currentUserId = user['id'];
      print('✅ [MOCK] Login successful for: ${user['email']} (ID: ${user['id']})');

      return {
        'token': 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
        'access': 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
        'user': {
          'id': user['id'],
          'name': user['name'],
          'email': user['email'],
          'phone': user['phone'],
          'username': user['username'],
          'profileImage': user['profileImage'],
        }
      };
    } catch (e) {
      print('❌ [MOCK] Login failed: Credenciais inválidas');
      throw Exception('Credenciais inválidas');
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    print('👤 [MOCK] Getting current user (ID: $_currentUserId)');
    await _simulateNetworkDelay();

    if (_currentUserId == null) {
      throw Exception('Nenhum usuário autenticado');
    }

    final user = _users.firstWhere(
          (u) => u['id'] == _currentUserId,
      orElse: () => throw Exception('Usuário não encontrado'),
    );

    return {
      'id': user['id'],
      'name': user['name'],
      'email': user['email'],
      'phone': user['phone'],
      'username': user['username'],
      'profileImage': user['profileImage'],
    };
  }

  Future<void> updateProfile({
    String? username,
    String? profileImagePath,
  }) async {
    print('📝 [MOCK] Updating profile for user ID: $_currentUserId');
    await _simulateNetworkDelay();

    if (_currentUserId == null) {
      throw Exception('Nenhum usuário autenticado');
    }

    final userIndex = _users.indexWhere((u) => u['id'] == _currentUserId);
    if (userIndex == -1) {
      throw Exception('Usuário não encontrado');
    }

    if (username != null) {
      _users[userIndex]['username'] = username;
      print('✅ [MOCK] Username updated to: $username');
    }

    if (profileImagePath != null) {
      _users[userIndex]['profileImage'] = profileImagePath;
      print('✅ [MOCK] Profile image updated');
    }
  }

  Future<void> logout() async {
    print('🚪 [MOCK] Logout (User ID: $_currentUserId)');
    await _simulateNetworkDelay();
    _currentUserId = null;
  }
}