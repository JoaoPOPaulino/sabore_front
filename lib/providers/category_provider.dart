// lib/providers/category_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/mock_recipe_service.dart';
import 'recipe_provider.dart';

class CategoryData {
  final String name;
  final int recipesCount;
  final String emoji;
  final int color; // Color value

  CategoryData({
    required this.name,
    required this.recipesCount,
    required this.emoji,
    required this.color,
  });
}

final categoriesWithCountProvider = FutureProvider<List<CategoryData>>((ref) async {
  final recipeService = ref.watch(recipeServiceProviderForRecipes);
  final allRecipes = await recipeService.getAllRecipes();

  // Mapear cores para cada categoria
  final categoryColors = {
    'Doces': 0xFFE91E63,
    'Salgados': 0xFF7CB342,
    'Bebidas': 0xFF00BCD4,
    'Junina': 0xFFFA9500,
    'Italiano': 0xFFFF5722,
    'Brasileiro': 0xFFFDD835,
    'Sobremesa': 0xFFAB47BC,
    'Café da manhã': 0xFFFF7043,
    'Jantar': 0xFF5C6BC0,
    'Festa': 0xFFEC407A,
  };

  // Emojis para cada categoria
  final categoryEmojis = {
    'Doces': '🍰',
    'Salgados': '🥐',
    'Bebidas': '🧃',
    'Junina': '🎉',
    'Italiano': '🍕',
    'Brasileiro': '🇧🇷',
    'Sobremesa': '🍨',
    'Café da manhã': '☕',
    'Jantar': '🍽️',
    'Festa': '🎊',
  };

  // Contar receitas por categoria
  final Map<String, int> categoryCounts = {};
  for (final recipe in allRecipes) {
    final category = recipe.category ?? 'Outros';
    categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
  }

  // Converter para lista e ordenar por quantidade (maior para menor)
  final categories = categoryCounts.entries
      .map((entry) => CategoryData(
    name: entry.key,
    recipesCount: entry.value,
    emoji: categoryEmojis[entry.key] ?? '🍴',
    color: categoryColors[entry.key] ?? 0xFF9E9E9E,
  ))
      .toList()
    ..sort((a, b) => b.recipesCount.compareTo(a.recipesCount));

  return categories;
});