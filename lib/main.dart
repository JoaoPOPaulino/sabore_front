import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/create_account_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/home_screen.dart';
import 'providers/auth_provider.dart';
void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Saborê',
      theme: ThemeData(
        primaryColor: Color(0xFF4CAF50),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Color(0xFFFF5722), // Substitui accentColor
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
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(path: '/onboarding', builder: (context, state) => OnboardingScreen()),
    GoRoute(path: '/create-account', builder: (context, state) => CreateAccountScreen()),
    GoRoute(path: '/signup', builder: (context, state) => SignupScreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
  ],
  redirect: (context, state) async {
    // Usar ref.read requer um Consumer, então vamos simular com uma verificação simples por agora
    // Para uma solução completa, use um ProviderScope com Consumer
    final authNotifier = ProviderScope.containerOf(context).read(authProvider.notifier);
    final isAuthenticated = authNotifier.state;
    if (state.fullPath == '/onboarding' && isAuthenticated) return '/home';
    if (state.fullPath == '/create-account' && isAuthenticated) return '/home';
    if (state.fullPath == '/login' && isAuthenticated) return '/home';
    if (state.fullPath == '/signup' && isAuthenticated) return '/home';
    if (state.fullPath == '/home' && !isAuthenticated) return '/onboarding';
    return null;
  },
);