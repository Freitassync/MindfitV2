import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationProvider with ChangeNotifier {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? _fcmToken;
  List<String> _notifications = [];

  String? get fcmToken => _fcmToken;
  List<String> get notifications => _notifications;
  
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

  Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> initializeNotifications() async {
    try {
      // Inicializar notificações locais primeiro
      await initializeLocalNotifications();
      
      // Solicitar permissão para notificações
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('Usuário concedeu permissão para notificações');
        
        // Obter token FCM
        _fcmToken = await _firebaseMessaging.getToken();
        print('FCM Token: $_fcmToken');
        
        // Configurar handlers para mensagens
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
        FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
        
        notifyListeners();
      } else {
        print('Usuário negou permissão para notificações');
      }
    } catch (e) {
      print('Erro ao inicializar notificações: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) async {
    print('Mensagem recebida em primeiro plano: ${message.notification?.title}');
    
    if (message.notification != null) {
      _notifications.add(
        '${message.notification!.title}: ${message.notification!.body}'
      );
      notifyListeners();

      // Exibir notificação local
      await _showLocalNotification(
        message.notification!.title ?? 'Notificação',
        message.notification!.body ?? '',
      );
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    print('Mensagem abriu o app: ${message.notification?.title}');
  }

  // Método privado para exibir notificação local
  Future<void> _showLocalNotification(String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000), // ID único
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel_id',
          'Notificações',
          channelDescription: 'Canal padrão para notificações',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        ),
      ),
    );
  }

  // Simular notificações locais para demonstração
  Future<void> sendLocalNotification(String title, String body) async {
    _notifications.add('$title: $body');
    notifyListeners();
    
    // Exibir a notificação visual também
    await _showLocalNotification(title, body);
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  // Simular diferentes tipos de notificações
  Future<void> simulateWorkoutReminder() async {
    await sendLocalNotification(
      'Hora do Treino!', 
      'Não esqueça do seu treino de hoje às 18:00'
    );
  }

  Future<void> simulateWaterReminder() async {
    await sendLocalNotification(
      'Meta de Água Atingida!', 
      'Parabéns! Você bebeu 2L de água hoje 💧'
    );
  }

  Future<void> simulateNutritionAlert() async {
    await sendLocalNotification(
      'Dica Nutricional', 
      'Que tal adicionar mais proteínas na sua próxima refeição?'
    );
  }
}