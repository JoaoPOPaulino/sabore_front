import 'dart:async';
import 'dart:math';

class MockAuthService {
  // Lista de usuários mockados com diversos perfis de teste
  static final List<Map<String, dynamic>> _users = [
    // ✅ Usuário completo - já configurou tudo
    {
      'id': '1',
      'name': 'João Pedro Silva',
      'email': 'joao@sabore.com',
      'password': '123456',
      'phone': '+5563999887766',
      'username': 'joaopedro',
      'profileImage': null,
      'emailVerified': true,
      'phoneVerified': true,
    },

    // ✅ Usuário sem username (primeiro login)
    {
      'id': '2',
      'name': 'Maria Santos',
      'email': 'maria@sabore.com',
      'password': '123456',
      'phone': '+5511988776655',
      'username': null,
      'profileImage': null,
      'emailVerified': false,
      'phoneVerified': false,
    },

    // ✅ Usuário com email verificado mas sem telefone
    {
      'id': '3',
      'name': 'Carlos Eduardo',
      'email': 'carlos@sabore.com',
      'password': '123456',
      'phone': '+5521987654321',
      'username': 'carlosedu',
      'profileImage': null,
      'emailVerified': true,
      'phoneVerified': false,
    },

    // ✅ Chef profissional
    {
      'id': '4',
      'name': 'Ana Beatriz Costa',
      'email': 'ana@sabore.com',
      'password': '123456',
      'phone': '+5548991234567',
      'username': 'chefana',
      'profileImage': null,
      'emailVerified': true,
      'phoneVerified': true,
    },

    // ✅ Usuário simples
    {
      'id': '5',
      'name': 'Rafael Oliveira',
      'email': 'rafael@sabore.com',
      'password': '123456',
      'phone': '+5531987654321',
      'username': 'rafaoliveira',
      'profileImage': null,
      'emailVerified': true,
      'phoneVerified': false,
    },

    // ✅ Usuário gourmet
    {
      'id': '6',
      'name': 'Juliana Ferreira',
      'email': 'juliana@sabore.com',
      'password': '123456',
      'phone': '+5541988776655',
      'username': 'jugourmet',
      'profileImage': null,
      'emailVerified': true,
      'phoneVerified': true,
    },

    // ✅ Usuário teste original
    {
      'id': '7',
      'name': 'Usuario Teste',
      'email': 'test@example.com',
      'password': 'password123',
      'phone': '+5511999999999',
      'username': 'testusuario',
      'profileImage': null,
      'emailVerified': true,
      'phoneVerified': true,
    },

    // ✅ Admin
    {
      'id': '8',
      'name': 'Admin Saborê',
      'email': 'admin@sabore.com',
      'password': 'admin123',
      'phone': '+5563999000000',
      'username': 'admin',
      'profileImage': null,
      'emailVerified': true,
      'phoneVerified': true,
    },

    // ✅ Usuário novo (sem nada configurado)
    {
      'id': '9',
      'name': 'Pedro Henrique',
      'email': 'pedro@sabore.com',
      'password': '123456',
      'phone': '+5562988887777',
      'username': null,
      'profileImage': null,
      'emailVerified': false,
      'phoneVerified': false,
    },

    // ✅ Influencer culinário
    {
      'id': '10',
      'name': 'Fernanda Gomes',
      'email': 'fernanda@sabore.com',
      'password': '123456',
      'phone': '+5581987654321',
      'username': 'fezcozinha',
      'profileImage': null,
      'emailVerified': true,
      'phoneVerified': true,
    },
  ];

  // Códigos de verificação temporários
  final Map<String, String> _verificationCodes = {};
  final Map<String, DateTime> _codeExpiration = {};

  // ID do usuário autenticado atualmente
  static String? _currentUserId;

