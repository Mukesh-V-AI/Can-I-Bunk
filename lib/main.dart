import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';
import 'providers/attendance_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAnalytics.instance.logAppOpen();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'Can I Bunk?',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: const ColorScheme(
                brightness: Brightness.light,
                primary: Color(0xFF6366F1), // Indigo
                onPrimary: Colors.white,
                secondary: Color(0xFFEC4899), // Pink
                onSecondary: Colors.white,
                error: Color(0xFFEF4444), // Red
                onError: Colors.white,
                surface: Color(0xFFF8FAFC), // Light gray
                onSurface: Color(0xFF1E293B), // Dark slate
                background: Color(0xFFFFFFFF),
                onBackground: Color(0xFF1E293B),
              ),
              fontFamily: 'Inter',
              textTheme: const TextTheme(
                displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
                bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF4B5563)),
                bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                ),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF6366F1),
                foregroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
              ),
            ),
            home: auth.isAuthenticated ? const HomeScreen() : const AuthScreen(),
          );
        },
      ),
    );
  }
}
