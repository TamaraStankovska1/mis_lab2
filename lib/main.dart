import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'screens/home_page.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('BG message received: ${message.notification?.title}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await _askNotificationPermission();

  final token = await FirebaseMessaging.instance.getToken();
  print("FCM TOKEN: $token");

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("FOREGROUND message: ${message.notification?.title}");
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("User tapped notification: ${message.notification?.title}");
  });

  runApp(const MyApp());
}

Future<void> _askNotificationPermission() async {
  final status = await Permission.notification.status;

  if (status.isDenied || status.isPermanentlyDenied) {
    final newStatus = await Permission.notification.request();

    if (newStatus.isGranted) {
      print("Notification permission granted");
    } else {
      print("Permission denied — maybe open settings");
      await openAppSettings();
    }
  } else {
    print("Notification permission already granted");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipes',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const HomePage(),
    );
  }
}
