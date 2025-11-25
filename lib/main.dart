import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sabore_app/test_email.dart';
import 'package:sabore_app/test_sms.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';

import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  if (!kIsWeb) {
    await FirebaseAppCheck.instance.activate(
      androidProvider: kDebugMode
          ? AndroidProvider.debug
          : AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.debug,
    );
    print('App Check ativado para Android');
  } else {
    print('App Check ignorado (rodando na Web)');
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
      GoRoute(
        path: '/test-sms',
        builder: (context, state) => TestSmsScreen(),
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
        '/test-email',
        '/test-sms',
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

class TestAuthScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isFirstLogin = ref.watch(isFirstLoginProvider);
    final userData = ref.watch(currentUserDataProvider);

    return Scaffold(
      backgroundColor: Color(0xFFFFF8F0),
      appBar: AppBar(
        title: Text(
          'Test Auth',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFFFA9500),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ CARD DE ESTADO
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Color(0xFFFA9500), size: 28),
                      SizedBox(width: 12),
                      Text(
                        'Estado Atual',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3C4D18),
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 24),
                  _buildInfoRow('Autenticado', authState.isAuthenticated ? '✅' : '❌'),
                  _buildInfoRow('Carregando', authState.isLoading ? '⏳' : '✅'),
                  _buildInfoRow('Inicializado', authState.isInitialized ? '✅' : '❌'),
                  _buildInfoRow('Primeiro Login', isFirstLogin ? '✅' : '❌'),
                  if (userData != null) ...[
                    Divider(height: 24),
                    _buildInfoRow('Nome', userData['name']),
                    _buildInfoRow('Email', userData['email']),
                    _buildInfoRow('Username', userData['username'] ?? 'não definido'),
                  ],
                ],
              ),
            ),

            SizedBox(height: 24),

            // ✅ SEÇÃO DE TESTES DE VERIFICAÇÃO
            Text(
              '🧪 Testes de Verificação',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3C4D18),
              ),
            ),
            SizedBox(height: 12),

            _buildTestButton(
              context: context,
              icon: Icons.email_outlined,
              label: 'Testar Envio de Email',
              color: Color(0xFF9C27B0),
              onTap: () => context.push('/test-email'),
            ),
            SizedBox(height: 12),

            _buildTestButton(
              context: context,
              icon: Icons.phone_android,
              label: 'Testar Envio de SMS',
              color: Color(0xFF4CAF50),
              onTap: () => context.push('/test-sms'),
            ),
            SizedBox(height: 12),

            _buildTestButton(
              context: context,
              icon: Icons.verified_user,
              label: 'Verificação de Email',
              color: Color(0xFF2196F3),
              onTap: () => context.push('/verify-email'),
            ),
            SizedBox(height: 12),

            _buildTestButton(
              context: context,
              icon: Icons.verified_outlined,
              label: 'Verificação de SMS',
              color: Color(0xFF7CB342),
              onTap: () => context.push('/verify-phone'),
            ),

            SizedBox(height: 32),

            // ✅ SEÇÃO DE NAVEGAÇÃO
            Text(
              '🗺️ Navegação',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3C4D18),
              ),
            ),
            SizedBox(height: 12),

            _buildNavButton(
              label: 'Ir para Login',
              color: Color(0xFFFA9500),
              icon: Icons.login,
              onTap: () => context.go('/login'),
            ),
            SizedBox(height: 10),

            _buildNavButton(
              label: 'Recuperação de Senha',
              color: Color(0xFFFF9800),
              icon: Icons.lock_reset,
              onTap: () => context.go('/forgot-password'),
            ),
            SizedBox(height: 10),

            _buildNavButton(
              label: 'Ir para Home',
              color: Color(0xFF3C4D18),
              icon: Icons.home,
              onTap: () => context.go('/home'),
            ),
            SizedBox(height: 10),

            _buildNavButton(
              label: 'Ir para Perfil',
              color: Color(0xFF2196F3),
              icon: Icons.person,
              onTap: () {
                final userId = userData?['id'] ?? '1';
                context.go('/profile/$userId');
              },
            ),
            SizedBox(height: 10),

            _buildNavButton(
              label: 'Logout',
              color: Color(0xFFE53935),
              icon: Icons.logout,
              onTap: () => ref.read(authProvider.notifier).logout(),
            ),

            SizedBox(height: 32),

            // ✅ CREDENCIAIS DE TESTE
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.key, color: Colors.grey[700], size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Credenciais de Teste',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Email: test@example.com\nSenha: password123',
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3C4D18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
    );
  }
}