import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sabore_app/screens/categorie/categories_screen.dart';
import 'package:sabore_app/screens/categorie/states_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/create_account_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/profile/setup_profile_screen.dart';
import 'screens/home/home_screen.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'Saborê',
      theme: ThemeData(
        primaryColor: Color(0xFF4CAF50),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Color(0xFFFF5722),
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF5722),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFFFF3E0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
      routerConfig: router,
    );
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  // Criamos um ValueNotifier que será atualizado quando o auth state mudar
  final routerNotifier = ValueNotifier<int>(0);

  // Escutamos mudanças no auth state
  ref.listen(authProvider, (previous, next) {
    routerNotifier.value++;
  });

  // Escutamos mudanças no first login
  ref.listen(isFirstLoginProvider, (previous, next) {
    routerNotifier.value++;
  });

  return GoRouter(
    initialLocation: '/onboarding',
    routes: [
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
      GoRoute(
        path: '/setup-profile',
        builder: (context, state) => SetupProfileScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => CategoriesScreen(),
      ),
      GoRoute(
        path: '/states',
        builder: (context, state) => StatesScreen(),
      ),
      // Rota de teste para facilitar desenvolvimento
      GoRoute(
        path: '/test',
        builder: (context, state) => TestAuthScreen(),
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isFirstLogin = ref.read(isFirstLoginProvider);
      final location = state.matchedLocation;

      print('🧭 Navigation - Location: $location');
      print('🔐 Auth State - Authenticated: ${authState.isAuthenticated}');
      print('🔐 Auth State - Initialized: ${authState.isInitialized}');
      print('🔐 Auth State - Loading: ${authState.isLoading}');
      print('👤 First Login: $isFirstLogin');

      // Se ainda está carregando, manter na rota atual
      if (authState.isLoading && !authState.isInitialized) {
        print('⏳ Still loading, staying at current location');
        return null;
      }

      // Rotas públicas que sempre podem ser acessadas
      if (location == '/onboarding' ||
          location == '/create-account' ||
          location == '/login' ||
          location == '/signup' ||
          location == '/test') {
        print('🌍 Public route, allowing access');
        return null;
      }

      // Lógica de redirecionamento baseada na autenticação
      if (authState.isAuthenticated) {
        if (isFirstLogin && location != '/setup-profile') {
          print('➡️ Authenticated but first login, redirect to profile setup');
          return '/setup-profile';
        }
        if (!isFirstLogin && location != '/home') {
          print('➡️ Authenticated and profile complete, redirect to home');
          return '/home';
        }
        print('✅ Authenticated, staying at current location');
        return null; // Usuário está autenticado e na rota correta
      }

      // Usuário não autenticado, redirecionar para onboarding
      print('❌ Not authenticated, redirect to onboarding');
      return '/onboarding';
    },
    refreshListenable: routerNotifier, // Usa o ValueNotifier personalizado
  );
});

// Widget de teste para facilitar o desenvolvimento
class TestAuthScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isFirstLogin = ref.watch(isFirstLoginProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Test Auth'),
        backgroundColor: Color(0xFFFA9500),
      ),
      body: Padding(
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
                    Text('Estado Atual:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Autenticado: ${authState.isAuthenticated}'),
                    Text('Carregando: ${authState.isLoading}'),
                    Text('Inicializado: ${authState.isInitialized}'),
                    Text('Primeiro Login: $isFirstLogin'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => ref.read(authProvider.notifier).forceLogin(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3C4D18),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('🧪 Force Login (Bypass Auth)',
                  style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFA9500),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('📱 Ir para Login',
                  style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3C4D18),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('🏠 Tentar ir para Home',
                  style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => ref.read(authProvider.notifier).logout(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('🚪 Logout',
                  style: TextStyle(color: Colors.white)),
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