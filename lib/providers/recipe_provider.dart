// lib/providers/recipe_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import '../models/models.dart';
import '../services/mock_recipe_service.dart';
import 'auth_provider.dart';
import 'state_provider.dart';
import 'recipe_book_provider.dart'; // ✅ IMPORTAR

// ============================================================================
// PROVIDER DO SERVICE
// ============================================================================

final recipeServiceProvider = Provider<MockRecipeService>((ref) {
  return MockRecipeService();
});

// ============================================================================
// PROVIDER DE TODAS AS RECEITAS
// ============================================================================

final allRecipesProvider = FutureProvider<List<Recipe>>((ref) async {
  final service = ref.watch(recipeServiceProvider);
  return await service.getAllRecipes();
});

// ============================================================================
// PROVIDER DE RECEITAS DO USUÁRIO
// ============================================================================

final userRecipesProvider = FutureProvider.family<List<Recipe>, int>((ref, userId) async {
  final service = ref.watch(recipeServiceProvider);
  return await service.getUserRecipes(userId);
});

// ✅ NOVO: PROVIDER DE CONTAGEM DE RECEITAS DO USUÁRIO
final userRecipeCountProvider = FutureProvider.family<int, int>((ref, userId) async {
  final service = ref.watch(recipeServiceProvider);
  final recipes = await service.getUserRecipes(userId);
  return recipes.length;
});

// ============================================================================
// PROVIDER DE DETALHES DE UMA RECEITA
// ============================================================================

final recipeDetailProvider = FutureProvider.family<Recipe, int>((ref, recipeId) async {
  final service = ref.watch(recipeServiceProvider);
  return await service.getRecipeById(recipeId);
});

// ============================================================================
// PROVIDER DE ESTADO DE LIKE
// ============================================================================

final isRecipeLikedProvider = FutureProvider.family<bool, Map<String, int>>((ref, params) async {
  final service = ref.watch(recipeServiceProvider);
  return await service.isRecipeLiked(params['userId']!, params['recipeId']!);
});

// ============================================================================
// PROVIDER DE COMENTÁRIOS
// ============================================================================

final recipeCommentsProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, recipeId) async {
  final service = ref.watch(recipeServiceProvider);
  return await service.getRecipeComments(recipeId);
});

// ============================================================================
// NOTIFIER PARA GERENCIAR ESTADO DAS RECEITAS
// ============================================================================

class RecipesNotifier extends StateNotifier<AsyncValue<List<Recipe>>> {
  final MockRecipeService _recipeService;
  final Ref ref;

