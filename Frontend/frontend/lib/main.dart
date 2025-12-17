import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';           // tambah
import 'config/routes/app_routes.dart';
import 'features/auth/pages/login_register_flip.dart';
import 'firebase_options.dart';                              // tambah

class RoleController extends ChangeNotifier {
  String _role = 'guru';
  String get role => _role;

  void setRole(String newRole) {
    _role = newRole.toLowerCase().trim();
    if (_role.contains('kepala') || _role.contains('kepsek')) {
      _role = 'kepsek';
    } else if (_role.contains('admin')) {
      _role = 'admin';
    } else {
      _role = 'guru';
    }
    print('✅ RoleController.setRole: $_role');
    notifyListeners();
  }

  void clearRole() {
    _role = 'guru';
    notifyListeners();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoleController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALP Aplikasi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: AppRoutes.allRoutes(context),
    );
  }
}
