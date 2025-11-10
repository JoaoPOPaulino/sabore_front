// lib/services/mock_recipe_service.dart
import 'package:sabore_app/models/models.dart'; // Importa seus modelos
import 'dart:math';

class MockRecipeService {
  final Random _random = Random();

  static final List<Recipe> _recipes = [
    Recipe(
      id: 1,
      title: 'Bolo de Milho Cremoso da Vovó',
      description: 'Aquele bolo de milho molhadinho que derrete na boca.',
      image: 'assets/images/chef.jpg',
      preparationTime: 60,
      servings: 8,
      ingredients: ['1 lata de milho verde', '1 lata de leite', '1 lata de açúcar', '1/2 lata de óleo', '1 lata de fubá', '3 ovos', '1 colher (sopa) de fermento'],
      steps: ['Bata tudo no liquidificador.', 'Asse em forma untada por 40 minutos.'],
      category: 'Doces - GO',
      userId: 4, // Chef Ana
      userName: 'Ana Beatriz Costa',
      userImage: 'assets/images/chef.jpg',
      createdAt: DateTime.now().subtract(Duration(days: 5)),
      likesCount: 130, commentsCount: 22, isLiked: false, isSaved: false, averageRating: 4.8,
    ),
    Recipe(
      id: 2,
      title: 'Feijão Tropeiro Mineiro',
      description: 'Um clássico da culinária de Minas Gerais.',
      image: 'assets/images/chef.jpg',
      preparationTime: 45,
      servings: 6,
      ingredients: ['500g de feijão carioca', '200g de bacon', '200g de calabresa', '1 cebola', '4 dentes de alho', 'Farinha de mandioca', 'Cheiro-verde', '4 ovos'],
      steps: ['Frite o bacon e a linguiça.', 'Adicione a cebola e o alho.', 'Misture o feijão e a farinha.', 'Adicione os ovos mexidos e o cheiro-verde.'],
      category: 'Salgados - MG',
      userId: 1, // João Pedro Silva
      userName: 'João Pedro Silva',
      userImage: null,
      createdAt: DateTime.now().subtract(Duration(days: 10)),
      likesCount: 250, commentsCount: 40, isLiked: true, isSaved: true, averageRating: 4.9,
    ),
    Recipe(
      id: 3,
      title: 'Moqueca Baiana Rápida',
      description: 'Sinta o sabor da Bahia com esta moqueca fácil.',
      image: 'assets/images/chef.jpg',
      preparationTime: 35,
      servings: 4,
      ingredients: ['500g de postas de peixe', '200ml de leite de coco', '50ml de azeite de dendê', '1 pimentão vermelho', '1 pimentão amarelo', '2 tomates', '1 cebola', 'Coentro'],
      steps: ['Faça camadas de peixe, tomate, cebola e pimentões.', 'Regue com o leite de coco e o dendê.', 'Cozinhe por 20 minutos.'],
      category: 'Salgados - BA',
      userId: 6, // Juliana Ferreira
      userName: 'Juliana Ferreira',
      userImage: null,
      createdAt: DateTime.now().subtract(Duration(days: 2)),
      likesCount: 95, commentsCount: 15, isLiked: false, isSaved: false, averageRating: 4.7,
    ),
    Recipe(
      id: 4,
      title: 'Pão de Queijo Vegano',
      description: 'A versão sem nada de origem animal do nosso querido pão de queijo.',
      image: 'assets/images/chef.jpg',
      preparationTime: 50,
      servings: 10,
      ingredients: ['2 xícaras de polvilho doce', '1 xícara de batata cozida', '1/2 xícara de óleo', '1/2 xícara de água', '1/4 xícara de levedura nutricional', 'Sal'],
      steps: ['Misture a batata, o polvilho e o sal.', 'Aqueça o óleo e a água e escalde o polvilho.', 'Adicione a levedura.', 'Faça bolinhas e asse.'],
      category: 'Vegano',
      userId: 4, // Chef Ana
      userName: 'Ana Beatriz Costa',
      userImage: 'assets/images/chef.jpg',
      createdAt: DateTime.now().subtract(Duration(days: 20)),
      likesCount: 300, commentsCount: 55, isLiked: true, isSaved: false, averageRating: 4.9,
    ),
    Recipe(
      id: 5,
      title: 'Pizza Margherita da Maria',
      description: 'Simples e clássica.',
      image: 'assets/images/chef.jpg',
      preparationTime: 30,
      servings: 4,
      ingredients: ['1 massa de pizza', 'Molho de tomate', 'Queijo mussarela', 'Tomate', 'Manjericão'],
      steps: ['Abrir a massa', 'Colocar molho', 'Adicionar queijo, tomate e manjericão', 'Assar.'],
      category: 'Salgados - SP',
      userId: 2, // Maria Santos
      userName: 'Maria Santos',
      userImage: null,
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      likesCount: 20, commentsCount: 3, isLiked: false, isSaved: false, averageRating: 4.5,
    ),
    Recipe(
      id: 6,
      title: 'Brigadeiro Gourmet',
      description: 'Um brigadeiro com chocolate de alta qualidade.',
      image: 'assets/images/chef.jpg',
      preparationTime: 25,
      servings: 20,
      ingredients: ['1 lata de leite condensado', '1 colher de manteiga', '100g de chocolate amargo 70%', 'Chocolate granulado'],
      steps: ['Misture tudo em fogo baixo.', 'Enrole e passe no granulado.'],
      category: 'Doces',
      userId: 10, // Fernanda Gomes
      userName: 'Fernanda Gomes',
      userImage: null,
      createdAt: DateTime.now().subtract(Duration(days: 3)),
      likesCount: 550, commentsCount: 80, isLiked: true, isSaved: true, averageRating: 5.0,
    ),
    Recipe(
      id: 7,
      title: 'Cuscuz Nordestino com Carne Seca',
      description: 'Perfeito para um café da manhã reforçado.',
      image: 'assets/images/chef.jpg',
      preparationTime: 40,
      servings: 3,
      ingredients: ['2 xícaras de flocão de milho', '1 xícara de água', 'Sal a gosto', '300g de carne seca dessalgada e desfiada', '1/2 cebola roxa', 'Manteiga de garrafa'],
      steps: ['Hidrate o flocão com água e sal.', 'Cozinhe no vapor.', 'Refogue a carne seca com a cebola na manteiga.', 'Sirva o cuscuz com a carne por cima.'],
      category: 'Salgados - PE',
      userId: 10, // Fernanda Gomes
      userName: 'Fernanda Gomes',
      userImage: null,
      createdAt: DateTime.now().subtract(Duration(days: 15)),
      likesCount: 800, commentsCount: 120, isLiked: false, isSaved: true, averageRating: 4.9,
    ),
    Recipe(
      id: 8,
      title: 'Arroz Carreteiro',
      description: 'Prato típico do Sul do Brasil.',
      image: 'assets/images/chef.jpg',
      preparationTime: 50,
      servings: 5,
      ingredients: ['500g de charque', '2 xícaras de arroz', '1 cebola', '2 dentes de alho', '1 pimentão', 'Cheiro-verde'],
      steps: ['Dessalgue e frite a charque.', 'Refogue os temperos.', 'Adicione o arroz e a água.', 'Cozinhe até secar.'],
      category: 'Salgados - RS',
      userId: 5, // Rafael Oliveira
      userName: 'Rafael Oliveira',
      userImage: null,
      createdAt: DateTime.now().subtract(Duration(days: 30)),
      likesCount: 75, commentsCount: 10, isLiked: false, isSaved: false, averageRating: 4.6,
    ),
    Recipe(
      id: 9,
      title: 'Paçoca Caseira Simples',
      description: 'Doce de amendoim tradicional.',
      image: 'assets/images/chef.jpg',
      preparationTime: 20,
      servings: 15,
      ingredients: ['500g de amendoim torrado e sem pele', '2 xícaras de açúcar', '1 pitada de sal'],
      steps: ['Triture o amendoim no liquidificador.', 'Misture com o açúcar e o sal.', 'Aperte em forminhas.'],
      category: 'Doces - Juninas',
      userId: 1, // João Pedro Silva
      userName: 'João Pedro Silva',
      userImage: null,
      createdAt: DateTime.now().subtract(Duration(days: 4)),
      likesCount: 40, commentsCount: 5, isLiked: false, isSaved: false, averageRating: 4.7,
    ),
    Recipe(
      id: 10,
      title: 'Tambaqui Assado (Amazonas)',
      description: 'O sabor do Norte na sua casa.',
      image: 'assets/images/chef.jpg',
      preparationTime: 70,
      servings: 4,
      ingredients: ['1 tambaqui de 2kg', 'Limão', 'Sal', 'Pimenta-do-reino', 'Farinha de mandioca (para o recheio)', 'Banana pacovã'],
      steps: ['Tempere o peixe com limão, sal e pimenta.', 'Recheie com uma farofa de banana.', 'Asse na brasa ou forno.'],
      category: 'Salgados - AM',
      userId: 13, // Bruno Rocha
      userName: 'Bruno Rocha',
      userImage: null,
      createdAt: DateTime.now().subtract(Duration(days: 8)),
      likesCount: 110, commentsCount: 12, isLiked: false, isSaved: false, averageRating: 4.8,
    ),
    Recipe(
      id: 11,
      title: 'Suco Verde Detox',
      description: 'Comece o dia leve.',
      image: 'assets/images/chef.jpg',
      preparationTime: 10,
      servings: 1,
      ingredients: ['1 folha de couve', '1/2 maçã', '1/2 limão espremido', 'Gengibre a gosto', '200ml de água de coco'],
      steps: ['Bata tudo no liquidificador.', 'Coe se preferir.'],
      category: 'Bebidas',
      userId: 4, // Chef Ana
      userName: 'Ana Beatriz Costa',
      userImage: 'assets/images/chef.jpg',
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      likesCount: 45, commentsCount: 8, isLiked: false, isSaved: false, averageRating: 4.5,
    ),
    Recipe(
      id: 12,
      title: 'Pão Caseiro Fofinho',
      description: 'Pão caseiro que a família toda adora.',
      image: 'assets/images/chef.jpg',
      preparationTime: 180,
      servings: 2,
      ingredients: ['1kg de farinha de trigo', '10g de fermento biológico seco', '1/2 xícara de óleo', '1 xícara de leite morno', '1 xícara de água morna', '3 colheres de açúcar', '1 colher de sal'],
      steps: ['Misture os secos.', 'Adicione os líquidos.', 'Sove a massa por 15 minutos.', 'Deixe crescer por 1 hora.', 'Modele os pães e deixe crescer por mais 40 minutos.', 'Asse em forno médio.'],
      category: 'Salgados',
      userId: 1, // João Pedro Silva
      userName: 'João Pedro Silva',
      userImage: null,
      createdAt: DateTime.now().subtract(Duration(days: 25)),
      likesCount: 180, commentsCount: 30, isLiked: false, isSaved: false, averageRating: 4.8,
    ),
    Recipe(
      id: 13,
      title: 'Quentão de Festa Junina',
      description: 'Para aquecer as noites frias.',
      image: 'assets/images/chef.jpg',
      preparationTime: 20,
      servings: 6,
      ingredients: ['1 garrafa de cachaça', '600ml de água', '1/2kg de açúcar', 'Casca de 2 laranjas', 'Gengibre a gosto', 'Cravo e canela em pau'],
      steps: ['Caramelize o açúcar com as especiarias.', 'Adicione a água e a cachaça.', 'Ferva por 15 minutos.'],
      category: 'Bebidas - Juninas',
      userId: 6, // Juliana Ferreira
      userName: 'Juliana Ferreira',
      userImage: null,
      createdAt: DateTime.now().subtract(Duration(days: 100)),
      likesCount: 90, commentsCount: 14, isLiked: false, isSaved: false, averageRating: 4.7,
    ),
    Recipe(
      id: 14,
      title: 'Farofa de Banana da Terra',
      description: 'Acompanhamento perfeito para churrasco.',
      image: 'assets/images/chef.jpg',
      preparationTime: 15,
      servings: 4,
      ingredients: ['2 bananas-da-terra maduras', '1 cebola roxa', '100g de manteiga', '2 xícaras de farinha de mandioca', 'Coentro a gosto'],
      steps: ['Frite a banana na manteiga até dourar.', 'Adicione a cebola e refogue.', 'Acrescente a farinha e mexa bem.', 'Finalize com coentro.'],
      category: 'Salgados - BA',
      userId: 10, // Fernanda Gomes
      userName: 'Fernanda Gomes',
      userImage: null,
      createdAt: DateTime.now().subtract(Duration(days: 7)),
      likesCount: 210, commentsCount: 25, isLiked: false, isSaved: false, averageRating: 4.8,
    ),
    Recipe(
      id: 15,
      title: 'Canjica Zero Lactose',
      description: 'Doce junino cremoso e sem lactose.',
      image: 'assets/images/chef.jpg',
      preparationTime: 90,
      servings: 8,
      ingredients: ['500g de milho para canjica', '1L de leite de coco', '1 xícara de açúcar', '100g de coco ralado sem açúcar', 'Canela em pau e cravo a gosto'],
      steps: ['Cozinhe o milho na pressão até ficar macio.', 'Adicione o leite de coco, açúcar e especiarias.', 'Ferva até engrossar.', 'Adicione o coco ralado.'],
      category: 'Zero Lactose - Juninas',
      userId: 4, // Chef Ana
      userName: 'Ana Beatriz Costa',
      userImage: 'assets/images/chef.jpg',
      createdAt: DateTime.now().subtract(Duration(days: 120)),
      likesCount: 400, commentsCount: 60, isLiked: false, isSaved: false, averageRating: 4.9,
    ),
  ];

  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(Duration(milliseconds: 400));
  }

  Future<List<Recipe>> getRecipes({String? category, String? search, int page = 1}) async {
    await _simulateNetworkDelay();
    List<Recipe> filteredRecipes = _recipes;

    if (search != null && search.isNotEmpty) {
      filteredRecipes = filteredRecipes.where((r) => r.title.toLowerCase().contains(search.toLowerCase())).toList();
    }

    if (category != null && category.isNotEmpty) {
      filteredRecipes = filteredRecipes.where((r) => r.category != null && r.category!.contains(category)).toList();
    }

    return filteredRecipes;
  }

  Future<Recipe> getRecipeById(int id) async {
    await _simulateNetworkDelay();
    try {
      return _recipes.firstWhere((r) => r.id == id);
    } catch (e) {
      throw Exception('Receita não encontrada');
    }
  }

  Future<Recipe> createRecipe(Recipe recipe) async {
    await _simulateNetworkDelay();
    final newId = _random.nextInt(10000) + 100;

    final newRecipe = recipe.copyWith(
      id: newId,
      createdAt: DateTime.now(),
    );

    _recipes.insert(0, newRecipe);
    print('✅ [MOCK] Receita criada com ID: $newId');
    return newRecipe;
  }

  Future<void> deleteRecipe(int id) async {
    await _simulateNetworkDelay();
    _recipes.removeWhere((r) => r.id == id);
    print('✅ [MOCK] Receita deletada: $id');
  }

  Future<List<Recipe>> getUserRecipes(int userId) async {
    await _simulateNetworkDelay();
    final userRecipes = _recipes.where((r) => r.userId == userId).toList();
    print('✅ [MOCK] Encontradas ${userRecipes.length} receitas para o usuário $userId');
    return userRecipes;
  }

  Future<String> uploadRecipeImage(String filePath) async {
    await _simulateNetworkDelay();
    print('✅ [MOCK] Upload de imagem simulado para: $filePath');
    return 'assets/images/chef.jpg';
  }

  Future<Recipe> updateRecipe(int id, Recipe recipe) async {
    final index = _recipes.indexWhere((r) => r.id == id);
    if(index != -1) {
      _recipes[index] = recipe;
    }
    return recipe;
  }

  Future<void> likeRecipe(int id) async { print('✅ [MOCK] Receita $id curtida'); }
  Future<void> unlikeRecipe(int id) async { print('✅ [MOCK] Receita $id descurtida'); }
  Future<void> saveRecipe(int id) async { print('✅ [MOCK] Receita $id salva'); }
}