import 'dart:async';
import '../models/models.dart';
import 'mock_notification_service.dart';
import 'mock_auth_service.dart';

class MockRecipeService {
  static final List<Map<String, dynamic>> _recipes = [
    {
      'id': 1,
      'userId': 1,
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
        {'name': 'Sal', 'quantity': '1', 'unit': 'pitada'},
      ],
      'preparationSteps': [
        'Bata no liquidificador o milho, os ovos, o óleo e o leite de coco',
        'Adicione o mel e misture bem',
        'Em uma tigela, misture a farinha de milho, o fermento, a canela e o sal',
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
      'title': 'Canjica zero lactose',
      'description': 'Canjica cremosa e deliciosa, perfeita para quem tem intolerância à lactose.',
      'ingredients': [
        {'name': 'Milho para canjica', 'quantity': '500', 'unit': 'g'},
        {'name': 'Leite de coco', 'quantity': '2', 'unit': 'latas'},
        {'name': 'Açúcar mascavo', 'quantity': '1', 'unit': 'xícara'},
        {'name': 'Canela em pau', 'quantity': '2', 'unit': 'unidades'},
        {'name': 'Cravo', 'quantity': '4', 'unit': 'unidades'},
        {'name': 'Leite de amêndoas', 'quantity': '500', 'unit': 'ml'},
        {'name': 'Amendoim torrado', 'quantity': '100', 'unit': 'g'},
        {'name': 'Coco ralado', 'quantity': '100', 'unit': 'g'},
        {'name': 'Sal', 'quantity': '1', 'unit': 'pitada'},
      ],
      'preparationSteps': [
        'Deixe o milho de molho por 12 horas',
        'Cozinhe o milho em panela de pressão por 40 minutos',
        'Adicione o leite de coco e o leite de amêndoas',
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
      'userId': 4,
      'title': 'Brownie de chocolate',
      'description': 'Brownie ultra cremoso com chocolate belga de primeira qualidade.',
      'ingredients': [
        {'name': 'Chocolate meio amargo', 'quantity': '300', 'unit': 'g'},
        {'name': 'Manteiga', 'quantity': '200', 'unit': 'g'},
        {'name': 'Açúcar', 'quantity': '1 1/2', 'unit': 'xícara'},
        {'name': 'Ovos', 'quantity': '4', 'unit': 'unidades'},
        {'name': 'Farinha de trigo', 'quantity': '1', 'unit': 'xícara'},
        {'name': 'Cacau em pó', 'quantity': '1/2', 'unit': 'xícara'},
        {'name': 'Sal', 'quantity': '1', 'unit': 'pitada'},
        {'name': 'Nozes', 'quantity': '100', 'unit': 'g'},
      ],
      'preparationSteps': [
        'Derreta o chocolate com a manteiga em banho-maria',
        'Bata os ovos com o açúcar até ficar cremoso',
        'Misture o chocolate derretido aos ovos',
        'Adicione a farinha e o cacau peneirados',
        'Acrescente as nozes picadas',
        'Asse a 180°C por 25-30 minutos',
      ],
      'preparationTime': 45,
      'servings': 16,
      'difficulty': 'Fácil',
      'category': 'Doces',
      'tags': ['Chocolate', 'Sobremesa', 'Festa'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(days: 1)),
      'likesCount': 89,
      'commentsCount': 24,
      'savesCount': 56,
      'averageRating': 4.9,
    },
    {
      'id': 4,
      'userId': 6,
      'title': 'Pizza Margherita',
      'description': 'Pizza clássica italiana com molho de tomate fresco, mussarela e manjericão.',
      'ingredients': [
        {'name': 'Massa de pizza', 'quantity': '1', 'unit': 'unidade'},
        {'name': 'Molho de tomate', 'quantity': '200', 'unit': 'g'},
        {'name': 'Mussarela', 'quantity': '250', 'unit': 'g'},
        {'name': 'Manjericão fresco', 'quantity': '1', 'unit': 'maço'},
        {'name': 'Azeite', 'quantity': '2', 'unit': 'colheres'},
        {'name': 'Sal', 'quantity': '1', 'unit': 'pitada'},
        {'name': 'Orégano', 'quantity': '1', 'unit': 'colher de chá'},
      ],
      'preparationSteps': [
        'Abra a massa em formato redondo',
        'Espalhe o molho de tomate',
        'Distribua a mussarela fatiada',
        'Regue com azeite',
        'Asse em forno bem quente (250°C) por 15 minutos',
        'Finalize com manjericão fresco',
      ],
      'preparationTime': 30,
      'servings': 4,
      'difficulty': 'Fácil',
      'category': 'Salgados',
      'tags': ['Pizza', 'Italiano', 'Jantar'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(days: 2)),
      'likesCount': 72,
      'commentsCount': 15,
      'savesCount': 38,
      'averageRating': 4.7,
    },
    {
      'id': 5,
      'userId': 10,
      'title': 'Tapioca Recheada',
      'description': 'Tapioca brasileira com recheio de queijo coalho e coco.',
      'ingredients': [
        {'name': 'Goma de tapioca', 'quantity': '200', 'unit': 'g'},
        {'name': 'Queijo coalho', 'quantity': '150', 'unit': 'g'},
        {'name': 'Coco ralado', 'quantity': '100', 'unit': 'g'},
        {'name': 'Manteiga', 'quantity': '1', 'unit': 'colher'},
      ],
      'preparationSteps': [
        'Aqueça uma frigideira antiaderente',
        'Coloque a goma de tapioca formando um círculo',
        'Quando começar a grudar, adicione o recheio',
        'Dobre ao meio e deixe dourar',
        'Sirva quente',
      ],
      'preparationTime': 15,
      'servings': 2,
      'difficulty': 'Fácil',
      'category': 'Salgados',
      'tags': ['Brasileiro', 'Rápido', 'Café da manhã'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(hours: 8)),
      'likesCount': 54,
      'commentsCount': 9,
      'savesCount': 31,
      'averageRating': 4.6,
    },
    {
      'id': 6,
      'userId': 4,
      'title': 'Pão de Queijo',
      'description': 'Pão de queijo mineiro tradicional, crocante por fora e macio por dentro.',
      'ingredients': [
        {'name': 'Polvilho azedo', 'quantity': '500', 'unit': 'g'},
        {'name': 'Leite', 'quantity': '1', 'unit': 'xícara'},
        {'name': 'Óleo', 'quantity': '1/2', 'unit': 'xícara'},
        {'name': 'Ovos', 'quantity': '3', 'unit': 'unidades'},
        {'name': 'Queijo meia cura', 'quantity': '200', 'unit': 'g'},
        {'name': 'Sal', 'quantity': '1', 'unit': 'colher de chá'},
      ],
      'preparationSteps': [
        'Ferva o leite com o óleo e o sal',
        'Despeje sobre o polvilho e misture',
        'Deixe esfriar e adicione os ovos',
        'Acrescente o queijo ralado',
        'Faça bolinhas e disponha em assadeira',
        'Asse a 180°C por 30 minutos',
      ],
      'preparationTime': 50,
      'servings': 24,
      'difficulty': 'Médio',
      'category': 'Salgados',
      'tags': ['Mineiro', 'Café', 'Tradicional'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(days: 4)),
      'likesCount': 98,
      'commentsCount': 31,
      'savesCount': 67,
      'averageRating': 4.9,
    },
    {
      'id': 7,
      'userId': 1,
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
      'id': 8,
      'userId': 6,
      'title': 'Suco Verde Detox',
      'description': 'Suco verde energizante e desintoxicante.',
      'ingredients': [
        {'name': 'Couve', 'quantity': '2', 'unit': 'folhas'},
        {'name': 'Limão', 'quantity': '1', 'unit': 'unidade'},
        {'name': 'Gengibre', 'quantity': '1', 'unit': 'pedaço pequeno'},
        {'name': 'Maçã verde', 'quantity': '1', 'unit': 'unidade'},
        {'name': 'Água de coco', 'quantity': '200', 'unit': 'ml'},
      ],
      'preparationSteps': [
        'Lave bem todos os ingredientes',
        'Corte a maçã e o limão',
        'Bata tudo no liquidificador',
        'Coe se preferir',
        'Sirva gelado',
      ],
      'preparationTime': 10,
      'servings': 1,
      'difficulty': 'Fácil',
      'category': 'Bebidas',
      'tags': ['Saudável', 'Detox', 'Rápido'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(hours: 12)),
      'likesCount': 43,
      'commentsCount': 7,
      'savesCount': 29,
      'averageRating': 4.5,
    },
    {
      'id': 9,
      'userId': 10,
      'title': 'Brigadeiro Gourmet',
      'description': 'Brigadeiro cremoso com chocolate belga.',
      'ingredients': [
        {'name': 'Leite condensado', 'quantity': '1', 'unit': 'lata'},
        {'name': 'Chocolate em pó', 'quantity': '3', 'unit': 'colheres'},
        {'name': 'Manteiga', 'quantity': '1', 'unit': 'colher'},
        {'name': 'Granulado', 'quantity': '100', 'unit': 'g'},
      ],
      'preparationSteps': [
        'Misture tudo em uma panela',
        'Cozinhe em fogo baixo mexendo sempre',
        'Deixe esfriar',
        'Faça bolinhas',
        'Passe no granulado',
      ],
      'preparationTime': 20,
      'servings': 20,
      'difficulty': 'Fácil',
      'category': 'Doces',
      'tags': ['Festa', 'Brigadeiro', 'Chocolate'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(days: 6)),
      'likesCount': 76,
      'commentsCount': 19,
      'savesCount': 44,
      'averageRating': 4.8,
    },
  ];

  // Mapa de curtidas: userId -> [recipeIds]
  static final Map<int, List<int>> _likes = {
    1: [3, 4, 6],
    4: [1, 2],
    6: [1, 2, 3],
    10: [1, 3, 6],
  };

  // Mapa de salvos por livro: userId -> {bookTitle -> [recipeIds]}
  static final Map<int, Map<String, List<int>>> _savedRecipesByBook = {
    1: {
      'Favoritas': [3, 4],
      'Festa Junina': [1, 2, 7],
    },
    4: {
      'Favoritas': [1],
      'Para Fazer': [6],
    },
    6: {
      'Favoritas': [1, 2],
      'Doces': [3],
    },
    10: {
      'Favoritas': [1, 6],
      'Rápidas': [5],
    },
  };

  Future<void> _simulateDelay() async {
    await Future.delayed(Duration(milliseconds: 400));
  }

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

  // ===== MÉTODOS DE LIVROS DE RECEITAS =====

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

      // 🔔 CRIAR NOTIFICAÇÃO DE SAVE
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

  // ===== MÉTODOS DE LIKE =====

  Future<bool> toggleLike(int userId, int recipeId) async {
    await _simulateDelay();

    if (!_likes.containsKey(userId)) {
      _likes[userId] = [];
    }

    final userLikes = _likes[userId]!;

    if (userLikes.contains(recipeId)) {
      userLikes.remove(recipeId);

      // Atualizar contagem
      final recipeIndex = _recipes.indexWhere((r) => r['id'] == recipeId);
      if (recipeIndex != -1) {
        _recipes[recipeIndex]['likesCount'] = (_recipes[recipeIndex]['likesCount'] as int) - 1;
      }

      print('❌ Receita $recipeId descurtida pelo usuário $userId');
      return false;
    } else {
      userLikes.add(recipeId);

      // Atualizar contagem
      final recipeIndex = _recipes.indexWhere((r) => r['id'] == recipeId);
      if (recipeIndex != -1) {
        _recipes[recipeIndex]['likesCount'] = (_recipes[recipeIndex]['likesCount'] as int) + 1;
      }

      print('✅ Receita $recipeId curtida pelo usuário $userId');

      // 🔔 CRIAR NOTIFICAÇÃO DE LIKE
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

  // ===== MÉTODO DE MAPEAMENTO =====

  Recipe _mapToRecipe(Map<String, dynamic> data) {
    // ✅ Converter ingredientes para List<String>
    final ingredientsList = (data['ingredients'] as List)
        .map((i) => '${i['quantity']} ${i['unit']} ${i['name']}'.trim())
        .toList();

    return Recipe(
      id: data['id'],
      userId: data['userId'],
      userName: _getUserName(data['userId']),
      title: data['title'],
      description: data['description'],
      ingredients: ingredientsList, // ✅ List<String>
      steps: List<String>.from(data['preparationSteps']), // ✅ steps
      preparationTime: data['preparationTime'],
      servings: data['servings'],
      category: data['category'],
      image: data['image'],
      createdAt: data['createdAt'],
      likesCount: data['likesCount'],
      commentsCount: data['commentsCount'],
      averageRating: (data['averageRating'] as num).toDouble(),
    );
  }

  String _getUserName(int userId) {
    final userNames = {
      1: 'João Pedro Silva',
      4: 'Ana Beatriz Costa',
      6: 'Juliana Ferreira',
      10: 'Fernanda Gomes',
    };
    return userNames[userId] ?? 'Chef Anônimo';
  }

  Future<String> uploadRecipeImage(String filePath) async {
    await _simulateDelay();
    print('📸 Upload simulado de imagem: $filePath');
    return 'assets/images/chef.jpg';
  }
}