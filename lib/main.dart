import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/users_screen.dart';
import 'screens/receipts_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/comunicados_screen.dart';

// Notificador global del tema
final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.dark);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (_, mode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'DTALENT APP',
          themeMode: mode,
          theme: _lightTheme,
          darkTheme: _darkTheme,
          initialRoute: '/',
          routes: {
            '/': (_) => const LoginScreen(),
            '/home': (_) => const HomeScreen(),
            '/users': (_) => const UsersScreen(),
            '/receipts': (_) => const ReceiptsScreen(),
            '/settings': (_) => const SettingsScreen(),
            '/comunicados': (_) => const ComunicadosScreen(),
          },
        );
      },
    );
  }
}

// ===== Temas =====
final _lightTheme = ThemeData(
  brightness: Brightness.light,
  colorSchemeSeed: const Color(0xFF6EA8FF),
  useMaterial3: true,
);

final _darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121017),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF8FB3FF),
    secondary: Color(0xFF7AA2FF),
  ),
  useMaterial3: true,
);

