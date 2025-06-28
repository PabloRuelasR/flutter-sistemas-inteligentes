import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sistemas_inteligentes/app.dart';
import 'package:flutter_sistemas_inteligentes/firebase_options.dart';
import 'package:flutter_sistemas_inteligentes/notifications/notification_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  NotificationService.show(
    message.notification?.title ?? 'Timbre',
    message.notification?.body ?? '¡Alguien tocó el timbre!',
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService.initialize();

  await FirebaseMessaging.instance.subscribeToTopic('timbre');
  print('📡 Suscrito al topic: timbre');

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    NotificationService.show(
      message.notification?.title ?? 'Timbre',
      message.notification?.body ?? '¡Alguien tocó el timbre!',
    );

    final player = AudioPlayer();
    await player.play(AssetSource('sounds/timbre.mp3'), volume: 2.0);
  });

  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission();
  print('🔔 Permiso de notificaciones: ${settings.authorizationStatus}');

  runApp(MyApp());
}
