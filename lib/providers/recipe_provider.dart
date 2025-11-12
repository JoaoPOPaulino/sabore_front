import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/mock_recipe_service.dart';

// ============================================================================
// PROVIDERS DE SERVIÇO
// ============================================================================

final recipeServiceProviderForRecipes = Provider<MockRecipeService>((ref) {
  return MockRecipeService();
});

// Alias para compatibilidade com add_recipe_screen
final recipeServiceProvider = Provider<MockRecipeService>((ref) {
  return MockRecipeService();
});

// ============================================================================
// PROVIDERS DE CONSULTA (FutureProvider)
// ============================================================================

// Provider para todas as receitas
final allRecipesProvider = FutureProvider<List<Recipe>>((ref) async {
  final service = ref.watch(recipeServiceProviderForRecipes);
  return await service.getAllRecipes();
});

// Provider para receitas de um usuário específico
final userRecipesProvider = FutureProvider.family<List<Recipe>, int>((ref, userId) async {
  final service = ref.watch(recipeServiceProviderForRecipes);
  return await service.getUserRecipes(userId);
});

// Provider para uma receita específica
final recipeByIdProvider = FutureProvider.family<Recipe, int>((ref, recipeId) async {
  final service = ref.watch(recipeServiceProviderForRecipes);
  return await service.getRecipeById(recipeId);
});

// Provider para contar receitas por usuário (dados reais)
final userRecipeCountProvider = FutureProvider.family<int, int>((ref, userId) async {
  final recipes = await ref.watch(userRecipesProvider(userId).future);
  return recipes.length;
});

// ============================================================================
// CLASSES DE PARÂMETROS
// ============================================================================

// Parâmetros para verificar likes
class RecipeLikeParams {
  final int userId;
  final int recipeId;

  RecipeLikeParams({required this.userId, required this.recipeId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RecipeLikeParams &&
              runtimeType == other.runtimeType &&
              userId == other.userId &&
              recipeId == other.recipeId;

  @override
  int get hashCode => userId.hashCode ^ recipeId.hashCode;
}

// ============================================================================
// PROVIDERS DE INTERAÇÃO
// ============================================================================

// Provider para verificar se receita está curtida
final isRecipeLikedProvider = FutureProvider.family<bool, RecipeLikeParams>((ref, params) async {
  final service = ref.watch(recipeServiceProviderForRecipes);
  return await service.isRecipeLiked(params.userId, params.recipeId);
});

// ============================================================================
// STATE NOTIFIER PARA GERENCIAR LISTA DE RECEITAS
// ============================================================================

class RecipesNotifier extends StateNotifier<AsyncValue<List<Recipe>>> {
  final Ref ref;

  RecipesNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadRecipes();
  }

  // Carregar todas as receitas
  Future<void> loadRecipes() async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(recipeServiceProviderForRecipes);
      final recipes = await service.getAllRecipes();
      state = AsyncValue.data(recipes);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
      print('❌ Erro ao carregar receitas: $error');
    }
  }

  // Adicionar nova receita
  Future<void> addRecipe(Recipe recipe) async {
    try {
      // Como estamos usando mock, apenas recarregamos a lista
      // Em produção, você faria:
      // final service = ref.read(recipeServiceProviderForRecipes);
      // await service.createRecipe(recipe);

      print('✅ Receita "${recipe.title}" adicionada com sucesso!');

      // Recarregar lista de receitas
      await loadRecipes();
    } catch (error) {
      print('❌ Erro ao adicionar receita: $error');
      rethrow;
    }
  }

  // Atualizar receita existente
  Future<void> updateRecipe(Recipe recipe) async {
    try {
      print('✅ Receita "${recipe.title}" atualizada com sucesso!');
      await loadRecipes();
    } catch (error) {
      print('❌ Erro ao atualizar receita: $error');
      rethrow;
    }
  }

  // Deletar receita
  Future<void> deleteRecipe(int recipeId) async {
    try {
      print('✅ Receita $recipeId deletada com sucesso!');
      await loadRecipes();
    } catch (error) {
      print('❌ Erro ao deletar receita: $error');
      rethrow;
    }
  }

  // Refresh manual
  Future<void> refresh() async {
    await loadRecipes();
  }
}

// Provider do StateNotifier
final recipesProvider = StateNotifierProvider<RecipesNotifier, AsyncValue<List<Recipe>>>((ref) {
  return RecipesNotifier(ref);
});

// ============================================================================
// ACTIONS PARA LIKES E INTERAÇÕES
// ============================================================================

final recipeActionsProvider = Provider<RecipeActions>((ref) {
  return RecipeActions(ref);
});

class RecipeActions {
  final Ref ref;

  RecipeActions(this.ref);

  // Toggle like em uma receita
  Future<bool> toggleLike(int userId, int recipeId) async {
    final service = ref.read(recipeServiceProviderForRecipes);
    final isLiked = await service.toggleLike(userId, recipeId);

    // Invalidar providers para atualizar UI
    ref.invalidate(isRecipeLikedProvider);
    ref.invalidate(recipeByIdProvider(recipeId));

    return isLiked;
  }

  // Adicionar comentário
  Future<void> addComment(int recipeId, String comment) async {
    // TODO: Implementar quando tiver o serviço
    print('💬 Comentário adicionado na receita $recipeId: $comment');
  }

  // Avaliar receita
  Future<void> rateRecipe(int recipeId, double rating) async {
    // TODO: Implementar quando tiver o serviço
    print('⭐ Receita $recipeId avaliada com $rating estrelas');
  }
}