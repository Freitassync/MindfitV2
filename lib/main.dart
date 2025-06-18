import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_has_app/providers/auth_provider.dart';
import 'package:smart_has_app/providers/user_provider.dart';
import 'package:smart_has_app/screens/splash_screen.dart';
// import 'package:firebase_core/firebase_core.dart';

void main() async {
  // Para usar os serviços do Firebase, descomente as duas linhas abaixo.
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // Adicione outros providers aqui conforme necessário.
      ],
      child: MaterialApp(
        title: 'Smart HAS',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}