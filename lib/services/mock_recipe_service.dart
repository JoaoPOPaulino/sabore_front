import 'dart:async';
import 'dart:typed_data';
import '../models/models.dart';
import 'mock_notification_service.dart';
import 'mock_auth_service.dart';

class MockRecipeService {
  static final List<Map<String, dynamic>> _recipes = [
    {
      'id': 1,
      'userId': 1,
      'state': 'Tocantins',
      'title': 'Bolo de milho sem açúcar',
      'description': 'Delicioso bolo de milho perfeito para festas juninas, sem adição de açúcar refinado.',
      'ingredients': [
        {'name': 'Milho verde', 'quantity': '2', 'unit': 'latas'},
        {'name': 'Ovos', 'quantity': '3', 'unit': 'unidades'},
        {'name': 'Óleo', 'quantity': '1/2', 'unit': 'xícara'},
        {'name': 'Leite de coco', 'quantity': '1', 'unit': 'lata'},
        {'name': 'Farinha de milho', 'quantity': '1', 'unit': 'xícara'},
        {'name': 'Fermento', 'quantity': '1', 'unit': 'colher de sopa'},
        {'name': 'Mel', 'quantity': '1/2', 'unit': 'xícara'},
        {'name': 'Canela', 'quantity': '1', 'unit': 'colher de chá'},
      ],
      'preparationSteps': [
        'Bata no liquidificador o milho, os ovos, o óleo e o leite de coco',
        'Adicione o mel e misture bem',
        'Em uma tigela, misture a farinha de milho, o fermento e a canela',
        'Junte a mistura líquida aos ingredientes secos',
        'Despeje em uma forma untada',
        'Asse em forno preaquecido a 180°C por 40 minutos',
      ],
      'preparationTime': 80,
      'servings': 12,
      'difficulty': 'Médio',
      'category': 'Doces',
      'tags': ['Junina', 'Sem açúcar', 'Milho'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(days: 3)),
      'likesCount': 45,
      'commentsCount': 12,
      'savesCount': 28,
      'averageRating': 4.8,
    },
    {
      'id': 2,
      'userId': 1,
      'state': 'Tocantins',
      'title': 'Canjica zero lactose',
      'description': 'Canjica cremosa e deliciosa, perfeita para quem tem intolerância à lactose.',
      'ingredients': [
        {'name': 'Milho para canjica', 'quantity': '500', 'unit': 'g'},
        {'name': 'Leite de coco', 'quantity': '2', 'unit': 'latas'},
        {'name': 'Açúcar mascavo', 'quantity': '1', 'unit': 'xícara'},
        {'name': 'Canela em pau', 'quantity': '2', 'unit': 'unidades'},
        {'name': 'Cravo', 'quantity': '4', 'unit': 'unidades'},
        {'name': 'Amendoim torrado', 'quantity': '100', 'unit': 'g'},
        {'name': 'Coco ralado', 'quantity': '100', 'unit': 'g'},
      ],
      'preparationSteps': [
        'Deixe o milho de molho por 12 horas',
        'Cozinhe o milho em panela de pressão por 40 minutos',
        'Adicione o leite de coco',
        'Acrescente o açúcar, a canela e o cravo',
        'Cozinhe por mais 30 minutos em fogo baixo',
        'Finalize com amendoim e coco ralado',
      ],
      'preparationTime': 120,
      'servings': 10,
      'difficulty': 'Médio',
      'category': 'Doces',
      'tags': ['Junina', 'Zero lactose', 'Tradicional'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(hours: 5)),
      'likesCount': 67,
      'commentsCount': 18,
      'savesCount': 42,
      'averageRating': 4.9,
    },
    {
      'id': 3,
      'userId': 1,
      'state': 'Goiás',
      'title': 'Paçoca Cremosa',
      'description': 'Paçoca caseira cremosa, perfeita para festas juninas.',
      'ingredients': [
        {'name': 'Amendoim torrado', 'quantity': '500', 'unit': 'g'},
        {'name': 'Açúcar', 'quantity': '300', 'unit': 'g'},
        {'name': 'Farinha de mandioca', 'quantity': '200', 'unit': 'g'},
        {'name': 'Sal', 'quantity': '1', 'unit': 'pitada'},
      ],
      'preparationSteps': [
        'Triture o amendoim no processador',
        'Adicione o açúcar e o sal',
        'Acrescente a farinha aos poucos',
        'Misture até formar uma farofa úmida',
        'Modele em forminhas',
      ],
      'preparationTime': 25,
      'servings': 30,
      'difficulty': 'Fácil',
      'category': 'Doces',
      'tags': ['Junina', 'Amendoim', 'Tradicional'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(days: 5)),
      'likesCount': 61,
      'commentsCount': 14,
      'savesCount': 35,
      'averageRating': 4.7,
    },
    {
      'id': 4,
      'userId': 1,
      'state': 'São Paulo',
      'title': 'Arroz Doce Especial',
      'description': 'Arroz doce cremoso com toque de limão e canela.',
      'ingredients': [
        {'name': 'Arroz', 'quantity': '1', 'unit': 'xícara'},
        {'name': 'Leite', 'quantity': '1', 'unit': 'litro'},
        {'name': 'Açúcar', 'quantity': '1', 'unit': 'xícara'},
        {'name': 'Casca de limão', 'quantity': '1', 'unit': 'unidade'},
        {'name': 'Canela em pó', 'quantity': '1', 'unit': 'colher'},
      ],
      'preparationSteps': [
        'Cozinhe o arroz em água até ficar macio',
        'Adicione o leite e a casca de limão',
        'Cozinhe em fogo baixo mexendo sempre',
        'Adicione o açúcar',
        'Cozinhe até engrossar',
        'Polvilhe canela e sirva gelado',
      ],
      'preparationTime': 60,
      'servings': 8,
      'difficulty': 'Fácil',
      'category': 'Doces',
      'tags': ['Sobremesa', 'Tradicional', 'Comfort food'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(days: 8)),
      'likesCount': 38,
      'commentsCount': 9,
      'savesCount': 22,
      'averageRating': 4.6,
    },
    {
      'id': 5,
      'userId': 1,
      'state': 'Bahia',
      'title': 'Cocada de Forno',
      'description': 'Cocada assada crocante por fora e macia por dentro.',
      'ingredients': [
        {'name': 'Coco ralado', 'quantity': '500', 'unit': 'g'},
        {'name': 'Açúcar', 'quantity': '2', 'unit': 'xícaras'},
        {'name': 'Ovos', 'quantity': '4', 'unit': 'unidades'},
        {'name': 'Manteiga', 'quantity': '2', 'unit': 'colheres'},
      ],
      'preparationSteps': [
        'Misture todos os ingredientes',
        'Coloque em forminhas de empada',
        'Asse a 180°C por 25 minutos',
        'Deixe dourar bem',
        'Espere esfriar antes de desenformar',
      ],
      'preparationTime': 40,
      'servings': 24,
      'difficulty': 'Fácil',
      'category': 'Doces',
      'tags': ['Coco', 'Festa', 'Junina'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(days: 12)),
      'likesCount': 52,
      'commentsCount': 11,
      'savesCount': 31,
      'averageRating': 4.7,
    },
  ];

