import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

class MockAuthService {
  static final List<Map<String, dynamic>> _users = [
    {
      'id': 1, // ✨ CORREÇÃO: ID como int
      'name': 'João Pedro Silva',
      'email': 'joao@sabore.com',
      'password': '123456',
      'phone': '+5563999887766',
      'username': 'joaopedro',
      'profileImage': null, 'profileImageBytes': null, 'coverImage': null, 'coverImageBytes': null,
      'emailVerified': true, 'phoneVerified': true,
      'recipesCount': 9, 'followersCount': 120, 'followingCount': 75,
    },
    {
      'id': 2, // ✨ CORREÇÃO: ID como int
      'name': 'Maria Santos',
      'email': 'maria@sabore.com',
      'password': '123456',
      'phone': '+5511988776655',
      'username': 'mariasantos',
      'profileImage': null, 'profileImageBytes': null, 'coverImage': null, 'coverImageBytes': null,
      'emailVerified': false, 'phoneVerified': false,
      'recipesCount': 3, 'followersCount': 45, 'followingCount': 30,
    },
    {
      'id': 3, // ✨ CORREÇÃO: ID como int
      'name': 'Carlos Eduardo',
      'email': 'carlos@sabore.com',
      'password': '123456',
      'phone': '+5521987654321',
      'username': 'carlosedu',
      'profileImage': null, 'profileImageBytes': null, 'coverImage': null, 'coverImageBytes': null,
      'emailVerified': true, 'phoneVerified': false,
      'recipesCount': 0, 'followersCount': 12, 'followingCount': 15,
    },
    {
      'id': 4, // ✨ CORREÇÃO: ID como int
      'name': 'Ana Beatriz Costa',
      'email': 'ana@sabore.com',
      'password': '123456',
      'phone': '+5548991234567',
      'username': 'chefana',
      'profileImage': 'assets/images/chef.jpg', 'profileImageBytes': null, 'coverImage': 'assets/images/chef.jpg', 'coverImageBytes': null,
      'emailVerified': true, 'phoneVerified': true,
      'recipesCount': 28, 'followersCount': 1500, 'followingCount': 130,
    },
    {
      'id': 5, // ✨ CORREÇÃO: ID como int
      'name': 'Rafael Oliveira',
      'email': 'rafael@sabore.com',
      'password': '123456',
      'phone': '+5531987654321',
      'username': 'rafaoliveira',
      'profileImage': null, 'profileImageBytes': null, 'coverImage': null, 'coverImageBytes': null,
      'emailVerified': true, 'phoneVerified': false,
      'recipesCount': 7, 'followersCount': 88, 'followingCount': 112,
    },
    {
      'id': 6, // ✨ CORREÇÃO: ID como int
      'name': 'Juliana Ferreira',
      'email': 'juliana@sabore.com',
      'password': '123456',
      'phone': '+5541988776655',
      'username': 'jugourmet',
      'profileImage': null, 'profileImageBytes': null, 'coverImage': null, 'coverImageBytes': null,
      'emailVerified': true, 'phoneVerified': true,
      'recipesCount': 14, 'followersCount': 305, 'followingCount': 200,
    },
    {
      'id': 7, // ✨ CORREÇÃO: ID como int
      'name': 'Usuario Teste',
      'email': 'test@example.com',
      'password': 'password123',
      'phone': '+5511999999999',
      'username': 'testusuario',
      'profileImage': null, 'profileImageBytes': null, 'coverImage': null, 'coverImageBytes': null,
      'emailVerified': true, 'phoneVerified': true,
      'recipesCount': 2, 'followersCount': 5, 'followingCount': 10,
    },
    {
      'id': 8, // ✨ CORREÇÃO: ID como int
      'name': 'Admin Saborê',
      'email': 'admin@sabore.com',
      'password': 'admin123',
      'phone': '+5563999000000',
      'username': 'admin',
      'profileImage': null, 'profileImageBytes': null, 'coverImage': null, 'coverImageBytes': null,
      'emailVerified': true, 'phoneVerified': true,
      'recipesCount': 0, 'followersCount': 0, 'followingCount': 0,
    },
    {
      'id': 9, // ✨ CORREÇÃO: ID como int
      'name': 'Pedro Henrique',
      'email': 'pedro@sabore.com',
      'password': '123456',
      'phone': '+5562988887777',
      'username': 'pedrohenri',
      'profileImage': null, 'profileImageBytes': null, 'coverImage': null, 'coverImageBytes': null,
      'emailVerified': false, 'phoneVerified': false,
      'recipesCount': 1, 'followersCount': 10, 'followingCount': 2,
    },
    {
      'id': 10, // ✨ CORREÇÃO: ID como int
      'name': 'Fernanda Gomes',
      'email': 'fernanda@sabore.com',
      'password': '123456',
      'phone': '+5581987654321',
      'username': 'fezcozinha',
      'profileImage': null, 'profileImageBytes': null, 'coverImage': null, 'coverImageBytes': null,
      'emailVerified': true, 'phoneVerified': true,
      'recipesCount': 42, 'followersCount': 5000, 'followingCount': 50,
    },
  ];

  final Map<String, String> _verificationCodes = {};
  final Map<String, DateTime> _codeExpiration = {};
  static int? _currentUserId; // ✨ CORREÇÃO: ID como int

  // Mapa de Seguidores: A Chave (int) é o ID do usuário, a Lista (int) é quem ELE SEGUE
  static final Map<int, List<int>> _followingMap = {
    1: [4, 6, 10, 20],
    2: [4, 1],
    4: [1, 2, 6, 10, 20],
    6: [4, 10, 20],
    10: [4, 6, 20],
    20: [4, 10],
    7: [1, 4, 6, 10, 20],
  };

