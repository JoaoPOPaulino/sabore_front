import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/mock_recipe_service.dart';
import '../models/models.dart';
import 'auth_provider.dart';

final recipeServiceProvider = Provider<MockRecipeService>((ref) {
  return MockRecipeService();
});

final userRecipeBooksProvider = FutureProvider.autoDispose.family<List<String>, int>((ref, userId) async {
  final recipeService = ref.watch(recipeServiceProvider);
  return await recipeService.getUserRecipeBooks(userId);
});

final savedRecipesProvider = FutureProvider.autoDispose.family<List<Recipe>, int>((ref, userId) async {
  final recipeService = ref.watch(recipeServiceProvider);
  return await recipeService.getSavedRecipes(userId);
});

final savedRecipesByBookProvider = FutureProvider.autoDispose.family<Map<String, List<Recipe>>, int>((ref, userId) async {
  final recipeService = ref.watch(recipeServiceProvider);
  return await recipeService.getSavedRecipesByBook(userId);
});

final isRecipeSavedProvider = FutureProvider.autoDispose.family<bool, RecipeSaveParams>((ref, params) async {
  final recipeService = ref.watch(recipeServiceProvider);
  return await recipeService.isRecipeSaved(params.userId, params.recipeId);
});

class RecipeSaveParams {
  final int userId;
  final int recipeId;

  RecipeSaveParams({required this.userId, required this.recipeId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RecipeSaveParams &&
              runtimeType == other.runtimeType &&
              userId == other.userId &&
              recipeId == other.recipeId;

  @override
  int get hashCode => userId.hashCode ^ recipeId.hashCode;
}

final recipeBookActionsProvider = Provider<RecipeBookActions>((ref) {
  return RecipeBookActions(ref);
});

class RecipeBookActions {
  final Ref ref;

  RecipeBookActions(this.ref);

  Future<void> saveRecipe(int userId, int recipeId, String bookTitle) async {
    final recipeService = ref.read(recipeServiceProvider);
    await recipeService.saveRecipeToBook(userId, recipeId, bookTitle);

    ref.invalidate(savedRecipesProvider(userId));
    ref.invalidate(savedRecipesByBookProvider(userId));
    ref.invalidate(isRecipeSavedProvider(RecipeSaveParams(userId: userId, recipeId: recipeId)));
  }

  Future<void> unsaveRecipe(int userId, int recipeId, String bookTitle) async {
    final recipeService = ref.read(recipeServiceProvider);
    await recipeService.unsaveRecipeFromBook(userId, recipeId, bookTitle);

    ref.invalidate(savedRecipesProvider(userId));
    ref.invalidate(savedRecipesByBookProvider(userId));
    ref.invalidate(isRecipeSavedProvider(RecipeSaveParams(userId: userId, recipeId: recipeId)));
  }

  Future<void> createBook(int userId, String bookName) async {
    final recipeService = ref.read(recipeServiceProvider);
    await recipeService.createRecipeBook(userId, bookName);

    ref.invalidate(userRecipeBooksProvider(userId));
  }
}