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
  String imagePath = "assets/images/default.jpg"; // match your file

  @override
  void initState() {
    super.initState();

    //  GET TOKEN (IMPORTANT FOR TESTING)
    _fcmService.getToken().then((token) {
      debugPrint("FCM TOKEN: $token");
    });

    //  LISTEN FOR MESSAGES
    _fcmService.initialize(onData: (RemoteMessage message) {
      debugPrint("MESSAGE RECEIVED: ${message.notification?.title}");
      debugPrint("DATA: ${message.data}");

      setState(() {
        // Update text
        statusText = message.notification?.title ?? "Payload received";

        // Update image (if provided in data)
        String assetName = message.data['asset'] ?? 'default';
        imagePath = "assets/images/$assetName.jpg";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FCM Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              statusText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),

            //  IMAGE DISPLAY WITH FALLBACK
            Image.asset(
              imagePath,
              height: 150,
              errorBuilder: (context, error, stackTrace) {
                return const Text("Image not found");
              },
            ),
          ],
        ),
      ),
    );
  }
}