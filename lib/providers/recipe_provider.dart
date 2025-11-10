import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sabore_app/services/mock_recipe_service.dart';
import '../models/models.dart';
import '../services/recipe_service.dart';
import '../constants.dart';

// Providers de serviços
final recipeServiceProvider = Provider<dynamic>((ref) {
  return USE_MOCK_SERVICES ? MockRecipeService() : RecipeService();
});

final recipeBookServiceProvider = Provider((ref) => MockRecipeBookService());
final reviewServiceProvider = Provider((ref) => MockReviewService());

// ========== ESTADO DAS RECEITAS (Notifier) ==========
class RecipesState {
  final List<Recipe> recipes;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasMore;

  RecipesState({
    this.recipes = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
  });

  RecipesState copyWith({
    List<Recipe>? recipes,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return RecipesState(
      recipes: recipes ?? this.recipes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class RecipesNotifier extends StateNotifier<RecipesState> {
  final dynamic _recipeService;

  RecipesNotifier(this._recipeService) : super(RecipesState());

  Future<void> loadRecipes({
    String? category,
    String? search,
    bool refresh = false,
  }) async {
    if (refresh) {
      state = RecipesState(isLoading: true);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }
    try {
      final recipes = await _recipeService.getRecipes(
        category: category,
        search: search,
        page: refresh ? 1 : state.currentPage,
      );
      if (refresh) {
        state = state.copyWith(
          recipes: recipes,
          isLoading: false,
          currentPage: 1,
          hasMore: recipes.isNotEmpty,
        );
      } else {
        state = state.copyWith(
          recipes: [...state.recipes, ...recipes],
          isLoading: false,
          currentPage: state.currentPage + 1,
          hasMore: recipes.isNotEmpty,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    try {
      final newRecipe = await _recipeService.createRecipe(recipe);
      state = state.copyWith(
        recipes: [newRecipe, ...state.recipes],
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> updateRecipe(int id, Recipe recipe) async {
    try {
      final updatedRecipe = await _recipeService.updateRecipe(id, recipe);
      final List<Recipe> updatedList = state.recipes.map<Recipe>((r) {
        return r.id == id ? updatedRecipe : r;
      }).toList();
      state = state.copyWith(recipes: updatedList);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> deleteRecipe(int id) async {
    try {
      await _recipeService.deleteRecipe(id);
      final updatedList = state.recipes.where((r) => r.id != id).toList();
      state = state.copyWith(recipes: updatedList);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> toggleLike(int id) async {
    final originalList = state.recipes;
    final updatedList = state.recipes.map((r) {
      if (r.id == id) {
        return r.copyWith(
          isLiked: !r.isLiked,
          likesCount: r.isLiked ? r.likesCount - 1 : r.likesCount + 1,
        );
      }
      return r;
    }).toList();
    state = state.copyWith(recipes: updatedList);

    try {
      final recipe = updatedList.firstWhere((r) => r.id == id);
      if (recipe.isLiked) {
        await _recipeService.likeRecipe(id);
      } else {
        await _recipeService.unlikeRecipe(id);
      }
    } catch (e) {
      state = state.copyWith(recipes: originalList, error: e.toString());
    }
  }
}

final recipesProvider = StateNotifierProvider<RecipesNotifier, RecipesState>((ref) {
  final service = ref.watch(recipeServiceProvider);
  return RecipesNotifier(service);
});

// ========== PROVIDERS DE LEITURA (Future) ==========

final recipeDetailProvider = FutureProvider.autoDispose.family<Recipe, int>((ref, id) async {
  final service = ref.watch(recipeServiceProvider);
  return await service.getRecipeById(id);
});

final userRecipesProvider = FutureProvider.autoDispose.family<List<Recipe>, int>((ref, userId) async {
  final service = ref.watch(recipeServiceProvider);
  return await service.getUserRecipes(userId);
});

// ========== PROVIDERS MOCKADOS (Exemplo) ==========
class MockRecipeBookService {
  Future<List<RecipeBook>> getRecipeBooks() async => [];
  Future<void> addRecipeToBook(int bookId, int recipeId) async {}
}
class MockReviewService {
  Future<List<Review>> getRecipeReviews(int recipeId) async => [];
}

final recipeBooksProvider = FutureProvider<List<RecipeBook>>((ref) async {
  return ref.watch(recipeBookServiceProvider).getRecipeBooks();
});

final recipeReviewsProvider = FutureProvider.family<List<Review>, int>((ref, recipeId) async {
  return ref.watch(reviewServiceProvider).getRecipeReviews(recipeId);
});