  // ✅ LIKES REALISTAS
  static final Map<int, List<int>> _likes = {
    1: [11, 12, 17, 15, 6, 9, 22],
    2: [1, 2, 11, 12, 15, 17],
    3: [1, 11, 15, 6, 17, 22],
    4: [1, 2, 6, 7, 9, 15, 17, 20, 22],
    5: [11, 12, 15, 17],
    6: [1, 2, 11, 12, 15, 9, 22],
    7: [1, 2, 11, 12, 15, 17, 6, 9, 22],
    9: [1, 11, 15, 17, 6, 22],
    10: [1, 2, 11, 15, 17, 6],
  };

  // ✅ SALVOS POR LIVRO
  static final Map<int, Map<String, List<int>>> _savedRecipesByBook = {
    1: {
      'Favoritas': [11, 12, 17],
      'Festa Junina': [1, 2, 3],
      'Para Fazer': [6, 15],
    },
    2: {
      'Favoritas': [1, 11, 15],
      'Doces': [11, 22],
    },
    3: {
      'Favoritas': [15, 6],
      'Churrasco': [9, 10],
    },
    4: {
      'Favoritas': [1, 2, 6, 15],
      'Brasileiras': [1, 2, 12, 20],
      'Festa': [11, 22],
    },
    5: {
      'Favoritas': [11, 17],
    },
    6: {
      'Favoritas': [1, 2, 11],
      'Doces': [11, 22, 13],
      'Salgados': [6, 15, 17],
    },
    7: {
      'Favoritas': [1, 11, 15],
    },
    9: {
      'Favoritas': [1, 11, 17],
      'Rápidas': [20, 25],
    },
    10: {
      'Favoritas': [1, 11, 15, 6],
      'Doces': [11, 22],
    },
  };

