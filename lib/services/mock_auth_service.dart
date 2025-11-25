import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'sms_service.dart';
import 'email_service.dart';
import 'mock_notification_service.dart';

class MockAuthService {
  static final List<Map<String, dynamic>> _users = [
    {
      'id': 1,
      'name': 'João Pedro Silva',
      'email': 'joao@sabore.com',
      'password': '123456',
      'phone': '+5563999887766',
      'username': 'joaopedro',
      'profileImage': null,
      'profileImageBytes': null,
      'coverImage': null,
      'coverImageBytes': null,
      'emailVerified': true,
      'phoneVerified': true,
      'recipesCount': 5,
      'followersCount': 8,
      'followingCount': 6,
    },
    {
      'id': 2,
      'name': 'Maria Santos',
      'email': 'maria@sabore.com',
      'password': '123456',
      'phone': '+5511988776655',
      'username': 'mariasantos',
      'profileImage': null,
      'profileImageBytes': null,
      'coverImage': null,
      'coverImageBytes': null,
      'emailVerified': true,
      'phoneVerified': false,
      'recipesCount': 3,
      'followersCount': 5,
      'followingCount': 4,
    },
    {
      'id': 3,
      'name': 'Carlos Eduardo',
      'email': 'carlos@sabore.com',
      'password': '123456',
      'phone': '+5521987654321',
      'username': 'carlosedu',
      'profileImage': null,
      'profileImageBytes': null,
      'coverImage': null,
      'coverImageBytes': null,
      'emailVerified': true,
      'phoneVerified': true,
      'recipesCount': 2,
      'followersCount': 4,
      'followingCount': 5,
    },
    {
      'id': 4,
      'name': 'Ana Beatriz Costa',
      'email': 'ana@sabore.com',
      'password': '123456',
      'phone': '+5548991234567',
      'username': 'chefana',
      'profileImage': 'assets/images/chef.jpg',
      'profileImageBytes': null,
      'coverImage': 'assets/images/chef.jpg',
      'coverImageBytes': null,
      'emailVerified': true,
      'phoneVerified': true,
      'recipesCount': 4,
      'followersCount': 12,
      'followingCount': 8,
    },
    {
      'id': 5,
      'name': 'Rafael Oliveira',
      'email': 'rafael@sabore.com',
      'password': '123456',
      'phone': '+5531987654321',
      'username': 'rafaoliveira',
      'profileImage': null,
      'profileImageBytes': null,
      'coverImage': null,
      'coverImageBytes': null,
      'emailVerified': true,
      'phoneVerified': true,
      'recipesCount': 2,
      'followersCount': 6,
      'followingCount': 3,
    },
    {
      'id': 6,
      'name': 'Juliana Ferreira',
      'email': 'juliana@sabore.com',
      'password': '123456',
      'phone': '+5541988776655',
      'username': 'jugourmet',
      'profileImage': null,
      'profileImageBytes': null,
      'coverImage': null,
      'coverImageBytes': null,
      'emailVerified': true,
      'phoneVerified': true,
      'recipesCount': 3,
      'followersCount': 9,
      'followingCount': 7,
    },
    {
      'id': 7,
      'name': 'Usuario Teste',
      'email': 'test@example.com',
      'password': 'password123',
      'phone': '+5511999999999',
      'username': 'testusuario',
      'profileImage': null,
      'profileImageBytes': null,
      'coverImage': null,
      'coverImageBytes': null,
      'emailVerified': true,
      'phoneVerified': true,
      'recipesCount': 1,
      'followersCount': 2,
      'followingCount': 9,
    },
    {
      'id': 8,
      'name': 'Admin Saborê',
      'email': 'admin@sabore.com',
      'password': 'admin123',
      'phone': '+5563999000000',
      'username': 'admin',
      'profileImage': null,
      'profileImageBytes': null,
      'coverImage': null,
      'coverImageBytes': null,
      'emailVerified': true,
      'phoneVerified': true,
      'recipesCount': 0,
      'followersCount': 15,
      'followingCount': 0,
    },
    {
      'id': 9,
      'name': 'Pedro Henrique',
      'email': 'pedro@sabore.com',
      'password': '123456',
      'phone': '+5562988887777',
      'username': 'pedrohenri',
      'profileImage': null,
      'profileImageBytes': null,
      'coverImage': null,
      'coverImageBytes': null,
      'emailVerified': true,
      'phoneVerified': false,
      'recipesCount': 2,
      'followersCount': 3,
      'followingCount': 6,
    },
    {
      'id': 10,
      'name': 'Fernanda Gomes',
      'email': 'fernanda@sabore.com',
      'password': '123456',
      'phone': '+5581987654321',
      'username': 'fezcozinha',
      'profileImage': null,
      'profileImageBytes': null,
      'coverImage': null,
      'coverImageBytes': null,
      'emailVerified': true,
      'phoneVerified': true,
      'recipesCount': 3,
      'followersCount': 7,
      'followingCount': 5,
    },
  ];

