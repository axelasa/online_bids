import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  /// A notification action which triggers a App navigation event
  static const String navigationActionId = 'id_3';

  /// Defines a iOS/MacOS notification category for text input actions.
  static const String darwinNotificationCategoryText = 'textCategory';

  /// Defines a iOS/MacOS notification category for plain actions.
  static const String darwinNotificationCategoryPlain = 'plainCategory';

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize notification services
  Future<void> initialize() async {
    // Firebase Cloud Messaging Configuration
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted notification permissions');

      // Configure Firebase Messaging handlers
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpened);
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    }

    // Local Notifications Configuration
    const AndroidInitializationSettings androidInitialize =
    AndroidInitializationSettings('@mipmap/ic_launcher');
//macos amd ios
    final List<DarwinNotificationCategory> darwinNotificationCategories =
    <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        darwinNotificationCategoryText,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.text(
            'text_1',
            'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
      ),
      DarwinNotificationCategory(
        darwinNotificationCategoryPlain,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('id_1', 'Action 1'),
          DarwinNotificationAction.plain(
            'id_2',
            'Action 2 (destructive)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.destructive,
            },
          ),
          DarwinNotificationAction.plain(
            navigationActionId,
            'Action 3 (foreground)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            'id_4',
            'Action 4 (auth required)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.authenticationRequired,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      )
    ];

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidInitialize,
      iOS: iosInitialize,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: _handleNotificationTap,
    );
  }

  // Get FCM Token for the device
  Future<String?> getFirebaseToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Subscribe user to bid-specific topic
  Future<void> subscribeToBidTopic(String bidId) async {
    await _firebaseMessaging.subscribeToTopic('bid_$bidId');
  }

  // Unsubscribe from bid topic
  Future<void> unsubscribeFromBidTopic(String bidId) async {
    await _firebaseMessaging.unsubscribeFromTopic('bid_$bidId');
  }

  // Send Bid Start Notification
  Future<void> sendBidStartNotification(String bidId, String bidTitle) async {
    await _sendNotification(
      title: 'Bid Starting Soon',
      body: 'The bid for "$bidTitle" is about to begin!',
      topic: 'bid_$bidId',
    );
  }

  // Send Bid Update Notification
  Future<void> sendBidUpdateNotification(String bidId, String bidTitle, double newBidAmount) async {
    await _sendNotification(
      title: 'Bid Update',
      body: 'A new bid of \$${newBidAmount.toStringAsFixed(2)} has been placed on "$bidTitle"',
      topic: 'bid_$bidId',
    );
  }

  // Send Bid Winner Notification
  Future<void> sendBidWinnerNotification(String bidId, String bidTitle, String winnerUsername) async {
    await _sendNotification(
      title: 'Bid Completed',
      body: 'The bid for "$bidTitle" has ended. Congratulations to $winnerUsername!',
      topic: 'bid_$bidId',
    );
  }

  // Send Outbid Notification
  Future<void> sendOutbidNotification(String bidId, String bidTitle) async {
    await _sendNotification(
      title: 'Outbid',
      body: 'You have been outbid on "$bidTitle". Place a new bid to stay in the race!',
      topic: 'bid_$bidId',
    );
  }

  // Internal method to send notifications via Firebase
  Future<void> _sendNotification({
    required String title,
    required String body,
    required String topic,
  }) async {
    try {
      await _firebaseMessaging.sendMessage(
        to: topic,
        data: {
          'title': title,
          'body': body,
          'type': 'bid_notification',
        },
      );
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    if (message.notification != null) {
      _showLocalNotification(
        title: message.notification!.title ?? '',
        body: message.notification!.body ?? '',
      );
    }
  }

  // Show local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'bid_channel',
      'Bid Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
    DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryPlain,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  // Handle notification tap
  Future<void> _handleNotificationTap(String? payload) async {
    // Implement navigation logic when notification is tapped
    // This could open a specific bid or screen in the app
  }

  // Background message handler
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // Handle background messages
    print('Handling a background message: ${message.messageId}');
  }

  // Store notification token in user's profile
  Future<void> saveNotificationTokenToFirestore(String userId) async {
    try {
      String? token = await getFirebaseToken();

      if (token != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'notificationToken': token,
        });
      }
    } catch (e) {
      print('Error saving notification token: $e');
    }
  }
}

// Notification payload model for structured data
class NotificationPayload {
  final String type;
  final String bidId;
  final String? additionalData;

  NotificationPayload({
    required this.type,
    required this.bidId,
    this.additionalData,
  });

  factory NotificationPayload.fromMap(Map<String, dynamic> map) {
    return NotificationPayload(
      type: map['type'] ?? '',
      bidId: map['bidId'] ?? '',
      additionalData: map['additionalData'],
    );
  }
}