  // Gerar código de 4 dígitos
  String _generateCode() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }

  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(Duration(milliseconds: 800));
  }

  // ========== VERIFICAÇÃO DE E-MAIL ==========

  Future<bool> sendEmailVerificationCode(String email) async {
    await Future.delayed(Duration(seconds: 1));

    final code = _generateCode();
    _verificationCodes[email] = code;
    _codeExpiration[email] = DateTime.now().add(Duration(minutes: 10));

    print('📧 Código de verificação enviado para $email: $code');
    return true;
  }

  Future<bool> verifyEmailCode(String email, String code) async {
    await Future.delayed(Duration(milliseconds: 500));

    if (!_verificationCodes.containsKey(email)) {
      throw Exception('Nenhum código foi enviado para este e-mail');
    }

    if (_codeExpiration[email]!.isBefore(DateTime.now())) {
      throw Exception('Código expirado. Solicite um novo código');
    }

    if (_verificationCodes[email] != code) {
      throw Exception('Código inválido');
    }

    // Marca o e-mail como verificado
    final userIndex = _users.indexWhere((user) => user['email'] == email);

    if (userIndex != -1) {
      _users[userIndex]['emailVerified'] = true;
      print('✅ E-mail $email verificado com sucesso');
    }

    // Limpa o código usado
    _verificationCodes.remove(email);
    _codeExpiration.remove(email);

    return true;
  }

  // ========== VERIFICAÇÃO DE TELEFONE ==========

  Future<bool> sendPhoneVerificationCode(String phone) async {
    await Future.delayed(Duration(seconds: 1));

    final code = _generateCode();
    _verificationCodes[phone] = code;
    _codeExpiration[phone] = DateTime.now().add(Duration(minutes: 3));

    print('📱 Código de verificação enviado para $phone: $code');
    return true;
  }

  Future<bool> verifyPhoneCode(String phone, String code) async {
    await Future.delayed(Duration(milliseconds: 500));

    if (!_verificationCodes.containsKey(phone)) {
      throw Exception('Nenhum código foi enviado para este telefone');
    }

    if (_codeExpiration[phone]!.isBefore(DateTime.now())) {
      throw Exception('Código expirado. Solicite um novo código');
    }

    if (_verificationCodes[phone] != code) {
      throw Exception('Código inválido');
    }

    // Marca o telefone como verificado
    final userIndex = _users.indexWhere((user) => user['phone'] == phone);

    if (userIndex != -1) {
      _users[userIndex]['phoneVerified'] = true;
      print('✅ Telefone $phone verificado com sucesso');
    }

    // Limpa o código usado
    _verificationCodes.remove(phone);
    _codeExpiration.remove(phone);

    return true;
  }

  // ========== AUTENTICAÇÃO ==========

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
      'emailVerified': false,
      'phoneVerified': false,
    };

    _users.add(newUser);
    _currentUserId = newUser['id'] as String?;

    print('✅ [MOCK] User registered successfully with ID: ${newUser['id']}');

    return {
      'token': 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
      'access': 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
      'user': {
        'id': newUser['id'],
        'name': newUser['name'],
        'email': newUser['email'],
        'phone': newUser['phone'],
        'username': newUser['username'],
        'profileImage': newUser['profileImage'],
        'emailVerified': newUser['emailVerified'],
        'phoneVerified': newUser['phoneVerified'],
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

      _currentUserId = user['id'] as String?;
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
          'emailVerified': user['emailVerified'],
          'phoneVerified': user['phoneVerified'],
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
      'emailVerified': user['emailVerified'],
      'phoneVerified': user['phoneVerified'],
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

  // ========== UTILITÁRIOS ==========

  // Verifica se o usuário atual tem e-mail verificado
  bool isEmailVerified() {
    if (_currentUserId == null) return false;

    final user = _users.firstWhere(
          (u) => u['id'] == _currentUserId,
      orElse: () => {},
    );

    return user['emailVerified'] == true;
  }

  // Verifica se o usuário atual tem telefone verificado
  bool isPhoneVerified() {
    if (_currentUserId == null) return false;

    final user = _users.firstWhere(
          (u) => u['id'] == _currentUserId,
      orElse: () => {},
    );

    return user['phoneVerified'] == true;
  }

  // ========== PARA DEBUGGING ==========

  // Lista todos os usuários (apenas para debug)
  void printAllUsers() {
    print('\n📋 ========== USUÁRIOS CADASTRADOS ==========');
    for (var user in _users) {
      print('ID: ${user['id']}');
      print('Nome: ${user['name']}');
      print('Email: ${user['email']}');
      print('Senha: ${user['password']}');
      print('Username: ${user['username'] ?? 'não configurado'}');
      print('Email Verificado: ${user['emailVerified']}');
      print('Telefone Verificado: ${user['phoneVerified']}');
      print('---');
    }
    print('============================================\n');
  }
  
  Map<String, dynamic>? getUserByEmail(String email){
    try {
      return _users.firstWhere(
          (u) => u['email'] == email.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
  
  Future<bool> resetPassword (String email, String newPassword) async {
    await Future.delayed(Duration(milliseconds: 500));
    
    final userIndex = _users.indexWhere(
        (u) => u['email'] == email.toLowerCase(),
    );
    
    if (userIndex != -1) {
      _users[userIndex]['password'] = newPassword;
      print('✅ Senha atualizada para $email');
      return true;
    }

    throw Exception('Usuário não encontrado');
  }

  Future<bool> verifyRecoveryCode(String destination, String code) async {
    await Future.delayed(Duration(milliseconds: 500));

    if (!_verificationCodes.containsKey(destination)) {
      throw Exception('Nenhum código foi enviado');
    }

    if (_codeExpiration[destination]!.isBefore(DateTime.now())) {
      throw Exception('Código expirado');
    }

    if (_verificationCodes[destination] != code) {
      throw Exception('Código inválido');
    }

    _verificationCodes.remove(destination);
    _codeExpiration.remove(destination);

    return true;
  }

  Future<void> sendRecoveryCode(String destination, String method) async {
    await Future.delayed(Duration(seconds: 1));

    final code = _generateCode();
    _verificationCodes[destination] = code;
    _codeExpiration[destination] = DateTime.now().add(
      method == 'email' ? Duration(minutes: 10) : Duration(minutes: 3),
    );

    print('📨 Código de recuperação enviado para $destination: $code');
  }
}
