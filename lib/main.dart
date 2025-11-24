import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart'; // ✅ FALTAVA ESTE IMPORT
import 'package:sabore_app/test_email.dart';
import 'firebase_options.dart';
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
import 'package:sabore_app/screens/recipe/state_recipes_screen.dart';
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
import 'screens/recipe/recipe_comments_screen.dart';
import 'package:sabore_app/screens/profile/profile/followers_screen.dart';
import 'package:sabore_app/screens/profile/profile/following_screen.dart';

// ✅ INICIALIZAÇÃO CORRIGIDA
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // ✅ Inicializa o Firebase com as configurações geradas
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase inicializado com sucesso!');
  } catch (e) {
    print('⚠️ Erro ao inicializar Firebase: $e');
    print('⚠️ Continuando em modo mock para desenvolvimento');
  }

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

      // Rotas de Recuperação de Senha
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
        path: '/recipe/:id/comments',
        builder: (context, state) {
          final recipeId = state.pathParameters['id']!;
          final extra = state.extra as Map<String, dynamic>?;

          return RecipeCommentsScreen(
            recipeId: recipeId,
            recipeTitle: extra?['recipeTitle'] ?? 'Receita',
            recipeAuthorId: extra?['recipeAuthorId'] ?? 0,
          );
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
      GoRoute(
        path: '/state-recipes/:stateName',
        builder: (context, state) {
          final stateName = state.pathParameters['stateName']!;
          final extra = state.extra as Map<String, dynamic>?;

          return StateRecipesScreen(
            stateName: stateName,
            stateEmoji: extra?['emoji'] ?? '🍴',
            stateColor: (extra?['color'] as int?) ?? 0xFFFA9500,
          );
        },
      ),
      GoRoute(
        path: '/followers/:userId',
        builder: (context, state) {
          final userId = int.parse(state.pathParameters['userId']!);
          final extra = state.extra as Map<String, dynamic>?;

          return FollowersScreen(
            userId: userId,
            userName: extra?['userName'] ?? 'Usuário',
          );
        },
      ),
      GoRoute(
        path: '/following/:userId',
        builder: (context, state) {
          final userId = int.parse(state.pathParameters['userId']!);
          final extra = state.extra as Map<String, dynamic>?;

          return FollowingScreen(
            userId: userId,
            userName: extra?['userName'] ?? 'Usuário',
          );
        },
      ),

      // Test Routes
      GoRoute(
        path: '/test',
        builder: (context, state) => TestAuthScreen(),
      ),
      GoRoute(
        path: '/test-email',
        builder: (context, state) => TestEmailScreen(),
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isFirstLogin = ref.read(isFirstLoginProvider);
      final location = state.matchedLocation;

      if (authState.isLoading && !authState.isInitialized) {
        return null;
      }

      final publicRoutes = [
        '/onboarding',
        '/create-account',
        '/login',
        '/signup',
        '/forgot-password',
        '/choose-recovery-method',
        '/verify-recovery-code',
        '/reset-password',
        '/test',
        '/test-email', // ✅ Adicionar rota de teste como pública
      ];

      if (publicRoutes.contains(location)) {
        return null;
      }

      if (!authState.isAuthenticated) {
        return '/onboarding';
      }

      if (authState.isAuthenticated && isFirstLogin) {
        if (location != '/setup-profile' &&
            location != '/setup-complete' &&
            location != '/verify-email') {
          return '/setup-profile';
        }
      }

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

            // Botões de teste para Email e SMS
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '🧪 Testes de Verificação',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/test-email'),
                      icon: Icon(Icons.email),
                      label: Text('Testar Envio de Email'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/verify-email'),
                      icon: Icon(Icons.email),
                      label: Text('Testar Verificação Email'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/verify-phone'),
                      icon: Icon(Icons.phone),
                      label: Text('Testar Verificação SMS'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
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