  // ✅ SERVIÇOS DE VERIFICAÇÃO
  final SmsService _smsService = SmsService();
  final EmailService _emailService = EmailService();

  final Map<String, String> _verificationCodes = {};
  final Map<String, DateTime> _codeExpiration = {};
  static int? _currentUserId;
  String? _currentVerificationId;

  // ✅ MAPA DE SEGUIDORES REALISTA E COERENTE
  static final Map<int, List<int>> _followingMap = {
    1: [4, 6, 10, 2, 3, 5],           // João segue 6 pessoas
    2: [1, 4, 6, 10],                 // Maria segue 4 pessoas
    3: [1, 4, 6, 2, 10],              // Carlos segue 5 pessoas
    4: [1, 2, 3, 5, 6, 9, 10, 7],     // Ana (popular) segue 8 pessoas
    5: [1, 4, 6],                     // Rafael segue 3 pessoas
    6: [1, 2, 4, 5, 10, 3, 7],        // Juliana segue 7 pessoas
    7: [1, 2, 3, 4, 5, 6, 9, 10, 8],  // Teste segue 9 pessoas
    8: [],                             // Admin não segue ninguém
    9: [1, 4, 6, 2, 10, 5],           // Pedro segue 6 pessoas
    10: [1, 4, 6, 2, 5],              // Fernanda segue 5 pessoas
  };