  // ✅ NOVO: Armazenar bytes das imagens para WEB
  static final Map<int, Uint8List> _recipeImageBytes = {};

  Future<void> _simulateDelay() async {
    await Future.delayed(Duration(milliseconds: 400));
  }

  // ============================================================================
  // MÉTODOS DE BUSCA DE RECEITAS
  // ============================================================================

  Future<List<Recipe>> getAllRecipes() async {
    await _simulateDelay();
    return _recipes.map((r) => _mapToRecipe(r)).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<List<Recipe>> getUserRecipes(int userId) async {
    await _simulateDelay();
    final userRecipes = _recipes.where((r) => r['userId'] == userId).toList();
    return userRecipes.map((r) => _mapToRecipe(r)).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<Recipe> getRecipeById(int id) async {
    await _simulateDelay();
    final recipe = _recipes.firstWhere(
          (r) => r['id'] == id,
      orElse: () => throw Exception('Receita não encontrada'),
    );
    return _mapToRecipe(recipe);
  }

  // ✅ NOVO: Buscar receitas por estado (nome completo OU sigla)
  Future<List<Recipe>> getRecipesByState(String stateName) async {
    await _simulateDelay();

    print('🔍 Buscando receitas para o estado: $stateName');

    // Mapear nome do estado para sigla
    final stateMap = {
      'Acre': 'AC',
      'Alagoas': 'AL',
      'Amapá': 'AP',
      'Amazonas': 'AM',
      'Bahia': 'BA',
      'Ceará': 'CE',
      'Distrito Federal': 'DF',
      'Espírito Santo': 'ES',
      'Goiás': 'GO',
      'Maranhão': 'MA',
      'Mato Grosso': 'MT',
      'Mato Grosso do Sul': 'MS',
      'Minas Gerais': 'MG',
      'Pará': 'PA',
      'Paraíba': 'PB',
      'Paraná': 'PR',
      'Pernambuco': 'PE',
      'Piauí': 'PI',
      'Rio de Janeiro': 'RJ',
      'Rio Grande do Norte': 'RN',
      'Rio Grande do Sul': 'RS',
      'Rondônia': 'RO',
      'Roraima': 'RR',
      'Santa Catarina': 'SC',
      'São Paulo': 'SP',
      'Sergipe': 'SE',
      'Tocantins': 'TO'
    };

    final stateAbbr = stateMap[stateName];

    print('📍 Sigla do estado: $stateAbbr');

    // Buscar receitas que contenham o estado (nome completo OU sigla)
    final stateRecipes = _recipes.where((r) {
      final recipeState = r['state'] as String?;

      // Verificar se o campo 'state' contém o nome ou sigla
      if (recipeState != null &&
          (recipeState == stateName || recipeState == stateAbbr)) {
        print('✅ Receita "${r['title']}" encontrada com state = $recipeState');
        return true;
      }

      return false;
    }).toList();

    print('📊 Total de receitas encontradas: ${stateRecipes.length}');

    if (stateRecipes.isEmpty) {
      print('⚠️ Nenhuma receita encontrada para $stateName');
      print('📋 Estados disponíveis nas receitas:');
      _recipes.forEach((r) {
        print('   - "${r['title']}": state = ${r['state']}');
      });
    }

    return stateRecipes.map((r) => _mapToRecipe(r)).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // ============================================================================
  // MÉTODOS DE LIVROS DE RECEITAS
  // ============================================================================

  Future<List<String>> getUserRecipeBooks(int userId) async {
    await _simulateDelay();
    if (!_savedRecipesByBook.containsKey(userId)) {
      _savedRecipesByBook[userId] = {'Favoritas': []};
    }
    return _savedRecipesByBook[userId]!.keys.toList();
  }

  Future<List<Recipe>> getSavedRecipes(int userId) async {
    await _simulateDelay();
    if (!_savedRecipesByBook.containsKey(userId)) {
      return [];
    }

    final allSavedIds = <int>{};
    _savedRecipesByBook[userId]!.values.forEach((ids) => allSavedIds.addAll(ids));

    final savedRecipes = _recipes.where((r) => allSavedIds.contains(r['id'])).toList();
    return savedRecipes.map((r) => _mapToRecipe(r)).toList();
  }

  Future<Map<String, List<Recipe>>> getSavedRecipesByBook(int userId) async {
    await _simulateDelay();
    if (!_savedRecipesByBook.containsKey(userId)) {
      return {'Favoritas': []};
    }

    final result = <String, List<Recipe>>{};

    _savedRecipesByBook[userId]!.forEach((bookTitle, recipeIds) {
      final bookRecipes = _recipes
          .where((r) => recipeIds.contains(r['id']))
          .map((r) => _mapToRecipe(r))
          .toList();
      result[bookTitle] = bookRecipes;
    });

    return result;
  }

  Future<void> saveRecipeToBook(int userId, int recipeId, String bookTitle) async {
    await _simulateDelay();

    if (!_savedRecipesByBook.containsKey(userId)) {
      _savedRecipesByBook[userId] = {};
    }

    if (!_savedRecipesByBook[userId]!.containsKey(bookTitle)) {
      _savedRecipesByBook[userId]![bookTitle] = [];
    }

    if (!_savedRecipesByBook[userId]![bookTitle]!.contains(recipeId)) {
      _savedRecipesByBook[userId]![bookTitle]!.add(recipeId);
      print('✅ Receita $recipeId salva no livro "$bookTitle" do usuário $userId');

      final recipe = _recipes.firstWhere((r) => r['id'] == recipeId);
      final recipeOwnerId = recipe['userId'] as int;

      if (recipeOwnerId != userId) {
        final authService = MockAuthService();
        final currentUser = await authService.getUserById(userId);
        final notificationService = MockNotificationService();

        notificationService.createSaveNotification(
          targetUserId: recipeOwnerId,
          fromUserId: userId,
          fromUserName: currentUser['name'],
          fromUserImage: currentUser['profileImage'],
          recipeId: recipeId,
          recipeName: recipe['title'],
        );
      }
    }
  }

  Future<void> unsaveRecipeFromBook(int userId, int recipeId, String bookTitle) async {
    await _simulateDelay();

    if (_savedRecipesByBook.containsKey(userId) &&
        _savedRecipesByBook[userId]!.containsKey(bookTitle)) {
      _savedRecipesByBook[userId]![bookTitle]!.remove(recipeId);
      print('❌ Receita $recipeId removida do livro "$bookTitle" do usuário $userId');
    }
  }

  Future<void> createRecipeBook(int userId, String bookName) async {
    await _simulateDelay();

    if (!_savedRecipesByBook.containsKey(userId)) {
      _savedRecipesByBook[userId] = {};
    }

    if (!_savedRecipesByBook[userId]!.containsKey(bookName)) {
      _savedRecipesByBook[userId]![bookName] = [];
      print('📚 Livro "$bookName" criado para o usuário $userId');
    }
  }

  Future<bool> isRecipeSaved(int userId, int recipeId) async {
    await _simulateDelay();

    if (!_savedRecipesByBook.containsKey(userId)) {
      return false;
    }

    return _savedRecipesByBook[userId]!.values.any((ids) => ids.contains(recipeId));
  }

  // ============================================================================
  // MÉTODOS DE LIKE
  // ============================================================================

  Future<bool> toggleLike(int userId, int recipeId) async {
    await _simulateDelay();

    if (!_likes.containsKey(userId)) {
      _likes[userId] = [];
    }

    final userLikes = _likes[userId]!;

    if (userLikes.contains(recipeId)) {
      userLikes.remove(recipeId);

      final recipeIndex = _recipes.indexWhere((r) => r['id'] == recipeId);
      if (recipeIndex != -1) {
        _recipes[recipeIndex]['likesCount'] = (_recipes[recipeIndex]['likesCount'] as int) - 1;
      }

      print('❌ Receita $recipeId descurtida pelo usuário $userId');
      return false;
    } else {
      userLikes.add(recipeId);

      final recipeIndex = _recipes.indexWhere((r) => r['id'] == recipeId);
      if (recipeIndex != -1) {
        _recipes[recipeIndex]['likesCount'] = (_recipes[recipeIndex]['likesCount'] as int) + 1;
      }

      print('✅ Receita $recipeId curtida pelo usuário $userId');

      final recipe = _recipes[recipeIndex];
      final recipeOwnerId = recipe['userId'] as int;

      if (recipeOwnerId != userId) {
        final authService = MockAuthService();
        final currentUser = await authService.getUserById(userId);
        final notificationService = MockNotificationService();

        notificationService.createLikeNotification(
          targetUserId: recipeOwnerId,
          fromUserId: userId,
          fromUserName: currentUser['name'],
          fromUserImage: currentUser['profileImage'],
          recipeId: recipeId,
          recipeName: recipe['title'],
        );
      }

      return true;
    }
  }

  Future<bool> isRecipeLiked(int userId, int recipeId) async {
    await _simulateDelay();
    return (_likes[userId] ?? []).contains(recipeId);
  }

  // ============================================================================
  // SISTEMA DE COMENTÁRIOS
  // ============================================================================

  static final Map<int, List<Map<String, dynamic>>> _comments = {};
  static int _commentIdCounter = 1000;

  Future<List<Map<String, dynamic>>> getRecipeComments(int recipeId) async {
    await _simulateDelay();
    return List.from(_comments[recipeId] ?? []);
  }

  Future<Map<String, dynamic>> addComment({
    required int recipeId,
    required int userId,
    required String text,
    int? replyToId,
  }) async {
    await _simulateDelay();

    final authService = MockAuthService();
    final user = await authService.getUserById(userId);

    final newComment = {
      'id': _commentIdCounter++,
      'userId': userId,
      'userName': user['name'],
      'userImage': user['profileImage'],
      'text': text,
      'timestamp': DateTime.now(),
      'likes': 0,
      'isLiked': false,
      'replies': [],
    };

    if (!_comments.containsKey(recipeId)) {
      _comments[recipeId] = [];
    }

    if (replyToId != null) {
      final commentIndex = _comments[recipeId]!.indexWhere((c) => c['id'] == replyToId);
      if (commentIndex != -1) {
        final replies = _comments[recipeId]![commentIndex]['replies'] as List;
        replies.add(newComment);
      }
    } else {
      _comments[recipeId]!.insert(0, newComment);

      final recipeIndex = _recipes.indexWhere((r) => r['id'] == recipeId);
      if (recipeIndex != -1) {
        _recipes[recipeIndex]['commentsCount'] = (_recipes[recipeIndex]['commentsCount'] as int) + 1;
      }
    }

    print('💬 Comentário adicionado na receita $recipeId por ${user['name']}');

    final recipe = _recipes.firstWhere((r) => r['id'] == recipeId);
    final recipeOwnerId = recipe['userId'] as int;

    if (recipeOwnerId != userId) {
      final notificationService = MockNotificationService();
      notificationService.createCommentNotification(
        targetUserId: recipeOwnerId,
        fromUserId: userId,
        fromUserName: user['name'],
        fromUserImage: user['profileImage'],
        recipeId: recipeId,
        recipeName: recipe['title'],
        commentText: text,
      );
    }

    return newComment;
  }

  Future<void> toggleCommentLike(int recipeId, int commentId, int userId, {int? parentCommentId}) async {
    await _simulateDelay();

    if (!_comments.containsKey(recipeId)) return;

    if (parentCommentId != null) {
      final parentIndex = _comments[recipeId]!.indexWhere((c) => c['id'] == parentCommentId);
      if (parentIndex != -1) {
        final replies = _comments[recipeId]![parentIndex]['replies'] as List;
        final replyIndex = replies.indexWhere((r) => r['id'] == commentId);
        if (replyIndex != -1) {
          final reply = replies[replyIndex];
          final isLiked = reply['isLiked'] as bool;
          reply['isLiked'] = !isLiked;
          reply['likes'] = (reply['likes'] as int) + (isLiked ? -1 : 1);
        }
      }
    } else {
      final commentIndex = _comments[recipeId]!.indexWhere((c) => c['id'] == commentId);
      if (commentIndex != -1) {
        final comment = _comments[recipeId]![commentIndex];
        final isLiked = comment['isLiked'] as bool;
        comment['isLiked'] = !isLiked;
        comment['likes'] = (comment['likes'] as int) + (isLiked ? -1 : 1);
      }
    }
  }

  // ============================================================================
  // CRIAR NOVA RECEITA
  // ============================================================================

  static int _recipeIdCounter = 100;

  Future<Recipe> createRecipe(Recipe recipe, {Uint8List? imageBytes}) async {
    await _simulateDelay();

    final newId = _recipeIdCounter++;

    final authService = MockAuthService();
    final user = await authService.getUserById(recipe.userId);

    // ✅ ARMAZENAR imageBytes se fornecidos
    if (imageBytes != null) {
      _recipeImageBytes[newId] = imageBytes;
      print('📸 ImageBytes armazenados para receita $newId (${imageBytes.length} bytes)');
    }

    // ✅ EXTRAIR ESTADO DA CATEGORIA
    final extractedState = _extractState(recipe.category);

    print('🗺️ createRecipe:');
    print('   - category recebida: ${recipe.category}');
    print('   - state extraído: $extractedState');

    final newRecipeMap = {
      'id': newId,
      'userId': recipe.userId,
      'state': extractedState, // ✅ SALVAR O ESTADO EXTRAÍDO
      'title': recipe.title,
      'description': recipe.description,
      'ingredients': recipe.ingredients.map((ing) {
        final parts = ing.split(' ');
        return {
          'name': parts.length > 2 ? parts.sublist(2).join(' ') : ing,
          'quantity': parts.isNotEmpty ? parts[0] : '',
          'unit': parts.length > 1 ? parts[1] : '',
        };
      }).toList(),
      'preparationSteps': recipe.steps,
      'preparationTime': recipe.preparationTime,
      'servings': recipe.servings,
      'difficulty': 'Médio',
      'category': _extractCategory(recipe.category),
      'tags': _generateTags(recipe.category),
      'image': recipe.image ?? 'assets/images/chef.jpg',
      'createdAt': recipe.createdAt,
      'likesCount': 0,
      'commentsCount': 0,
      'savesCount': 0,
      'averageRating': 0.0,
    };

    _recipes.insert(0, newRecipeMap);

    print('✅ Receita "${recipe.title}" criada:');
    print('   - ID: $newId');
    print('   - Estado: ${newRecipeMap['state']}');
    print('   - Categoria: ${newRecipeMap['category']}');

    return _mapToRecipe(newRecipeMap);
  }

  // ============================================================================
  // MÉTODOS AUXILIARES
  // ============================================================================

  String _extractState(String? category) {
    if (category == null || category == 'Não' || category == 'Nenhum') {
      return 'Nenhum';
    }

    // Se a categoria contém " - ", pegar a última parte (sigla do estado)
    if (category.contains(' - ')) {
      final parts = category.split(' - ');
      final statePart = parts.last.trim();

      print('📍 Estado extraído da categoria: $statePart');
      return statePart;
    }

    return 'Nenhum';
  }

  String _extractCategory(String? category) {
    if (category == null) return 'Salgados';

    if (category.contains(' - ')) {
      final mainCategory = category.split(' - ').first;
      return mainCategory == 'Não' ? 'Salgados' : mainCategory;
    }

    return category == 'Não' ? 'Salgados' : category;
  }

  List<String> _generateTags(String? category) {
    if (category == null) return ['Caseiro'];

    final tags = <String>['Caseiro'];

    if (category.contains('Glúten')) tags.add('Zero Glúten');
    if (category.contains('Lactose')) tags.add('Zero Lactose');
    if (category.contains('Vegano')) tags.add('Vegano');
    if (category.contains('Vegetariano')) tags.add('Vegetariano');

    return tags;
  }

  Recipe _mapToRecipe(Map<String, dynamic> data) {
    final ingredientsList = (data['ingredients'] as List)
        .map((i) => '${i['quantity']} ${i['unit']} ${i['name']}'.trim())
        .toList();

    final recipeId = data['id'] as int;

    // ✅ Buscar imageBytes se existir
    final imageBytes = _recipeImageBytes[recipeId];

    return Recipe(
      id: recipeId,
      userId: data['userId'],
      userName: _getUserName(data['userId']),
      title: data['title'],
      description: data['description'],
      ingredients: ingredientsList,
      steps: List<String>.from(data['preparationSteps']),
      preparationTime: data['preparationTime'],
      servings: data['servings'],
      category: data['category'],
      state: data['state'],
      image: data['image'],
      imageBytes: imageBytes,
      createdAt: data['createdAt'],
      likesCount: data['likesCount'],
      commentsCount: data['commentsCount'],
      averageRating: (data['averageRating'] as num).toDouble(),
    );
  }

  String _getUserName(int userId) {
    final userNames = {
      1: 'João Pedro Silva',
      2: 'Maria Santos',
      3: 'Carlos Oliveira',
      4: 'Ana Beatriz Costa',
      5: 'Rafael Mendes',
      6: 'Juliana Ferreira',
      7: 'Teste User',
      9: 'Pedro Henrique',
      10: 'Fernanda Gomes',
    };
    return userNames[userId] ?? 'Chef Anônimo';
  }

  Future<String> uploadRecipeImage(String filePath, {Uint8List? imageBytes}) async {
    await _simulateDelay();
    print('📸 Upload simulado de imagem: $filePath');
    return filePath;
  }

  Future<Recipe> updateRecipe(int recipeId, Recipe updatedRecipe, {Uint8List? imageBytes}) async {
    await _simulateDelay();

    final recipeIndex = _recipes.indexWhere((r) => r['id'] == recipeId);
    if (recipeIndex == -1) {
      throw Exception('Receita não encontrada');
    }

    // ✅ Atualizar imageBytes se fornecidos
    if (imageBytes != null) {
      _recipeImageBytes[recipeId] = imageBytes;
      print('📸 ImageBytes atualizados para receita $recipeId (${imageBytes.length} bytes)');
    }

    // ✅ EXTRAIR ESTADO DA CATEGORIA
    final extractedState = _extractState(updatedRecipe.category);

    print('🔄 updateRecipe:');
    print('   - ID: $recipeId');
    print('   - category recebida: ${updatedRecipe.category}');
    print('   - state extraído: $extractedState');

    // ✅ Atualizar dados da receita
    _recipes[recipeIndex] = {
      'id': recipeId,
      'userId': _recipes[recipeIndex]['userId'], // Mantém o autor original
      'state': extractedState,
      'title': updatedRecipe.title,
      'description': updatedRecipe.description,
      'ingredients': updatedRecipe.ingredients.map((ing) {
        final parts = ing.split(' ');
        return {
          'name': parts.length > 2 ? parts.sublist(2).join(' ') : ing,
          'quantity': parts.isNotEmpty ? parts[0] : '',
          'unit': parts.length > 1 ? parts[1] : '',
        };
      }).toList(),
      'preparationSteps': updatedRecipe.steps,
      'preparationTime': updatedRecipe.preparationTime,
      'servings': updatedRecipe.servings,
      'difficulty': _recipes[recipeIndex]['difficulty'], // Mantém dificuldade
      'category': _extractCategory(updatedRecipe.category),
      'tags': _generateTags(updatedRecipe.category),
      'image': updatedRecipe.image ?? _recipes[recipeIndex]['image'],
      'createdAt': _recipes[recipeIndex]['createdAt'], // Mantém data de criação
      'likesCount': _recipes[recipeIndex]['likesCount'],
      'commentsCount': _recipes[recipeIndex]['commentsCount'],
      'savesCount': _recipes[recipeIndex]['savesCount'],
      'averageRating': _recipes[recipeIndex]['averageRating'],
    };

    print('✅ Receita "${updatedRecipe.title}" atualizada com sucesso!');

    return _mapToRecipe(_recipes[recipeIndex]);
  }

  // ============================================================================
  // EXCLUIR RECEITA
  // ============================================================================

  Future<void> deleteRecipe(int recipeId, int userId) async {
    await _simulateDelay();

    final recipeIndex = _recipes.indexWhere((r) => r['id'] == recipeId);
    if (recipeIndex == -1) {
      throw Exception('Receita não encontrada');
    }

    // ✅ Verificar se o usuário é o autor
    if (_recipes[recipeIndex]['userId'] != userId) {
      throw Exception('Você não tem permissão para excluir esta receita');
    }

    final recipeTitle = _recipes[recipeIndex]['title'];

    // ✅ Remover dos salvos de todos os usuários
    _savedRecipesByBook.forEach((uid, books) {
      books.forEach((bookName, recipeIds) {
        recipeIds.remove(recipeId);
      });
    });

    // ✅ Remover dos likes de todos os usuários
    _likes.forEach((uid, likedRecipes) {
      likedRecipes.remove(recipeId);
    });

    // ✅ Remover comentários
    _comments.remove(recipeId);

    // ✅ Remover imageBytes
    _recipeImageBytes.remove(recipeId);

    // ✅ Remover receita
    _recipes.removeAt(recipeIndex);

    print('🗑️ Receita "$recipeTitle" (ID: $recipeId) excluída com sucesso!');
  }
}