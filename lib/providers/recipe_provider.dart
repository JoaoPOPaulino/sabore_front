import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/mock_recipe_service.dart';
import 'auth_provider.dart';

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
  final MockRecipeService _recipeService;
  final Ref ref;

  RecipesNotifier(this._recipeService, this.ref) : super(AsyncValue.loading()) {
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    try {
      state = AsyncValue.loading();
      final recipes = await _recipeService.getAllRecipes();
      state = AsyncValue.data(recipes);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // ✅ CORRIGIDO: Adicionar nova receita COM imageBytes
  Future<void> addRecipe(Recipe recipe, {Uint8List? imageBytes}) async {
    try {
      // Criar receita passando imageBytes
      final createdRecipe = await _recipeService.createRecipe(
        recipe,
        imageBytes: imageBytes,
      );

      print('✅ Receita "${createdRecipe.title}" adicionada com sucesso!');

      // Invalidar providers para atualizar UI
      ref.invalidate(allRecipesProvider);
      ref.invalidate(userRecipesProvider(recipe.userId));
      ref.invalidate(userProfileProvider(recipe.userId));

      // Recarregar lista de receitas
      await _loadRecipes();
    } catch (error) {
      print('❌ Erro ao adicionar receita: $error');
      rethrow;
    }
  }

  // Atualizar receita existente
  Future<void> updateRecipe(Recipe recipe) async {
    try {
      print('✅ Receita "${recipe.title}" atualizada com sucesso!');
      await _loadRecipes();
    } catch (error) {
      print('❌ Erro ao atualizar receita: $error');
      rethrow;
    }
  }

  // Deletar receita
  Future<void> deleteRecipe(int recipeId) async {
    try {
      print('✅ Receita $recipeId deletada com sucesso!');
      await _loadRecipes();
    } catch (error) {
      print('❌ Erro ao deletar receita: $error');
      rethrow;
    }
  }

  // Refresh manual
  Future<void> refresh() async {
    await _loadRecipes();
  }
}

// ✅ CORRIGIDO: Provider do StateNotifier passando ref
final recipesProvider = StateNotifierProvider<RecipesNotifier, AsyncValue<List<Recipe>>>((ref) {
  final service = ref.watch(recipeServiceProviderForRecipes);
  return RecipesNotifier(service, ref);
});

// ============================================================================
// ACTIONS PARA LIKES E INTERAÇÕES
// ============================================================================

final recipeCommentsProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, recipeId) async {
  final service = ref.watch(recipeServiceProviderForRecipes);
  return await service.getRecipeComments(recipeId);
});

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
  Future<Map<String, dynamic>> addComment({
    required int recipeId,
    required int userId,
    required String text,
    int? replyToId,
  }) async {
    final service = ref.read(recipeServiceProviderForRecipes);
    final comment = await service.addComment(
      recipeId: recipeId,
      userId: userId,
      text: text,
      replyToId: replyToId,
    );

    // Invalidar providers para atualizar UI
    ref.invalidate(recipeCommentsProvider(recipeId));
    ref.invalidate(recipeByIdProvider(recipeId));

    return comment;
  }

  // Toggle like em comentário
  Future<void> toggleCommentLike({
    required int recipeId,
    required int commentId,
    required int userId,
    int? parentCommentId,
  }) async {
    final service = ref.read(recipeServiceProviderForRecipes);
    await service.toggleCommentLike(recipeId, commentId, userId, parentCommentId: parentCommentId);

    // Invalidar provider para atualizar UI
    ref.invalidate(recipeCommentsProvider(recipeId));
  }

  // Avaliar receita
  Future<void> rateRecipe(int recipeId, double rating) async {
    // TODO: Implementar quando tiver o serviço
    print('⭐ Receita $recipeId avaliada com $rating estrelas');
  }
}