  RecipesNotifier(this._recipeService, this.ref) : super(const AsyncValue.loading()) {
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    state = const AsyncValue.loading();
    try {
      final recipes = await _recipeService.getAllRecipes();
      state = AsyncValue.data(recipes);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // ============================================================================
  // ADICIONAR RECEITA
  // ============================================================================

  Future<void> addRecipe(Recipe recipe, {Uint8List? imageBytes}) async {
    try {
      final createdRecipe = await _recipeService.createRecipe(
        recipe,
        imageBytes: imageBytes,
      );

      print('✅ Receita "${createdRecipe.title}" adicionada com sucesso!');

      // Invalidar providers para atualizar UI
      ref.invalidate(allRecipesProvider);
      ref.invalidate(userRecipesProvider(recipe.userId));
      ref.invalidate(userRecipeCountProvider(recipe.userId));
      ref.invalidate(userProfileProvider(recipe.userId));

      // Invalidar providers de estado para atualizar contagem
      ref.invalidate(stateRecipeCountsProvider);
      ref.invalidate(brazilianStatesProvider);
      if (createdRecipe.state != null && createdRecipe.state != 'Nenhum') {
        ref.invalidate(recipesByStateProvider(createdRecipe.state!));
      }

      await _loadRecipes();
    } catch (error) {
      print('❌ Erro ao adicionar receita: $error');
      rethrow;
    }
  }

  // ============================================================================
  // ATUALIZAR RECEITA
  // ============================================================================

  Future<void> updateRecipe(int recipeId, Recipe updatedRecipe, {Uint8List? imageBytes}) async {
    try {
      print('🔄 Atualizando receita $recipeId...');

      final updated = await _recipeService.updateRecipe(
        recipeId,
        updatedRecipe,
        imageBytes: imageBytes,
      );

      print('✅ Receita "${updated.title}" atualizada com sucesso!');

      // Invalidar providers para atualizar UI
      ref.invalidate(allRecipesProvider);
      ref.invalidate(userRecipesProvider(updated.userId));
      ref.invalidate(userRecipeCountProvider(updated.userId));
      ref.invalidate(userProfileProvider(updated.userId));
      ref.invalidate(recipeDetailProvider(recipeId));

      // Invalidar providers de estado
      ref.invalidate(stateRecipeCountsProvider);
      ref.invalidate(brazilianStatesProvider);
      if (updated.state != null && updated.state != 'Nenhum') {
        ref.invalidate(recipesByStateProvider(updated.state!));
      }

      await _loadRecipes();
    } catch (error) {
      print('❌ Erro ao atualizar receita: $error');
      rethrow;
    }
  }

  // ============================================================================
  // EXCLUIR RECEITA
  // ============================================================================

  Future<void> deleteRecipe(int recipeId, int userId) async {
    try {
      print('🗑️ Excluindo receita $recipeId...');

      // Buscar dados da receita antes de excluir (para invalidar providers)
      final recipe = await _recipeService.getRecipeById(recipeId);

      await _recipeService.deleteRecipe(recipeId, userId);

      print('✅ Receita excluída com sucesso!');

      // Invalidar providers para atualizar UI
      ref.invalidate(allRecipesProvider);
      ref.invalidate(userRecipesProvider(userId));
      ref.invalidate(userRecipeCountProvider(userId));
      ref.invalidate(userProfileProvider(userId));
      ref.invalidate(recipeDetailProvider(recipeId));

      // Invalidar providers de estado
      ref.invalidate(stateRecipeCountsProvider);
      ref.invalidate(brazilianStatesProvider);
      if (recipe.state != null && recipe.state != 'Nenhum') {
        ref.invalidate(recipesByStateProvider(recipe.state!));
      }

      await _loadRecipes();
    } catch (error) {
      print('❌ Erro ao excluir receita: $error');
      rethrow;
    }
  }

  // ============================================================================
  // TOGGLE LIKE
  // ============================================================================

  Future<void> toggleLike(int userId, int recipeId) async {
    try {
      final isLiked = await _recipeService.toggleLike(userId, recipeId);

      // Invalidar providers
      ref.invalidate(recipeDetailProvider(recipeId));
      ref.invalidate(allRecipesProvider);
      ref.invalidate(isRecipeLikedProvider({'userId': userId, 'recipeId': recipeId}));

      await _loadRecipes();

      print(isLiked ? '❤️ Receita curtida' : '💔 Receita descurtida');
    } catch (error) {
      print('❌ Erro ao curtir/descurtir receita: $error');
      rethrow;
    }
  }

  // ============================================================================
  // SALVAR RECEITA
  // ============================================================================

  Future<void> saveRecipe(int userId, int recipeId, String bookTitle) async {
    try {
      await _recipeService.saveRecipeToBook(userId, recipeId, bookTitle);

      // Invalidar providers
      ref.invalidate(savedRecipesProvider(userId));
      ref.invalidate(savedRecipesByBookProvider(userId));
      ref.invalidate(userRecipeBooksProvider(userId));
      ref.invalidate(isRecipeSavedProvider(RecipeSaveParams(userId: userId, recipeId: recipeId))); // ✅ USAR RecipeSaveParams

      print('💾 Receita salva no livro "$bookTitle"');
    } catch (error) {
      print('❌ Erro ao salvar receita: $error');
      rethrow;
    }
  }

  // ============================================================================
  // REMOVER RECEITA SALVA
  // ============================================================================

  Future<void> unsaveRecipe(int userId, int recipeId, String bookTitle) async {
    try {
      await _recipeService.unsaveRecipeFromBook(userId, recipeId, bookTitle);

      // Invalidar providers
      ref.invalidate(savedRecipesProvider(userId));
      ref.invalidate(savedRecipesByBookProvider(userId));
      ref.invalidate(isRecipeSavedProvider(RecipeSaveParams(userId: userId, recipeId: recipeId))); // ✅ USAR RecipeSaveParams

      print('🗑️ Receita removida do livro "$bookTitle"');
    } catch (error) {
      print('❌ Erro ao remover receita salva: $error');
      rethrow;
    }
  }

  // ============================================================================
  // CRIAR LIVRO DE RECEITAS
  // ============================================================================

  Future<void> createRecipeBook(int userId, String bookName) async {
    try {
      await _recipeService.createRecipeBook(userId, bookName);

      // Invalidar providers
      ref.invalidate(userRecipeBooksProvider(userId));
      ref.invalidate(savedRecipesByBookProvider(userId));

      print('📚 Livro "$bookName" criado');
    } catch (error) {
      print('❌ Erro ao criar livro: $error');
      rethrow;
    }
  }

  // ============================================================================
  // COMENTÁRIOS
  // ============================================================================

  Future<void> addComment({
    required int recipeId,
    required int userId,
    required String text,
    int? replyToId,
  }) async {
    try {
      await _recipeService.addComment(
        recipeId: recipeId,
        userId: userId,
        text: text,
        replyToId: replyToId,
      );

      // Invalidar providers
      ref.invalidate(recipeCommentsProvider(recipeId));
      ref.invalidate(recipeDetailProvider(recipeId));

      print('💬 Comentário adicionado');
    } catch (error) {
      print('❌ Erro ao adicionar comentário: $error');
      rethrow;
    }
  }

  Future<void> toggleCommentLike(int recipeId, int commentId, int userId, {int? parentCommentId}) async {
    try {
      await _recipeService.toggleCommentLike(recipeId, commentId, userId, parentCommentId: parentCommentId);

      // Invalidar providers
      ref.invalidate(recipeCommentsProvider(recipeId));

      print('👍 Like no comentário');
    } catch (error) {
      print('❌ Erro ao curtir comentário: $error');
      rethrow;
    }
  }
}

// ============================================================================
// PROVIDER PRINCIPAL
// ============================================================================

final recipesProvider = StateNotifierProvider<RecipesNotifier, AsyncValue<List<Recipe>>>((ref) {
  final service = ref.watch(recipeServiceProvider);
  return RecipesNotifier(service, ref);
});