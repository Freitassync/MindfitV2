
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_has_app/providers/auth_provider.dart';
import 'package:smart_has_app/providers/user_provider.dart';
import 'package:smart_has_app/providers/location_provider.dart';
import 'package:smart_has_app/providers/notification_provider.dart';
import 'package:smart_has_app/providers/workout_provider.dart';
import 'package:smart_has_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: CONFIGURAÇÃO MANUAL NECESSÁRIA
  // Para configurar completamente o Firebase:
  // 1. Substitua os valores em firebase_options.dart pelos seus reais
  // 2. Configure o projeto no Firebase Console
  // 3. Baixe e substitua os arquivos de configuração (google-services.json para Android, GoogleService-Info.plist para iOS)
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase inicializado com sucesso');
  } catch (e) {
    print('Erro ao inicializar Firebase: $e');
    print('Continuando sem Firebase para demonstração...');
    // Continue sem Firebase para demonstração
  }
  
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
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()..initializeNotifications()),
      ],
      child: MaterialApp(
        title: 'MindFit',
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