  String _generateCode() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }

  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(Duration(milliseconds: 600));
  }

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
    if (!_verificationCodes.containsKey(email)) throw Exception('Nenhum código foi enviado para este e-mail');
    if (_codeExpiration[email]!.isBefore(DateTime.now())) throw Exception('Código expirado. Solicite um novo código');
    if (_verificationCodes[email] != code) throw Exception('Código inválido');
    final userIndex = _users.indexWhere((user) => user['email'] == email);
    if (userIndex != -1) _users[userIndex]['emailVerified'] = true;
    _verificationCodes.remove(email);
    _codeExpiration.remove(email);
    return true;
  }

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
    if (!_verificationCodes.containsKey(phone)) throw Exception('Nenhum código foi enviado para este telefone');
    if (_codeExpiration[phone]!.isBefore(DateTime.now())) throw Exception('Código expirado. Solicite um novo código');
    if (_verificationCodes[phone] != code) throw Exception('Código inválido');
    final userIndex = _users.indexWhere((user) => user['phone'] == phone);
    if (userIndex != -1) _users[userIndex]['phoneVerified'] = true;
    _verificationCodes.remove(phone);
    _codeExpiration.remove(phone);
    return true;
  }

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
      'id': _users.length + 1, // ✨ CORREÇÃO: ID como int
      'name': name,
      'email': email.toLowerCase(),
      'password': password,
      'phone': phone,
      'username': null,
      'profileImage': null, 'profileImageBytes': null, 'coverImage': null, 'coverImageBytes': null,
      'emailVerified': false, 'phoneVerified': false,
      'recipesCount': 0, 'followersCount': 0, 'followingCount': 0,
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
    if (_currentUserId == null) throw Exception('Nenhum usuário autenticado');
    final user = _users.firstWhere(
          (u) => u['id'] == _currentUserId,
      orElse: () => throw Exception('Usuário não encontrado'),
    );
    return _mapUserToResponse(user);
  }

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

  Future<Map<String, dynamic>> getUserById(int userId) async { // ✨ CORREÇÃO: ID como int
    await _simulateNetworkDelay();
    try {
      final user = _users.firstWhere((u) => u['id'] == userId);
      return _mapUserToResponse(user);
    } catch (e) {
      throw Exception('Usuário com ID $userId não encontrado');
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
    if (_currentUserId == null) throw Exception('Nenhum usuário autenticado');
    final userIndex = _users.indexWhere((u) => u['id'] == _currentUserId);
    if (userIndex == -1) throw Exception('Usuário não encontrado');
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
  }

  Map<String, dynamic>? getUserByEmail(String email){
    try {
      return _users.firstWhere((u) => u['email'] == email.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  Future<bool> resetPassword (String email, String newPassword) async {
    await Future.delayed(Duration(milliseconds: 500));
    final userIndex = _users.indexWhere((u) => u['email'] == email.toLowerCase());
    if (userIndex != -1) {
      _users[userIndex]['password'] = newPassword;
      return true;
    }
    throw Exception('Usuário não encontrado');
  }

  Future<bool> verifyRecoveryCode(String destination, String code) async {
    await Future.delayed(Duration(milliseconds: 500));
    if (!_verificationCodes.containsKey(destination)) throw Exception('Nenhum código foi enviado');
    if (_codeExpiration[destination]!.isBefore(DateTime.now())) throw Exception('Código expirado');
    if (_verificationCodes[destination] != code) throw Exception('Código inválido');
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

  // == NOVAS FUNÇÕES DE SEGUIR ==

  Future<List<Map<String, dynamic>>> getFollowing(int userId) async {
    await _simulateNetworkDelay();
    final followingIds = _followingMap[userId] ?? [];
    if (followingIds.isEmpty) return [];
    final followingUsers = _users.where((user) => followingIds.contains(user['id'])).toList();
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
    final followerUsers = _users.where((user) => followerIds.contains(user['id'])).toList();
    return followerUsers.map((user) => _mapUserToResponse(user)).toList();
  }

  Future<bool> toggleFollow(int userIdToFollow) async {
    await _simulateNetworkDelay();
    if (_currentUserId == null) throw Exception('Usuário não está logado');

    final currentUserFollowing = _followingMap[_currentUserId] ?? [];

    if (currentUserFollowing.contains(userIdToFollow)) {
      currentUserFollowing.remove(userIdToFollow);
      print('❌ [MOCK] Usuário $_currentUserId deixou de seguir $userIdToFollow');
    } else {
      currentUserFollowing.add(userIdToFollow);
      print('✅ [MOCK] Usuário $_currentUserId começou a seguir $userIdToFollow');
    }

    _followingMap[_currentUserId!] = currentUserFollowing;

    // Atualiza contagens (simulação)
    await _updateFollowCounts(_currentUserId!, userIdToFollow);

    return currentUserFollowing.contains(userIdToFollow);
  }

  Future<void> _updateFollowCounts(int currentUserId, int targetUserId) async {
    final currentUserIndex = _users.indexWhere((u) => u['id'] == currentUserId);
    _users[currentUserIndex]['followingCount'] = (_followingMap[currentUserId] ?? []).length;

    final targetUserIndex = _users.indexWhere((u) => u['id'] == targetUserId);
    final followers = await getFollowers(targetUserId);
    _users[targetUserIndex]['followersCount'] = followers.length;
  }
}