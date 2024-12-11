import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  // Log the received background notification
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Data: ${message.data}");
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    try {
      // Request notification permissions
      final settings = await _firebaseMessaging.requestPermission();
      print('User granted permission: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Get the Firebase Cloud Messaging token
        final fCMToken = await _firebaseMessaging.getToken();
        if (fCMToken == null) {
          print('Failed to get FCM token');
        } else {
          print('FCM Token: $fCMToken');
        }

        // Set the background message handler
        FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

        // Log foreground notifications
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          print(
              'Foreground notification received: ${message.notification?.title}');
        });
      } else {
        print('Notification permissions not granted.');
      }
    } catch (e) {
      print('Error initializing Firebase notifications: $e');
    }
  }
}
