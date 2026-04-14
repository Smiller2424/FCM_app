import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/fcm_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FCMService _fcmService = FCMService();

  String statusText = "Waiting for a cloud message";
  String imagePath = "assets/images/default.png";

  @override
  void initState() {
    super.initState();

    _fcmService.initialize(onData: (RemoteMessage message) {
      setState(() {
        statusText = message.notification?.title ?? "Payload received";

        imagePath =
            "assets/images/${message.data['asset'] ?? 'default'}.png";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FCM Demo")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            statusText,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Image.asset(
            imagePath,
            height: 150,
            errorBuilder: (context, error, stackTrace) {
              return const Text("Image not found");
            },
          ),
        ],
      ),
    );
  }
}