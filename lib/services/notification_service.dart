import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/gkeonprem/v1.dart';
import 'package:online_bids/constants/constant.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

// class NotificationService {
//    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   // Initialize notification services
//   Future<void> initialize() async {
//     // Firebase Cloud Messaging Configuration
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       provisional: false,
//       criticalAlert: false,
//       carPlay: false,
//       announcement: false,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted notification permissions');
//
//       // Configure Firebase Messaging handlers
//       FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
//       FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpened);
//       FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     }
//
//     // // Local Notifications Configuration
//
//     // initializing android for notifications
//     const AndroidInitializationSettings androidInitialize =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     //initializing iOS for notifications
//     final DarwinInitializationSettings initializationSettingsDarwin =
//     DarwinInitializationSettings(
//       requestAlertPermission: false,
//       requestBadgePermission: false,
//       requestSoundPermission: false,
//       notificationCategories: darwinNotificationCategories,
//     );
//
//     final InitializationSettings initializationSettings = InitializationSettings(
//       android: androidInitialize,
//       iOS: initializationSettingsDarwin,
//       // macOS: initializationSettingsDarwin,
//       // linux: initializationSettingsLinux,
//     );
//
//
//     //
//     // final IOSInitializationSettings iosInitialize = IOSInitializationSettings(
//     //   requestSoundPermission: true,
//     //   requestBadgePermission: true,
//     //   requestAlertPermission: true,
//     // );
//     //
//     // final InitializationSettings initializationSettings = InitializationSettings(
//     //   android: androidInitialize,
//     //   iOS: iosInitialize,
//     // );
//     //
//     // await _flutterLocalNotificationsPlugin.initialize(
//     //   initializationSettings,
//     //   onSelectNotification: _handleNotificationTap,
//     // );
//   }
//
//   //setting up flutter notification
//
//   Future<void>setupFlutterNotification() async {
//
// }
//
//   // Get FCM Token for the device
//   Future<String?> getFirebaseToken() async {
//     return await _firebaseMessaging.getToken();
//   }
//
//   // Subscribe user to bid-specific topic
//   Future<void> subscribeToBidTopic(String bidId) async {
//     await _firebaseMessaging.subscribeToTopic('bid_$bidId');
//   }
//
//   // Unsubscribe from bid topic
//   Future<void> unsubscribeFromBidTopic(String bidId) async {
//     await _firebaseMessaging.unsubscribeFromTopic('bid_$bidId');
//   }
//
//   // Send Bid Start Notification
//   Future<void> sendBidStartNotification(String bidId, String bidTitle) async {
//     await _sendNotification(
//       title: 'Bid Starting Soon',
//       body: 'The bid for "$bidTitle" is about to begin!',
//       topic: 'bid_$bidId',
//     );
//   }
//
//   // Send Bid Update Notification
//   Future<void> sendBidUpdateNotification(String bidId, String bidTitle, double newBidAmount) async {
//     await _sendNotification(
//       title: 'Bid Update',
//       body: 'A new bid of \$${newBidAmount.toStringAsFixed(2)} has been placed on "$bidTitle"',
//       topic: 'bid_$bidId',
//     );
//   }
//
//   // Send Bid Winner Notification
//   Future<void> sendBidWinnerNotification(String bidId, String bidTitle, String winnerUsername) async {
//     await _sendNotification(
//       title: 'Bid Completed',
//       body: 'The bid for "$bidTitle" has ended. Congratulations to $winnerUsername!',
//       topic: 'bid_$bidId',
//     );
//   }
//
//   // Send Outbid Notification
//   Future<void> sendOutbidNotification(String bidId, String bidTitle) async {
//     await _sendNotification(
//       title: 'Outbid',
//       body: 'You have been outbid on "$bidTitle". Place a new bid to stay in the race!',
//       topic: 'bid_$bidId',
//     );
//   }
//
//   // Internal method to send notifications via Firebase
//   Future<void> _sendNotification({
//     required String title,
//     required String body,
//     required String topic,
//   }) async {
//     try {
//       await _firebaseMessaging.sendMessage(
//         to: topic,
//         data: {
//           'title': title,
//           'body': body,
//           'type': 'bid_notification',
//         },
//       );
//     } catch (e) {
//       print('Error sending notification: $e');
//     }
//   }
//
//   // Handle foreground messages
//   void _handleForegroundMessage(RemoteMessage message) {
//     if (message.notification != null) {
//       _showLocalNotification(
//         title: message.notification!.title ?? '',
//         body: message.notification!.body ?? '',
//       );
//     }
//   }
//
//   // Handle message when app is opened from a notification
//   void _handleMessageOpened(RemoteMessage message) {
//     try {
//       // Extract notification payload
//       NotificationPayload payload = NotificationPayload.fromMap(message.data);
//
//       // Navigate to the appropriate screen based on notification type
//       switch (payload.type) {
//         case 'bid_notification':
//           _navigateToBidDetails(payload.bidId);
//           break;
//         default:
//           print('Unknown notification type: ${payload.type}');
//       }
//     } catch (e) {
//       print('Error handling opened message: $e');
//     }
//   }
//
//   // Navigation method to open specific bid details
//   void _navigateToBidDetails(String bidId) {
//     // Implement navigation to bid details screen
//     // This will depend on your app's navigation structure
//     // Example:
//     // Navigator.of(context).push(
//     //   MaterialPageRoute(
//     //     builder: (context) => BidDetailsScreen(bidId: bidId)
//     //   )
//     // );
//     print('Navigating to bid details for bid: $bidId');
//   }
//
//   // Show local notification
//   Future<void> _showLocalNotification({
//     required String title,
//     required String body,
//   }) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails(
//       'bid_channel',
//       'Bid Notifications',
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//
//     const IOSNotificationDetails iOSPlatformChannelSpecifics =
//     IOSNotificationDetails();
//
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics,
//     );
//
//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//     );
//   }
//
//   // Handle notification tap
//   Future<void> _handleNotificationTap(String? payload) async {
//     // This method is called when a notification is tapped while the app is in the foreground
//     // You can add similar navigation logic as in _handleMessageOpened
//     print('Notification tapped with payload: $payload');
//   }
//
//   // Background message handler
//   static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     // Handle background messages
//     print('Handling a background message: ${message.messageId}');
//   }
//
//   // Store notification token in user's profile
//   Future<void> saveNotificationTokenToFirestore(String userId) async {
//     try {
//       String? token = await getFirebaseToken();
//
//       if (token != null) {
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(userId)
//             .update({
//           'notificationToken': token,
//         });
//       }
//     } catch (e) {
//       print('Error saving notification token: $e');
//     }
//   }
// }
//
// // Notification payload model for structured data
// class NotificationPayload {
//   final String type;
//   final String bidId;
//   final String? additionalData;
//
//   NotificationPayload({
//     required this.type,
//     required this.bidId,
//     this.additionalData,
//   });
//
//   factory NotificationPayload.fromMap(Map<String, dynamic> map) {
//     return NotificationPayload(
//       type: map['type'] ?? '',
//       bidId: map['bidId'] ?? '',
//       additionalData: map['additionalData'],
//     );
//   }
// }

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static Future<String>getAccessToken() async {

    final Map<String,String>serviceAccountJson = serviceAccounts;

    //define scopes for firebase messaging

    List<String> scopes = uriScope;

    http.Client client = await auth.clientViaServiceAccount(auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

    //get acesstoken

    auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    client.close();

    return credentials.accessToken.data;
  }



//   // Subscribe user to bid-specific topic
  Future<void> subscribeToBidTopic(String bidId) async {
    await _firebaseMessaging.subscribeToTopic('bid_$bidId');
  }

//   // Unsubscribe from bid topic
  Future<void> unsubscribeFromBidTopic(String bidId) async {
    await _firebaseMessaging.unsubscribeFromTopic('bid_$bidId');
  }

//   // Send Bid Start Notification
  Future<void> sendBidStartNotification(String bidId, String bidTitle) async {
    final String? deviceToken = await FirebaseMessaging.instance.getToken();
    String title = 'Bid Starting Soon';
    String body = 'The bid for "$bidTitle" is about to begin!';
    await sendNotificationToSubscribedBidders(deviceToken ?? '', bidId,bidTitle, title,body,);
  }

//   // Send Bid Update Notification
  Future<void> sendBidUpdateNotification(String bidId, String bidTitle, double newBidAmount) async {
    final String? deviceToken = await FirebaseMessaging.instance.getToken();
    String title = 'Bid Update';
    String body = 'A new bid of \$${newBidAmount.toStringAsFixed(2)} has been placed on "$bidTitle"';

    await  sendNotificationToSubscribedBidders(deviceToken ?? '', bidId,bidTitle, title,body,);
  }
//
//   // Send Bid Winner Notification
  Future<void> sendBidWinnerNotification(String bidId, String bidTitle, String winnerUsername) async {
    final String? deviceToken = await FirebaseMessaging.instance.getToken();
    String title = 'Bid Completed';
    String body = 'The bid for "$bidTitle" has ended. Congratulations to $winnerUsername!';
    // String topic = 'bid_$bidId';
    await sendNotificationToSubscribedBidders(
        deviceToken ?? '', bidId, bidTitle,title,body
    );
  }
//
//   // Send Outbid Notification
  Future<void> sendOutbidNotification(String bidId, String bidTitle) async {

    final String? deviceToken = await FirebaseMessaging.instance.getToken();
    String title = 'Outbid';
    String body = 'You have been outbid on "$bidTitle". Place a new bid to stay in the race!';

    await sendNotificationToSubscribedBidders(deviceToken ?? '', bidId,bidTitle, title,body,);
  }

  static sendNotificationToSubscribedBidders(String deviceToken, String bidId, String bidTitle, String title, String body,) async{

    final String serverAccessTokenKey = await getAccessToken();
    String endpointFirebaseCloudMessaging = fcmEndpoint;

    final Map<String,dynamic> message = {
      'message':
      {
        'token':deviceToken,
        'notification':
        {
          'title':title,
          'body':body
        },
        'data':
        {
           'bidId':bidId
        },
      },
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFirebaseCloudMessaging),
      headers: <String,String> {
        'Content-Type':'application/json',
        'Authorization': 'Bearer $serverAccessTokenKey'
      },
      body: jsonEncode(message),
    );
    if(response.statusCode == 200){
      print('notification sent Successfully');
    }else{
      print('Failed, notification  not sent :${response.statusCode} body:=> ${response.body}');
    }
  }

}