  String _generateCode() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }

  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(Duration(milliseconds: 600));
  }

  // ===================================================================
  // VERIFICAÇÃO DE EMAIL (USA EmailJS REAL)
  // ===================================================================

  /// Envia código de verificação por email (USA EmailJS REAL)
  Future<bool> sendEmailVerificationCode(String email) async {
    print('📧 Enviando email de verificação para: $email');

    try {
      // Busca o nome do usuário
      final user = _users.firstWhere(
            (u) => u['email'] == email,
        orElse: () => {'name': 'Usuário'},
      );

      // Envia email real usando EmailJS
      final code = await _emailService.sendVerificationEmail(
        email,
        user['name'] ?? 'Usuário',
      );

      // Armazena o código para verificação posterior
      _verificationCodes[email] = code;
      _codeExpiration[email] = DateTime.now().add(Duration(minutes: 10));

      print('✅ Email enviado com sucesso!');
      print('🔢 Código gerado: $code');

      return true;
    } catch (e) {
      print('❌ Erro ao enviar email: $e');
      throw Exception('Erro ao enviar email de verificação');
    }
  }

  /// Verifica código de email
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

    // Atualiza o usuário como verificado
    final userIndex = _users.indexWhere((user) => user['email'] == email);
    if (userIndex != -1) {
      _users[userIndex]['emailVerified'] = true;
    }

    // Limpa os códigos
    _verificationCodes.remove(email);
    _codeExpiration.remove(email);

    return true;
  }

  // ===================================================================
  // VERIFICAÇÃO DE SMS (USA FIREBASE REAL)
  // ===================================================================

  /// Envia código de verificação por SMS (USA FIREBASE REAL)
  Future<bool> sendPhoneVerificationCode(String phone) async {
    print('📱 Enviando SMS para: $phone');

    try {
      // Envia SMS real usando Firebase
      _currentVerificationId = await _smsService.sendVerificationSms(phone);

      // Armazena que enviou SMS para este número
      _verificationCodes[phone] = 'SMS_ENVIADO';
      _codeExpiration[phone] = DateTime.now().add(Duration(minutes: 3));

      print('✅ SMS enviado com sucesso!');
      print('📱 VerificationId: $_currentVerificationId');

      // Em desenvolvimento, mostra o código de teste
      final testCode = _smsService.getTestCode(phone);
      if (testCode != null) {
        print('🔢 Código de teste (DEV): $testCode');
      }

      return true;
    } catch (e) {
      print('❌ Erro ao enviar SMS: $e');
      throw Exception('Erro ao enviar SMS. Verifique o número e tente novamente.');
    }
  }

  /// Verifica código de SMS (USA FIREBASE REAL)
  Future<bool> verifyPhoneCode(String phone, String code) async {
    print('🔍 Verificando código SMS: $code');

    try {
      // Verifica usando o Firebase
      final isValid = await _smsService.verifyCode(code);

      if (isValid) {
        // Atualiza o usuário como verificado
        final userIndex = _users.indexWhere((u) => u['phone'] == phone);
        if (userIndex != -1) {
          _users[userIndex]['phoneVerified'] = true;
        }

        // Limpa os códigos
        _verificationCodes.remove(phone);
        _codeExpiration.remove(phone);

        print('✅ Telefone verificado com sucesso!');
        return true;
      } else {
        throw Exception('Código inválido');
      }

    } catch (e) {
      print('❌ Erro ao verificar código: $e');
      rethrow;
    }
  }

  // ===================================================================
  // AUTENTICAÇÃO
  // ===================================================================

  Future<bool> checkEmailAvailability(String email) async {
    await _simulateNetworkDelay();
    final exists = _users.any((user) => user['email'] == email.toLowerCase());
    return !exists;
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    await _simulateNetworkDelay();

    if (_users.any((user) => user['email'] == email.toLowerCase())) {
      throw Exception('Email já cadastrado');
    }

    final newUser = {
      'id': _users.length + 1,
      'name': name,
      'email': email.toLowerCase(),
      'password': password,
      'phone': phone,
      'username': null,
      'profileImage': null,
      'profileImageBytes': null,
      'coverImage': null,
      'coverImageBytes': null,
      'emailVerified': false,
      'phoneVerified': false,
      'recipesCount': 0,
      'followersCount': 0,
      'followingCount': 0,
    };

    _users.add(newUser);
    _currentUserId = newUser['id'] as int?;

    return {
      'token': 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
      'access': 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
      'user': _mapUserToResponse(newUser),
    };
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    await _simulateNetworkDelay();

    try {
      final user = _users.firstWhere(
            (u) => u['email'] == email.toLowerCase() && u['password'] == password,
      );

      _currentUserId = user['id'] as int?;

      return {
        'token': 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
        'access': 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
        'user': _mapUserToResponse(user),
      };
    } catch (e) {
      throw Exception('Credenciais inválidas');
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    await _simulateNetworkDelay();

    if (_currentUserId == null) {
      throw Exception('Nenhum usuário autenticado');
    }

    final user = _users.firstWhere(
          (u) => u['id'] == _currentUserId,
      orElse: () => throw Exception('Usuário não encontrado'),
    );

    return _mapUserToResponse(user);
  }

  // ===================================================================
  // RECUPERAÇÃO DE SENHA
  // ===================================================================

  Future<void> sendRecoveryCode(String destination, String method) async {
    await Future.delayed(Duration(seconds: 1));

    if (method == 'email') {
      // Email real com EmailJS
      try {
        final code = await _emailService.sendRecoveryEmail(destination);
        _verificationCodes[destination] = code;
        _codeExpiration[destination] = DateTime.now().add(Duration(minutes: 10));
        print('📧 Código de recuperação enviado por email: $code');
      } catch (e) {
        throw Exception('Erro ao enviar email de recuperação');
      }
    } else {
      // SMS real com Firebase
      try {
        await sendPhoneVerificationCode(destination);
        print('📱 Código de recuperação enviado por SMS');
      } catch (e) {
        throw Exception('Erro ao enviar SMS de recuperação');
      }
    }
  }

  Future<bool> verifyRecoveryCode(String destination, String code) async {
    await Future.delayed(Duration(milliseconds: 500));

    if (!_verificationCodes.containsKey(destination)) {
      throw Exception('Nenhum código foi enviado');
    }

    if (_codeExpiration[destination]!.isBefore(DateTime.now())) {
      throw Exception('Código expirado');
    }

    // Para SMS, usa verificação do Firebase
    if (destination.startsWith('+')) {
      try {
        return await verifyPhoneCode(destination, code);
      } catch (e) {
        throw Exception('Código inválido');
      }
    }

    // Para email, compara o código
    if (_verificationCodes[destination] != code) {
      throw Exception('Código inválido');
    }

    _verificationCodes.remove(destination);
    _codeExpiration.remove(destination);

    return true;
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    await Future.delayed(Duration(milliseconds: 500));

    final userIndex = _users.indexWhere(
          (u) => u['email'] == email.toLowerCase(),
    );

    if (userIndex != -1) {
      _users[userIndex]['password'] = newPassword;
      return true;
    }

    throw Exception('Usuário não encontrado');
  }

  // ===================================================================
  // PERFIL E USUÁRIOS
  // ===================================================================

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    await _simulateNetworkDelay();

    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    final results = _users.where((user) {
      final name = (user['name'] as String? ?? '').toLowerCase();
      final username = (user['username'] as String? ?? '').toLowerCase();
      return name.contains(lowerQuery) || username.contains(lowerQuery);
    }).toList();

    return results.map((user) => _mapUserToResponse(user)).toList();
  }

  Future<Map<String, dynamic>> getUserById(int userId) async {
    await _simulateNetworkDelay();

    try {
      final user = _users.firstWhere((u) => u['id'] == userId);
      return _mapUserToResponse(user);
    } catch (e) {
      throw Exception('Usuário com ID $userId não encontrado');
    }
  }

  Map<String, dynamic>? getUserByEmail(String email) {
    try {
      return _users.firstWhere((u) => u['email'] == email.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> _mapUserToResponse(Map<String, dynamic> user) {
    return {
      'id': user['id'],
      'name': user['name'],
      'email': user['email'],
      'phone': user['phone'],
      'username': user['username'],
      'profileImage': user['profileImage'],
      'profileImageBytes': user['profileImageBytes'],
      'coverImage': user['coverImage'],
      'coverImageBytes': user['coverImageBytes'],
      'emailVerified': user['emailVerified'],
      'phoneVerified': user['phoneVerified'],
      'recipesCount': user['recipesCount'] ?? 0,
      'followersCount': user['followersCount'] ?? 0,
      'followingCount': user['followingCount'] ?? 0,
    };
  }

  Future<void> updateProfile({
    String? name,
    String? username,
    String? profileImagePath,
    Uint8List? profileImageBytes,
    String? coverImagePath,
    Uint8List? coverImageBytes,
  }) async {
    await _simulateNetworkDelay();

    if (_currentUserId == null) {
      throw Exception('Nenhum usuário autenticado');
    }

    final userIndex = _users.indexWhere((u) => u['id'] == _currentUserId);
    if (userIndex == -1) {
      throw Exception('Usuário não encontrado');
    }

    if (name != null) _users[userIndex]['name'] = name;
    if (username != null) _users[userIndex]['username'] = username;

    if (profileImagePath != null) {
      _users[userIndex]['profileImage'] = profileImagePath;
      _users[userIndex]['profileImageBytes'] = null;
    }
    if (profileImageBytes != null) {
      _users[userIndex]['profileImageBytes'] = profileImageBytes;
      _users[userIndex]['profileImage'] = null;
    }

    if (coverImagePath != null) {
      _users[userIndex]['coverImage'] = coverImagePath;
      _users[userIndex]['coverImageBytes'] = null;
    }
    if (coverImageBytes != null) {
      _users[userIndex]['coverImageBytes'] = coverImageBytes;
      _users[userIndex]['coverImage'] = null;
    }
  }

  Future<void> logout() async {
    await _simulateNetworkDelay();
    _currentUserId = null;
    _smsService.clearState();
  }

  // ===================================================================
  // SEGUIDORES E SEGUINDO
  // ===================================================================

  Future<List<Map<String, dynamic>>> getFollowing(int userId) async {
    await _simulateNetworkDelay();

    final followingIds = _followingMap[userId] ?? [];
    if (followingIds.isEmpty) return [];

    final followingUsers = _users
        .where((user) => followingIds.contains(user['id']))
        .toList();

    return followingUsers.map((user) => _mapUserToResponse(user)).toList();
  }

  Future<List<Map<String, dynamic>>> getFollowers(int userId) async {
    await _simulateNetworkDelay();

    final List<int> followerIds = [];
    _followingMap.forEach((followerId, followingList) {
      if (followingList.contains(userId)) {
        followerIds.add(followerId);
      }
    });

    if (followerIds.isEmpty) return [];

    final followerUsers = _users
        .where((user) => followerIds.contains(user['id']))
        .toList();

    return followerUsers.map((user) => _mapUserToResponse(user)).toList();
  }

  Future<bool> toggleFollow(int userIdToFollow) async {
    await _simulateNetworkDelay();

    if (_currentUserId == null) {
      throw Exception('Usuário não está logado');
    }

    if (!_followingMap.containsKey(_currentUserId)) {
      _followingMap[_currentUserId!] = [];
    }

    final currentUserFollowing = _followingMap[_currentUserId]!;
    final isNowFollowing = !currentUserFollowing.contains(userIdToFollow);

    if (currentUserFollowing.contains(userIdToFollow)) {
      // DEIXAR DE SEGUIR
      currentUserFollowing.remove(userIdToFollow);
      print('❌ [MOCK] Usuário $_currentUserId deixou de seguir $userIdToFollow');
    } else {
      // COMEÇAR A SEGUIR
      currentUserFollowing.add(userIdToFollow);
      print('✅ [MOCK] Usuário $_currentUserId começou a seguir $userIdToFollow');

      // ✅ CRIAR NOTIFICAÇÃO DE FOLLOW
      try {
        final currentUser = _users.firstWhere((u) => u['id'] == _currentUserId);
        final notificationService = MockNotificationService();

        notificationService.createFollowNotification(
          targetUserId: userIdToFollow,
          fromUserId: _currentUserId!,
          fromUserName: currentUser['name'],
          fromUserImage: currentUser['profileImage'],
        );

        print('🔔 Notificação de follow enviada para usuário $userIdToFollow');
      } catch (e) {
        print('❌ Erro ao criar notificação: $e');
      }
    }

    await _updateFollowCounts(_currentUserId!, userIdToFollow);

    return isNowFollowing;
  }

  Future<void> _updateFollowCounts(int currentUserId, int targetUserId) async {
    final currentUserIndex = _users.indexWhere((u) => u['id'] == currentUserId);
    _users[currentUserIndex]['followingCount'] =
        (_followingMap[currentUserId] ?? []).length;

    final targetUserIndex = _users.indexWhere((u) => u['id'] == targetUserId);
    final followers = await getFollowers(targetUserId);
    _users[targetUserIndex]['followersCount'] = followers.length;
  }
}