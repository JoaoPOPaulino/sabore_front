import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';

// Providers de serviços
final recipeServiceProvider = Provider((ref) => RecipeService());
final recipeBookServiceProvider = Provider((ref) => RecipeBookService());
final reviewServiceProvider = Provider((ref) => ReviewService());

// ========== ESTADO DAS RECEITAS ==========
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

// ========== NOTIFIER DE RECEITAS ==========
class RecipesNotifier extends StateNotifier<RecipesState> {
  final RecipeService _recipeService;

  RecipesNotifier(this._recipeService) : super(RecipesState());

  /// Carregar receitas
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
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Adicionar receita
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

  /// Atualizar receita
  Future<void> updateRecipe(int id, Recipe recipe) async {
    try {
      final updatedRecipe = await _recipeService.updateRecipe(id, recipe);
      final updatedList = state.recipes.map((r) {
        return r.id == id ? updatedRecipe : r;
      }).toList();
      state = state.copyWith(recipes: updatedList);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// Deletar receita
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

  /// Toggle curtir receita
  Future<void> toggleLike(int id) async {
    // Atualiza UI otimisticamente
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

    // Faz a chamada à API
    try {
      final recipe = state.recipes.firstWhere((r) => r.id == id);
      if (recipe.isLiked) {
        await _recipeService.likeRecipe(id);
      } else {
        await _recipeService.unlikeRecipe(id);
      }
    } catch (e) {
      // Reverte se falhar
      final revertedList = state.recipes.map((r) {
        if (r.id == id) {
          return r.copyWith(
            isLiked: !r.isLiked,
            likesCount: r.isLiked ? r.likesCount + 1 : r.likesCount - 1,
          );
        }
        return r;
      }).toList();
      state = state.copyWith(recipes: revertedList, error: e.toString());
    }
  }

  /// Toggle salvar receita
  Future<void> toggleSave(int id) async {
    final updatedList = state.recipes.map((r) {
      if (r.id == id) {
        return r.copyWith(isSaved: !r.isSaved);
      }
      return r;
    }).toList();
    state = state.copyWith(recipes: updatedList);

    try {
      await _recipeService.saveRecipe(id);
    } catch (e) {
      // Reverte se falhar
      final revertedList = state.recipes.map((r) {
        if (r.id == id) {
          return r.copyWith(isSaved: !r.isSaved);
        }
        return r;
      }).toList();
      state = state.copyWith(recipes: revertedList, error: e.toString());
    }
  }
}

// Provider principal de receitas
final recipesProvider = StateNotifierProvider<RecipesNotifier, RecipesState>((ref) {
  final service = ref.watch(recipeServiceProvider);
  return RecipesNotifier(service);
});

// ========== PROVIDER PARA RECEITA ESPECÍFICA ==========
final recipeDetailProvider = FutureProvider.family<Recipe, int>((ref, id) async {
  final service = ref.watch(recipeServiceProvider);
  return await service.getRecipeById(id);
});

// ========== PROVIDER PARA RECEITAS DO USUÁRIO ==========
final userRecipesProvider = FutureProvider.family<List<Recipe>, int>((ref, userId) async {
  final service = ref.watch(recipeServiceProvider);
  return await service.getUserRecipes(userId);
});

// ========== ESTADO DOS LIVROS DE RECEITAS ==========
class RecipeBooksState {
  final List<RecipeBook> books;
  final bool isLoading;
  final String? error;

  RecipeBooksState({
    this.books = const [],
    this.isLoading = false,
    this.error,
  });

  RecipeBooksState copyWith({
    List<RecipeBook>? books,
    bool? isLoading,
    String? error,
  }) {
    return RecipeBooksState(
      books: books ?? this.books,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// ========== NOTIFIER DE LIVROS DE RECEITAS ==========
class RecipeBooksNotifier extends StateNotifier<RecipeBooksState> {
  final RecipeBookService _service;

  RecipeBooksNotifier(this._service) : super(RecipeBooksState());

  Future<void> loadBooks() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final books = await _service.getRecipeBooks();
      state = state.copyWith(books: books, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createBook(RecipeBook book) async {
    try {
      final newBook = await _service.createRecipeBook(book);
      state = state.copyWith(books: [...state.books, newBook]);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> addRecipeToBook(int bookId, int recipeId) async {
    try {
      await _service.addRecipeToBook(bookId, recipeId);
      // Recarrega os livros para atualizar a contagem
      await loadBooks();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }
}

final recipeBooksProvider = StateNotifierProvider<RecipeBooksNotifier, RecipeBooksState>((ref) {
  final service = ref.watch(recipeBookServiceProvider);
  return RecipeBooksNotifier(service);
});

// ========== PROVIDER PARA REVIEWS ==========
final recipeReviewsProvider = FutureProvider.family<List<Review>, int>((ref, recipeId) async {
  final service = ref.watch(reviewServiceProvider);
  return await service.getRecipeReviews(recipeId);
});