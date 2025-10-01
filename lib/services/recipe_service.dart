import '../constants.dart';
import '../models/recipe.dart';
import 'api_service.dart';

class RecipeService {
  final ApiService _apiService = ApiService();

  /// Listar receitas com filtros
  Future<List<Recipe>> getRecipes({
    String? category,
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'page_size': pageSize,
      };

      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _apiService.get(
        ApiEndpoints.recipes,
        queryParameters: queryParams,
      );

      // Suporta paginação ou lista simples
      final List<dynamic> results = response.data is Map
          ? (response.data['results'] ?? [])
          : response.data;

      return results.map((json) => Recipe.fromJson(json)).toList();
    } catch (e) {
      print('❌ Get recipes error: $e');
      rethrow;
    }
  }

  /// Obter receita por ID
  Future<Recipe> getRecipeById(int id) async {
    try {
      final endpoint = ApiEndpoints.recipeDetail.replaceAll('{id}', id.toString());
      final response = await _apiService.get(endpoint);
      return Recipe.fromJson(response.data);
    } catch (e) {
      print('❌ Get recipe error: $e');
      rethrow;
    }
  }

  /// Criar nova receita
  Future<Recipe> createRecipe(Recipe recipe) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.recipes,
        data: recipe.toJson(),
      );
      print('✅ Recipe created');
      return Recipe.fromJson(response.data);
    } catch (e) {
      print('❌ Create recipe error: $e');
      rethrow;
    }
  }

  /// Atualizar receita
  Future<Recipe> updateRecipe(int id, Recipe recipe) async {
    try {
      final endpoint = ApiEndpoints.recipeDetail.replaceAll('{id}', id.toString());
      final response = await _apiService.put(
        endpoint,
        data: recipe.toJson(),
      );
      print('✅ Recipe updated');
      return Recipe.fromJson(response.data);
    } catch (e) {
      print('❌ Update recipe error: $e');
      rethrow;
    }
  }

  /// Deletar receita
  Future<void> deleteRecipe(int id) async {
    try {
      final endpoint = ApiEndpoints.recipeDetail.replaceAll('{id}', id.toString());
      await _apiService.delete(endpoint);
      print('✅ Recipe deleted');
    } catch (e) {
      print('❌ Delete recipe error: $e');
      rethrow;
    }
  }

  /// Receitas do usuário
  Future<List<Recipe>> getUserRecipes(int userId) async {
    try {
      final endpoint = ApiEndpoints.userRecipes.replaceAll('{userId}', userId.toString());
      final response = await _apiService.get(endpoint);

      final List<dynamic> results = response.data is Map
          ? (response.data['results'] ?? [])
          : response.data;

      return results.map((json) => Recipe.fromJson(json)).toList();
    } catch (e) {
      print('❌ Get user recipes error: $e');
      rethrow;
    }
  }

  /// Curtir receita
  Future<void> likeRecipe(int id) async {
    try {
      await _apiService.post('/recipes/$id/like/');
      print('✅ Recipe liked');
    } catch (e) {
      print('❌ Like recipe error: $e');
      rethrow;
    }
  }

  /// Descurtir receita
  Future<void> unlikeRecipe(int id) async {
    try {
      await _apiService.delete('/recipes/$id/like/');
      print('✅ Recipe unliked');
    } catch (e) {
      print('❌ Unlike recipe error: $e');
      rethrow;
    }
  }

  /// Salvar receita
  Future<void> saveRecipe(int id) async {
    try {
      await _apiService.post('/recipes/$id/save/');
      print('✅ Recipe saved');
    } catch (e) {
      print('❌ Save recipe error: $e');
      rethrow;
    }
  }

  /// Upload de imagem da receita
  Future<String> uploadRecipeImage(String filePath) async {
    try {
      final response = await _apiService.uploadFile(
        '/recipes/upload-image/',
        filePath,
        'image',
      );
      print('✅ Recipe image uploaded');
      return response.data['image_url'];
    } catch (e) {
      print('❌ Upload recipe image error: $e');
      rethrow;
    }
  }
}

class RecipeBookService {
  final ApiService _apiService = ApiService();

  /// Listar livros de receitas
  Future<List<RecipeBook>> getRecipeBooks() async {
    try {
      final response = await _apiService.get(ApiEndpoints.recipeBooks);

      final List<dynamic> results = response.data is Map
          ? (response.data['results'] ?? [])
          : response.data;

      return results.map((json) => RecipeBook.fromJson(json)).toList();
    } catch (e) {
      print('❌ Get recipe books error: $e');
      rethrow;
    }
  }

  /// Criar livro de receitas
  Future<RecipeBook> createRecipeBook(RecipeBook book) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.recipeBooks,
        data: book.toJson(),
      );
      print('✅ Recipe book created');
      return RecipeBook.fromJson(response.data);
    } catch (e) {
      print('❌ Create recipe book error: $e');
      rethrow;
    }
  }

  /// Adicionar receita ao livro
  Future<void> addRecipeToBook(int bookId, int recipeId) async {
    try {
      final endpoint = ApiEndpoints.addRecipeToBook
          .replaceAll('{id}', bookId.toString());

      await _apiService.post(
        endpoint,
        data: {'recipe_id': recipeId},
      );
      print('✅ Recipe added to book');
    } catch (e) {
      print('❌ Add recipe to book error: $e');
      rethrow;
    }
  }

  /// Remover receita do livro
  Future<void> removeRecipeFromBook(int bookId, int recipeId) async {
    try {
      await _apiService.delete(
        '/recipe-books/$bookId/recipes/$recipeId/',
      );
      print('✅ Recipe removed from book');
    } catch (e) {
      print('❌ Remove recipe from book error: $e');
      rethrow;
    }
  }

  /// Obter receitas de um livro
  Future<List<Recipe>> getBookRecipes(int bookId) async {
    try {
      final response = await _apiService.get(
        '/recipe-books/$bookId/recipes/',
      );

      final List<dynamic> results = response.data is Map
          ? (response.data['results'] ?? [])
          : response.data;

      return results.map((json) => Recipe.fromJson(json)).toList();
    } catch (e) {
      print('❌ Get book recipes error: $e');
      rethrow;
    }
  }
}

class ReviewService {
  final ApiService _apiService = ApiService();

  /// Listar avaliações de uma receita
  Future<List<Review>> getRecipeReviews(int recipeId) async {
    try {
      final endpoint = ApiEndpoints.recipeReviews
          .replaceAll('{id}', recipeId.toString());

      final response = await _apiService.get(endpoint);

      final List<dynamic> results = response.data is Map
          ? (response.data['results'] ?? [])
          : response.data;

      return results.map((json) => Review.fromJson(json)).toList();
    } catch (e) {
      print('❌ Get reviews error: $e');
      rethrow;
    }
  }

  /// Criar avaliação
  Future<Review> createReview(Review review) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.reviews,
        data: review.toJson(),
      );
      print('✅ Review created');
      return Review.fromJson(response.data);
    } catch (e) {
      print('❌ Create review error: $e');
      rethrow;
    }
  }
}