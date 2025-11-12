import 'dart:async';
import '../models/models.dart';
import 'mock_notification_service.dart';
import 'mock_auth_service.dart';

class MockRecipeService {
  static final List<Map<String, dynamic>> _recipes = [
    // ===== RECEITAS DO JOÃO (userId: 1) - 5 receitas =====
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

    // ===== RECEITAS DA MARIA (userId: 2) - 3 receitas =====
    {
      'id': 6,
      'userId': 2,
      'title': 'Lasanha à Bolonhesa',
      'description': 'Lasanha tradicional com molho bolonhesa caseiro e muito queijo.',
      'ingredients': [
        {'name': 'Massa de lasanha', 'quantity': '500', 'unit': 'g'},
        {'name': 'Carne moída', 'quantity': '500', 'unit': 'g'},
        {'name': 'Molho de tomate', 'quantity': '500', 'unit': 'g'},
        {'name': 'Queijo mussarela', 'quantity': '300', 'unit': 'g'},
        {'name': 'Queijo parmesão', 'quantity': '100', 'unit': 'g'},
        {'name': 'Cebola', 'quantity': '1', 'unit': 'unidade'},
        {'name': 'Alho', 'quantity': '3', 'unit': 'dentes'},
      ],
      'preparationSteps': [
        'Refogue a carne com cebola e alho',
        'Adicione o molho de tomate e tempere',
        'Cozinhe a massa de lasanha',
        'Monte camadas: molho, massa, queijo',
        'Repita as camadas',
        'Asse a 180°C por 40 minutos',
      ],
      'preparationTime': 90,
      'servings': 8,
      'difficulty': 'Médio',
      'category': 'Salgados',
      'tags': ['Italiano', 'Jantar', 'Família'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(days: 2)),
      'likesCount': 78,
      'commentsCount': 22,
      'savesCount': 56,
      'averageRating': 4.9,
    },
    {
      'id': 7,
      'userId': 2,
      'title': 'Risoto de Camarão',
      'description': 'Risoto cremoso com camarões frescos e ervas finas.',
      'ingredients': [
        {'name': 'Arroz arbóreo', 'quantity': '2', 'unit': 'xícaras'},
        {'name': 'Camarão', 'quantity': '500', 'unit': 'g'},
        {'name': 'Caldo de peixe', 'quantity': '1', 'unit': 'litro'},
        {'name': 'Vinho branco', 'quantity': '1/2', 'unit': 'xícara'},
        {'name': 'Queijo parmesão', 'quantity': '100', 'unit': 'g'},
        {'name': 'Manteiga', 'quantity': '50', 'unit': 'g'},
      ],
      'preparationSteps': [
        'Refogue o arroz na manteiga',
        'Adicione o vinho branco',
        'Vá adicionando o caldo aos poucos',
        'Mexa sempre até ficar cremoso',
        'Adicione os camarões',
        'Finalize com parmesão',
      ],
      'preparationTime': 50,
      'servings': 4,
      'difficulty': 'Difícil',
      'category': 'Salgados',
      'tags': ['Sofisticado', 'Jantar especial', 'Frutos do mar'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(days: 6)),
      'likesCount': 92,
      'commentsCount': 28,
      'savesCount': 68,
      'averageRating': 4.9,
    },
    {
      'id': 8,
      'userId': 2,
      'title': 'Nhoque ao Molho Branco',
      'description': 'Nhoque de batata caseiro com molho branco cremoso.',
      'ingredients': [
        {'name': 'Batata', 'quantity': '1', 'unit': 'kg'},
        {'name': 'Farinha de trigo', 'quantity': '3', 'unit': 'xícaras'},
        {'name': 'Ovos', 'quantity': '2', 'unit': 'unidades'},
        {'name': 'Creme de leite', 'quantity': '1', 'unit': 'lata'},
        {'name': 'Queijo parmesão', 'quantity': '100', 'unit': 'g'},
      ],
      'preparationSteps': [
        'Cozinhe e amasse as batatas',
        'Misture com farinha e ovos',
        'Faça os nhoques e cozinhe em água',
        'Prepare o molho branco',
        'Misture o nhoque ao molho',
        'Finalize com queijo',
      ],
      'preparationTime': 70,
      'servings': 6,
      'difficulty': 'Médio',
      'category': 'Salgados',
      'tags': ['Italiano', 'Massa', 'Comfort food'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(days: 10)),
      'likesCount': 64,
      'commentsCount': 19,
      'savesCount': 47,
      'averageRating': 4.8,
    },

    // ===== RECEITAS DO CARLOS (userId: 3) - 2 receitas =====
    {
      'id': 9,
      'userId': 3,
      'title': 'Churrasco Completo',
      'description': 'Guia completo para fazer o churrasco perfeito.',
      'ingredients': [
        {'name': 'Picanha', 'quantity': '2', 'unit': 'kg'},
        {'name': 'Linguiça', 'quantity': '1', 'unit': 'kg'},
        {'name': 'Sal grosso', 'quantity': '200', 'unit': 'g'},
        {'name': 'Carvão', 'quantity': '5', 'unit': 'kg'},
      ],
      'preparationSteps': [
        'Tempere as carnes com sal grosso',
        'Deixe descansando por 30 minutos',
        'Prepare a churrasqueira',
        'Grelhe as carnes no ponto desejado',
        'Sirva com acompanhamentos',
      ],
      'preparationTime': 120,
      'servings': 15,
      'difficulty': 'Médio',
      'category': 'Salgados',
      'tags': ['Churrasco', 'Carne', 'Família'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(days: 4)),
      'likesCount': 105,
      'commentsCount': 34,
      'savesCount': 78,
      'averageRating': 4.9,
    },
    {
      'id': 10,
      'userId': 3,
      'title': 'Farofa Completa',
      'description': 'Farofa rica com bacon, linguiça e legumes.',
      'ingredients': [
        {'name': 'Farinha de mandioca', 'quantity': '500', 'unit': 'g'},
        {'name': 'Bacon', 'quantity': '200', 'unit': 'g'},
        {'name': 'Linguiça calabresa', 'quantity': '200', 'unit': 'g'},
        {'name': 'Cebola', 'quantity': '1', 'unit': 'unidade'},
        {'name': 'Ovos', 'quantity': '3', 'unit': 'unidades'},
      ],
      'preparationSteps': [
        'Frite o bacon e a linguiça',
        'Refogue a cebola',
        'Adicione os ovos mexidos',
        'Misture a farinha aos poucos',
        'Mexa até torrar levemente',
      ],
      'preparationTime': 30,
      'servings': 10,
      'difficulty': 'Fácil',
      'category': 'Salgados',
      'tags': ['Acompanhamento', 'Brasileiro', 'Churrasco'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(days: 7)),
      'likesCount': 71,
      'commentsCount': 16,
      'savesCount': 52,
      'averageRating': 4.8,
    },

    // ===== RECEITAS DA ANA (userId: 4) - 4 receitas =====
    {
      'id': 11,
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
        {'name': 'Nozes', 'quantity': '100', 'unit': 'g'},
      ],
      'preparationSteps': [
        'Derreta o chocolate com a manteiga',
        'Bata os ovos com o açúcar',
        'Misture o chocolate aos ovos',
        'Adicione farinha e cacau peneirados',
        'Acrescente as nozes',
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
      'id': 12,
      'userId': 4,
      'title': 'Pão de Queijo',
      'description': 'Pão de queijo mineiro tradicional, crocante por fora e macio por dentro.',
      'ingredients': [
        {'name': 'Polvilho azedo', 'quantity': '500', 'unit': 'g'},
        {'name': 'Leite', 'quantity': '1', 'unit': 'xícara'},
        {'name': 'Óleo', 'quantity': '1/2', 'unit': 'xícara'},
        {'name': 'Ovos', 'quantity': '3', 'unit': 'unidades'},
        {'name': 'Queijo meia cura', 'quantity': '200', 'unit': 'g'},
      ],
      'preparationSteps': [
        'Ferva o leite com óleo',
        'Despeje sobre o polvilho',
        'Deixe esfriar e adicione ovos',
        'Acrescente o queijo ralado',
        'Faça bolinhas',
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
      'id': 13,
      'userId': 4,
      'title': 'Mousse de Maracujá',
      'description': 'Mousse leve e refrescante de maracujá.',
      'ingredients': [
        {'name': 'Suco de maracujá', 'quantity': '1', 'unit': 'xícara'},
        {'name': 'Leite condensado', 'quantity': '1', 'unit': 'lata'},
        {'name': 'Creme de leite', 'quantity': '1', 'unit': 'lata'},
        {'name': 'Gelatina', 'quantity': '1', 'unit': 'pacote'},
      ],
      'preparationSteps': [
        'Dissolva a gelatina no suco quente',
        'Bata no liquidificador com leite condensado',
        'Adicione o creme de leite',
        'Despeje em taças',
        'Leve à geladeira por 4 horas',
      ],
      'preparationTime': 20,
      'servings': 8,
      'difficulty': 'Fácil',
      'category': 'Doces',
      'tags': ['Sobremesa', 'Refrescante', 'Festa'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(days: 9)),
      'likesCount': 73,
      'commentsCount': 17,
      'savesCount': 49,
      'averageRating': 4.8,
    },
    {
      'id': 14,
      'userId': 4,
      'title': 'Torta de Limão',
      'description': 'Torta de limão com merengue crocante.',
      'ingredients': [
        {'name': 'Biscoito maisena', 'quantity': '200', 'unit': 'g'},
        {'name': 'Manteiga', 'quantity': '100', 'unit': 'g'},
        {'name': 'Leite condensado', 'quantity': '2', 'unit': 'latas'},
        {'name': 'Suco de limão', 'quantity': '1', 'unit': 'xícara'},
        {'name': 'Claras', 'quantity': '3', 'unit': 'unidades'},
        {'name': 'Açúcar', 'quantity': '6', 'unit': 'colheres'},
      ],
      'preparationSteps': [
        'Triture o biscoito e misture com manteiga',
        'Forre a forma e leve ao forno',
        'Misture leite condensado com suco de limão',
        'Despeje sobre a base',
        'Faça o merengue com claras e açúcar',
        'Cubra e leve ao forno para dourar',
      ],
      'preparationTime': 60,
      'servings': 12,
      'difficulty': 'Médio',
      'category': 'Doces',
      'tags': ['Torta', 'Limão', 'Sobremesa'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(days: 14)),
      'likesCount': 86,
      'commentsCount': 23,
      'savesCount': 61,
      'averageRating': 4.9,
    },

    // ===== RECEITAS DO RAFAEL (userId: 5) - 2 receitas =====
    {
      'id': 15,
      'userId': 5,
      'title': 'Hambúrguer Artesanal',
      'description': 'Hambúrguer suculento feito em casa com ingredientes frescos.',
      'ingredients': [
        {'name': 'Carne moída', 'quantity': '1', 'unit': 'kg'},
        {'name': 'Pão de hambúrguer', 'quantity': '6', 'unit': 'unidades'},
        {'name': 'Queijo cheddar', 'quantity': '6', 'unit': 'fatias'},
        {'name': 'Alface', 'quantity': '1', 'unit': 'maço'},
        {'name': 'Tomate', 'quantity': '2', 'unit': 'unidades'},
        {'name': 'Bacon', 'quantity': '200', 'unit': 'g'},
      ],
      'preparationSteps': [
        'Tempere a carne e faça os hambúrgueres',
        'Grelhe em fogo alto',
        'Frite o bacon',
        'Monte: pão, carne, queijo, bacon, alface, tomate',
        'Sirva com batatas fritas',
      ],
      'preparationTime': 40,
      'servings': 6,
      'difficulty': 'Fácil',
      'category': 'Salgados',
      'tags': ['Fast food', 'Jantar', 'Lanche'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(days: 3)),
      'likesCount': 94,
      'commentsCount': 27,
      'savesCount': 71,
      'averageRating': 4.9,
    },
    {
      'id': 16,
      'userId': 5,
      'title': 'Batata Rosti',
      'description': 'Batata suíça crocante por fora e macia por dentro.',
      'ingredients': [
        {'name': 'Batata', 'quantity': '1', 'unit': 'kg'},
        {'name': 'Cebola', 'quantity': '1', 'unit': 'unidade'},
        {'name': 'Manteiga', 'quantity': '50', 'unit': 'g'},
        {'name': 'Sal e pimenta', 'quantity': 'a gosto', 'unit': ''},
      ],
      'preparationSteps': [
        'Rale as batatas e a cebola',
        'Esprema bem para retirar o excesso de água',
        'Tempere com sal e pimenta',
        'Modele em formato de disco',
        'Frite na manteiga até dourar dos dois lados',
      ],
      'preparationTime': 30,
      'servings': 4,
      'difficulty': 'Fácil',
      'category': 'Salgados',
      'tags': ['Acompanhamento', 'Batata', 'Suíço'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(days: 11)),
      'likesCount': 59,
      'commentsCount': 13,
      'savesCount': 38,
      'averageRating': 4.7,
    },

    // ===== RECEITAS DA JULIANA (userId: 6) - 3 receitas =====
    {
      'id': 17,
      'userId': 6,
      'title': 'Pizza Margherita',
      'description': 'Pizza clássica italiana com molho de tomate fresco, mussarela e manjericão.',
      'ingredients': [
        {'name': 'Massa de pizza', 'quantity': '1', 'unit': 'unidade'},
        {'name': 'Molho de tomate', 'quantity': '200', 'unit': 'g'},
        {'name': 'Mussarela', 'quantity': '250', 'unit': 'g'},
        {'name': 'Manjericão fresco', 'quantity': '1', 'unit': 'maço'},
        {'name': 'Azeite', 'quantity': '2', 'unit': 'colheres'},
      ],
      'preparationSteps': [
        'Abra a massa em formato redondo',
        'Espalhe o molho de tomate',
        'Distribua a mussarela',
        'Regue com azeite',
        'Asse a 250°C por 15 minutos',
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
      'id': 18,
      'userId': 6,
      'title': 'Suco Verde Detox',
      'description': 'Suco verde energizante e desintoxicante.',
      'ingredients': [
        {'name': 'Couve', 'quantity': '2', 'unit': 'folhas'},
        {'name': 'Limão', 'quantity': '1', 'unit': 'unidade'},
        {'name': 'Gengibre', 'quantity': '1', 'unit': 'pedaço'},
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
      'id': 19,
      'userId': 6,
      'title': 'Salada Caesar',
      'description': 'Salada clássica com molho caesar e croutons crocantes.',
      'ingredients': [
        {'name': 'Alface romana', 'quantity': '1', 'unit': 'maço'},
        {'name': 'Frango grelhado', 'quantity': '300', 'unit': 'g'},
        {'name': 'Parmesão', 'quantity': '50', 'unit': 'g'},
        {'name': 'Croutons', 'quantity': '1', 'unit': 'xícara'},
        {'name': 'Molho caesar', 'quantity': '1/2', 'unit': 'xícara'},
      ],
      'preparationSteps': [
        'Lave e corte a alface',
        'Grelhe e corte o frango em tiras',
        'Misture alface, frango e croutons',
        'Regue com molho caesar',
        'Finalize com parmesão ralado',
      ],
      'preparationTime': 25,
      'servings': 2,
      'difficulty': 'Fácil',
      'category': 'Salgados',
      'tags': ['Salada', 'Saudável', 'Almoço'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(days: 13)),
      'likesCount': 55,
      'commentsCount': 10,
      'savesCount': 34,
      'averageRating': 4.6,
    },

    // ===== RECEITAS DO PEDRO (userId: 9) - 2 receitas =====
    {
      'id': 20,
      'userId': 9,
      'title': 'Tapioca Recheada',
      'description': 'Tapioca brasileira com recheio de queijo coalho e coco.',
      'ingredients': [
        {'name': 'Goma de tapioca', 'quantity': '200', 'unit': 'g'},
        {'name': 'Queijo coalho', 'quantity': '150', 'unit': 'g'},
        {'name': 'Coco ralado', 'quantity': '100', 'unit': 'g'},
        {'name': 'Manteiga', 'quantity': '1', 'unit': 'colher'},
      ],
      'preparationSteps': [
        'Aqueça uma frigideira',
        'Coloque a goma formando um círculo',
        'Quando grudar, adicione o recheio',
        'Dobre ao meio',
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
      'id': 21,
      'userId': 9,
      'title': 'Açaí na Tigela',
      'description': 'Açaí cremoso com granola, banana e mel.',
      'ingredients': [
        {'name': 'Polpa de açaí', 'quantity': '400', 'unit': 'g'},
        {'name': 'Banana', 'quantity': '2', 'unit': 'unidades'},
        {'name': 'Granola', 'quantity': '100', 'unit': 'g'},
        {'name': 'Mel', 'quantity': '2', 'unit': 'colheres'},
        {'name': 'Morango', 'quantity': '5', 'unit': 'unidades'},
      ],
      'preparationSteps': [
        'Bata o açaí com 1 banana',
        'Despeje em tigelas',
        'Adicione granola',
        'Corte banana e morango',
        'Regue com mel',
      ],
      'preparationTime': 10,
      'servings': 2,
      'difficulty': 'Fácil',
      'category': 'Bebidas',
      'tags': ['Saudável', 'Energético', 'Brasileiro'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(days: 15)),
      'likesCount': 81,
      'commentsCount': 20,
      'savesCount': 59,
      'averageRating': 4.8,
    },

    // ===== RECEITAS DA FERNANDA (userId: 10) - 3 receitas =====
    {
      'id': 22,
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
        'Cozinhe mexendo sempre',
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
    {
      'id': 23,
      'userId': 10,
      'title': 'Panqueca Americana',
      'description': 'Panquecas fofas com calda de maple.',
      'ingredients': [
        {'name': 'Farinha de trigo', 'quantity': '2', 'unit': 'xícaras'},
        {'name': 'Leite', 'quantity': '1 1/2', 'unit': 'xícara'},
        {'name': 'Ovos', 'quantity': '2', 'unit': 'unidades'},
        {'name': 'Açúcar', 'quantity': '2', 'unit': 'colheres'},
        {'name': 'Fermento', 'quantity': '1', 'unit': 'colher'},
      ],
      'preparationSteps': [
        'Misture todos os ingredientes',
        'Deixe a massa descansar',
        'Aqueça uma frigideira',
        'Despeje porções da massa',
        'Vire quando bolhas aparecerem',
        'Sirva com mel ou maple',
      ],
      'preparationTime': 25,
      'servings': 4,
      'difficulty': 'Fácil',
      'category': 'Doces',
      'tags': ['Café da manhã', 'Americano', 'Panqueca'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(days: 16)),
      'likesCount': 68,
      'commentsCount': 15,
      'savesCount': 41,
      'averageRating': 4.7,
    },
    {
      'id': 24,
      'userId': 10,
      'title': 'Smoothie de Frutas',
      'description': 'Smoothie refrescante com frutas tropicais.',
      'ingredients': [
        {'name': 'Manga', 'quantity': '1', 'unit': 'unidade'},
        {'name': 'Morango', 'quantity': '10', 'unit': 'unidades'},
        {'name': 'Banana', 'quantity': '1', 'unit': 'unidade'},
        {'name': 'Iogurte natural', 'quantity': '1', 'unit': 'pote'},
        {'name': 'Mel', 'quantity': '1', 'unit': 'colher'},
      ],
      'preparationSteps': [
        'Corte todas as frutas',
        'Bata no liquidificador',
        'Adicione iogurte e mel',
        'Bata até ficar cremoso',
        'Sirva gelado',
      ],
      'preparationTime': 10,
      'servings': 2,
      'difficulty': 'Fácil',
      'category': 'Bebidas',
      'tags': ['Saudável', 'Refrescante', 'Frutas'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(days: 18)),
      'likesCount': 49,
      'commentsCount': 8,
      'savesCount': 27,
      'averageRating': 4.6,
    },

    // ===== RECEITA DO TESTE (userId: 7) - 1 receita =====
    {
      'id': 25,
      'userId': 7,
      'title': 'Omelete Simples',
      'description': 'Omelete básico e nutritivo para qualquer hora do dia.',
      'ingredients': [
        {'name': 'Ovos', 'quantity': '3', 'unit': 'unidades'},
        {'name': 'Queijo', 'quantity': '50', 'unit': 'g'},
        {'name': 'Tomate', 'quantity': '1', 'unit': 'unidade'},
        {'name': 'Sal e pimenta', 'quantity': 'a gosto', 'unit': ''},
      ],
      'preparationSteps': [
        'Bata os ovos com sal e pimenta',
        'Aqueça uma frigideira com óleo',
        'Despeje os ovos',
        'Adicione queijo e tomate',
        'Dobre ao meio quando firmar',
      ],
      'preparationTime': 10,
      'servings': 1,
      'difficulty': 'Fácil',
      'category': 'Salgados',
      'tags': ['Rápido', 'Café da manhã', 'Proteína'],
      'image': 'assets/images/chef.jpg',
      'createdAt': DateTime.now().subtract(Duration(days: 20)),
      'likesCount': 32,
      'commentsCount': 5,
      'savesCount': 18,
      'averageRating': 4.4,
    },
  ];

  // ✅ LIKES REALISTAS E COERENTES
  static final Map<int, List<int>> _likes = {
    1: [11, 12, 17, 15, 6, 9, 22],              // João curtiu 7 receitas
    2: [1, 2, 11, 12, 15, 17],                  // Maria curtiu 6 receitas
    3: [1, 11, 15, 6, 17, 22],                  // Carlos curtiu 6 receitas
    4: [1, 2, 6, 7, 9, 15, 17, 20, 22],         // Ana curtiu 9 receitas
    5: [11, 12, 15, 17],                        // Rafael curtiu 4 receitas
    6: [1, 2, 11, 12, 15, 9, 22],               // Juliana curtiu 7 receitas
    7: [1, 2, 11, 12, 15, 17, 6, 9, 22],        // Teste curtiu 9 receitas
    9: [1, 11, 15, 17, 6, 22],                  // Pedro curtiu 6 receitas
    10: [1, 2, 11, 15, 17, 6],                  // Fernanda curtiu 6 receitas
  };

  // ✅ SALVOS POR LIVRO - REALISTA E COERENTE
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