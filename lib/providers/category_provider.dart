// lib/providers/category_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/mock_recipe_service.dart';

class CategoryData {
  final String name;
  final int recipesCount;
  final String emoji;
  final int color;
  final String type;

  CategoryData({
    required this.name,
    required this.recipesCount,
    required this.emoji,
    required this.color,
    this.type = 'custom',
  });
}

// ============================================================================
// CATEGORIAS PREDEFINIDAS
// ============================================================================

class PredefinedCategories {
  static const Map<String, Map<String, dynamic>> restrictions = {
    'Zero Glúten': {'emoji': '🌾', 'color': 0xFFFDD835},
    'Zero Lactose': {'emoji': '🥛', 'color': 0xFF42A5F5},
    'Vegano': {'emoji': '🌱', 'color': 0xFF66BB6A},
    'Vegetariano': {'emoji': '🥗', 'color': 0xFF7CB342},
    'Sem Açúcar': {'emoji': '🚫', 'color': 0xFFEF5350},
  };

  static const Map<String, Map<String, dynamic>> cuisines = {
    'Brasileiro': {'emoji': '🇧🇷', 'color': 0xFFFDD835},
    'Italiano': {'emoji': '🍕', 'color': 0xFFFF5722},
    'Japonês': {'emoji': '🍱', 'color': 0xFFE91E63},
    'Mexicano': {'emoji': '🌮', 'color': 0xFFFF9800},
    'Chinês': {'emoji': '🥢', 'color': 0xFFF44336},
    'Árabe': {'emoji': '🧆', 'color': 0xFFAB47BC},
  };

  static const Map<String, Map<String, dynamic>> meals = {
    'Café da Manhã': {'emoji': '☕', 'color': 0xFFFF7043},
    'Almoço': {'emoji': '🍽️', 'color': 0xFF5C6BC0},
    'Jantar': {'emoji': '🌙', 'color': 0xFF3F51B5},
    'Lanche': {'emoji': '🍪', 'color': 0xFFFFB74D},
    'Sobremesa': {'emoji': '🍨', 'color': 0xFFAB47BC},
  };

  static const Map<String, Map<String, dynamic>> occasions = {
    'Junina': {'emoji': '🎉', 'color': 0xFFFA9500},
    'Natal': {'emoji': '🎄', 'color': 0xFFF44336},
    'Páscoa': {'emoji': '🐰', 'color': 0xFFAB47BC},
    'Festa': {'emoji': '🎊', 'color': 0xFFEC407A},
    'Aniversário': {'emoji': '🎂', 'color': 0xFFFF4081},
  };

  static const Map<String, Map<String, dynamic>> general = {
    'Doces': {'emoji': '🍰', 'color': 0xFFE91E63},
    'Salgados': {'emoji': '🥐', 'color': 0xFF7CB342},
    'Bebidas': {'emoji': '🧃', 'color': 0xFF00BCD4},
    'Petiscos': {'emoji': '🍿', 'color': 0xFFFFB300},
    'Massas': {'emoji': '🍝', 'color': 0xFFFF6F00},
    'Carnes': {'emoji': '🥩', 'color': 0xFFD32F2F},
    'Peixes': {'emoji': '🐟', 'color': 0xFF0288D1},
    'Saladas': {'emoji': '🥗', 'color': 0xFF66BB6A},
    'Sopas': {'emoji': '🍲', 'color': 0xFFFFA726},
  };

  static Map<String, Map<String, dynamic>> getAll() {
    return {
      ...restrictions,
      ...cuisines,
      ...meals,
      ...occasions,
      ...general,
    };
  }
}

// ============================================================================
// PROVIDER DO SERVICE (SEM CONFLITO)
// ============================================================================

final recipeServiceProviderForCategories = Provider<MockRecipeService>((ref) {
  return MockRecipeService();
});

// ============================================================================
// PROVIDER DE CATEGORIAS COM CONTAGEM
// ============================================================================

final categoriesWithCountProvider = FutureProvider<List<CategoryData>>((ref) async {
  final recipeService = ref.watch(recipeServiceProviderForCategories);
  final allRecipes = await recipeService.getAllRecipes();

  final predefinedCategories = PredefinedCategories.getAll();

  final Map<String, int> categoryCounts = {};

  for (final recipe in allRecipes) {
    final categories = (recipe.category ?? 'Outros')
        .split(' - ')
        .map((c) => c.trim())
        .where((c) => c.isNotEmpty)
        .toList();

    for (final category in categories) {
      categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
    }
  }

  final categories = categoryCounts.entries
      .map((entry) {
    final predefined = predefinedCategories[entry.key];
    return CategoryData(
      name: entry.key,
      recipesCount: entry.value,
      emoji: predefined?['emoji'] ?? '🍴',
      color: predefined?['color'] ?? 0xFF9E9E9E,
      type: predefined != null ? 'predefined' : 'custom',
    );
  })
      .toList()
    ..sort((a, b) => b.recipesCount.compareTo(a.recipesCount));

  return categories;
});

// ============================================================================
// PROVIDER PARA CATEGORIAS SELECIONÁVEIS
// ============================================================================

final availableCategoriesProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final allCategories = PredefinedCategories.getAll();

  return allCategories.entries.map((entry) {
    return {
      'name': entry.key,
      'emoji': entry.value['emoji'],
      'color': entry.value['color'],
    };
  }).toList();
});