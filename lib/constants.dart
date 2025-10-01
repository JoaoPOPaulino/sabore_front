// constants.dart

// ========== URL BASE DA API ==========
// Escolha a URL apropriada para seu ambiente:

// Android Emulator (acessa localhost da máquina host)
// const String apiUrl = 'http://10.0.2.2:8000/api';

// iOS Simulator ou Web
// const String apiUrl = 'http://localhost:8000/api';

const bool USE_MOCK_SERVICES = true;

// Dispositivo físico (use o IP da sua máquina na rede local)
const String apiUrl = 'http://192.168.15.68:8000/api';



// Produção
// const String apiUrl = 'https://sua-api.com/api';

// ========== ENDPOINTS ==========
class ApiEndpoints {
  // Auth
  static const String login = '/auth/login/';
  static const String register = '/auth/register/';
  static const String logout = '/auth/logout/';
  static const String profile = '/auth/profile/';
  static const String refreshToken = '/auth/refresh/';

  // Users
  static const String users = '/users/';
  static const String updateProfile = '/users/profile/';

  // Recipes
  static const String recipes = '/recipes/';
  static const String recipeDetail = '/recipes/{id}/';
  static const String userRecipes = '/recipes/user/{userId}/';
  static const String searchRecipes = '/recipes/search/';

  // Recipe Books
  static const String recipeBooks = '/recipe-books/';
  static const String recipeBookDetail = '/recipe-books/{id}/';
  static const String addRecipeToBook = '/recipe-books/{id}/add-recipe/';

  // Categories
  static const String categories = '/categories/';

  // Reviews
  static const String reviews = '/reviews/';
  static const String recipeReviews = '/recipes/{id}/reviews/';

  // Notifications
  static const String notifications = '/notifications/';

  // Search
  static const String search = '/search/';
}

// ========== CONFIGURAÇÕES ==========
class ApiConfig {
  static const Duration timeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Headers
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
}

// ========== STORAGE KEYS ==========
class StorageKeys {
  static const String jwt = 'jwt';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String isFirstLogin = 'isFirstLogin';
  static const String userEmail = 'user_email';
}