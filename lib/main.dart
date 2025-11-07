import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sabore_app/screens/auth/verify_email_screen.dart';
import 'package:sabore_app/screens/auth/verify_phone_screen.dart';
import 'package:sabore_app/screens/auth/forgot_password_screen.dart';
import 'package:sabore_app/screens/auth/choose_recovery_method_screen.dart';
import 'package:sabore_app/screens/auth/verify_recovery_code_screen.dart';
import 'package:sabore_app/screens/auth/reset_password_screen.dart';
import 'package:sabore_app/screens/categorie/categories_screen.dart';
import 'package:sabore_app/screens/categorie/states_screen.dart';
import 'package:sabore_app/screens/profile/profile/edit_profile_screen.dart';
import 'package:sabore_app/screens/profile/profile/notification_screen.dart';
import 'package:sabore_app/screens/profile/profile/profile_screen.dart';
import 'package:sabore_app/screens/profile/profile/recipe_books_screen.dart';
import 'package:sabore_app/screens/profile/profile/user_info_screen.dart';
import 'package:sabore_app/screens/recipe/add_recipe_screen.dart';
import 'package:sabore_app/screens/recipe/recipe_success_screen.dart';
import 'package:sabore_app/screens/search/search_screen.dart';
import 'package:sabore_app/screens/profile/profile/setting_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/create_account_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/profile/setup_profile_screen.dart';
import 'screens/profile/setup_complete_screen.dart';
import 'screens/home/home_screen.dart';
import 'providers/auth_provider.dart';
import 'screens/recipe/recipe_detail_screen.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'Saborê',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF4CAF50),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Color(0xFFFF5722),
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Montserrat',
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF5722),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFFFF3E0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      routerConfig: router,
    );
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final routerNotifier = ValueNotifier<int>(0);

  ref.listen(authProvider, (previous, next) {
    routerNotifier.value++;
  });

  ref.listen(isFirstLoginProvider, (previous, next) {
    routerNotifier.value++;
  });

  return GoRouter(
    initialLocation: '/onboarding',
    routes: [
      // Auth Routes
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => OnboardingScreen(),
      ),
      GoRoute(
        path: '/create-account',
        builder: (context, state) => CreateAccountScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => SignupScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),

      // ✅ ROTAS DE RECUPERAÇÃO DE SENHA
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/choose-recovery-method',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ChooseRecoveryMethodScreen(
            email: extra['email'],
            phone: extra['phone'],
          );
        },
      ),
      GoRoute(
        path: '/verify-recovery-code',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return VerifyRecoveryCodeScreen(
            method: extra['method'],
            email: extra['email'],
            phone: extra['phone'],
          );
        },
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ResetPasswordScreen(
            email: extra['email'],
          );
        },
      ),

      // Setup Profile Routes
      GoRoute(
        path: '/setup-profile',
        builder: (context, state) => SetupProfileScreen(),
      ),
      GoRoute(
        path: '/setup-complete',
        builder: (context, state) => SetupCompleteScreen(),
      ),

      // Verification Routes
      GoRoute(
        path: '/verify-email',
        builder: (context, state) => VerifyEmailScreen(),
      ),
      GoRoute(
        path: '/verify-phone',
        builder: (context, state) => VerifyPhoneScreen(),
      ),

      // Main App Routes
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => CategoriesScreen(),
      ),
      GoRoute(
        path: '/states',
        builder: (context, state) => StatesScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => SearchScreen(),
      ),

      // Profile Routes
      GoRoute(
        path: '/profile/:userId',
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          return ProfileScreen(userId: userId);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => EditProfileScreen(),
      ),
      GoRoute(
        path: '/user-info',
        builder: (context, state) => UserInfoScreen(),
      ),
      GoRoute(
        path: '/recipe-books',
        builder: (context, state) => RecipeBooksScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => NotificationsScreen(),
      ),

      // Recipe Routes
      GoRoute(
        path: '/recipe/:recipeId',
        builder: (context, state) {
          final recipeId = state.pathParameters['recipeId']!;
          return RecipeDetailScreen(recipeId: recipeId);
        },
      ),
      GoRoute(
        path: '/add-recipe',
        builder: (context, state) => AddRecipeScreen(),
      ),
      GoRoute(
        path: '/recipe-success',
        builder: (context, state) => RecipeSuccessScreen(),
      ),

      // Test Route
      GoRoute(
        path: '/test',
        builder: (context, state) => TestAuthScreen(),
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isFirstLogin = ref.read(isFirstLoginProvider);
      final location = state.matchedLocation;

      // Se ainda está carregando, manter na rota atual
      if (authState.isLoading && !authState.isInitialized) {
        return null;
      }

      // Rotas públicas
      final publicRoutes = [
        '/onboarding',
        '/create-account',
        '/login',
        '/signup',
        '/forgot-password',
        '/choose-recovery-method',
        '/verify-recovery-code',
        '/reset-password',
        '/test'
      ];

      if (publicRoutes.contains(location)) {
        return null;
      }

      // Se não está autenticado, redirecionar para onboarding
      if (!authState.isAuthenticated) {
        return '/onboarding';
      }

      // Se está autenticado e é primeiro login
      if (authState.isAuthenticated && isFirstLogin) {
        if (location != '/setup-profile' &&
            location != '/setup-complete' &&
            location != '/verify-email') {
          return '/setup-profile';
        }
      }

      // Permitir navegação livre
      return null;
    },
    refreshListenable: routerNotifier,
  );
});

// Widget de teste para facilitar o desenvolvimento
class TestAuthScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isFirstLogin = ref.watch(isFirstLoginProvider);
    final userData = ref.watch(currentUserDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Test Auth'),
        backgroundColor: Color(0xFFFA9500),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estado Atual:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Autenticado: ${authState.isAuthenticated}'),
                    Text('Carregando: ${authState.isLoading}'),
                    Text('Inicializado: ${authState.isInitialized}'),
                    Text('Primeiro Login: $isFirstLogin'),
                    if (userData != null) ...[
                      Divider(height: 20),
                      Text('Nome: ${userData['name']}'),
                      Text('Email: ${userData['email']}'),
                      Text('Username: ${userData['username'] ?? 'não definido'}'),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFA9500),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Ir para Login', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.go('/forgot-password'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Testar Recuperação de Senha',
                  style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3C4D18),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Ir para Home', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final userId = userData?['id'] ?? '1';
                context.go('/profile/$userId');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Ir para Perfil', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => ref.read(authProvider.notifier).logout(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Logout', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            Text(
              'Credenciais de Teste:\nEmail: test@example.com\nSenha: password123',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}