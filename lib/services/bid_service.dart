import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:online_bids/services/notification_service.dart';
import '../models/bid_item.dart';

class BidService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final NotificationService _notificationService = NotificationService();

  // Fetch upcoming bids
  Future<List<BidItem>> getUpcomingBids() async {
    try {
      DatabaseEvent event = await _database.child('upcoming_bids').once();

      if (event.snapshot.value == null) return [];

      List<BidItem> bids = [];
      Map<dynamic, dynamic> bidMap = event.snapshot.value as Map<dynamic, dynamic>;

      bidMap.forEach((key, bidData) {
        bids.add(BidItem(
          id: key,
          title: bidData['title'],
          description: bidData['description'],
          imageUrl: bidData['imageUrl'],
          startingPrice: double.parse(bidData['startingPrice'].toString()),
          startTime: DateTime.parse(bidData['startTime']),
          endTime: DateTime.parse(bidData['endTime']),
          requiresAdditionalFees: bidData['requiresAdditionalFees'] ?? false,
          additionalFees: double.parse(bidData['additionalFees']?.toString() ?? '0.0'),
        ));
      });

      return bids;
    } catch (e) {
      print('Error fetching upcoming bids: $e');
      return [];
    }
  }

  // Place a bid
  Future<bool> placeBid(String bidId, String userId, double bidAmount) async {
    try {
      // Validate bid amount
      DatabaseReference bidRef = _database.child('active_bids').child(bidId);
      DatabaseEvent event = await bidRef.once();

      if (event.snapshot.value == null) {
        throw Exception('Bid not found');
      }

      Map<dynamic, dynamic> bidData = event.snapshot.value as Map<dynamic, dynamic>;
      double currentPrice = double.parse(bidData['currentPrice'].toString());

      if (bidAmount <= currentPrice) {
        throw Exception('Bid amount must be higher than current price');
      }

      // Update bid with new participant
      await bidRef.update({
        'currentPrice': bidAmount,
        'participants/${userId}': {
          'username': userId, // In a real app, you'd use the actual username
          'bidAmount': bidAmount,
          'bidTime': DateTime.now().toIso8601String(),
        }
      });

      // Send notifications to other participants
      await _sendBidUpdateNotification(bidId, bidAmount);

      return true;
    } catch (e) {
      print('Error placing bid: $e');
      return false;
    }
  }

  // Send bid update notification
  Future<void> _sendBidUpdateNotification(String bidId, double newBidAmount) async {
    // In a real app, you'd implement Firebase Cloud Messaging
    await _messaging.sendMessage(
      to: '/topics/bid_$bidId',
      data: {
        'type': 'bid_update',
        'bidId': bidId,
        'newBidAmount': newBidAmount.toString(),
      },
    );
  }

  // End bid and determine winner
  Future<void> endBid(String bidId) async {
    try {
      DatabaseReference bidRef = _database.child('active_bids').child(bidId);
      DatabaseEvent event = await bidRef.once();

      if (event.snapshot.value == null) {
        throw Exception('Bid not found');
      }

      Map<dynamic, dynamic> bidData = event.snapshot.value as Map<dynamic, dynamic>;

      // Determine winner (highest bidder)
      String winningUserId = _findHighestBidder(bidData['participants']);

      String bidTitle = bidData['title'] ?? 'Auction';

      // Update bid status and winner
      await bidRef.update({
        'status': 'completed',
        'winner': winningUserId,
      });

      // Send winner notification
      await _notificationService.sendBidWinnerNotification(
          bidId,
          bidTitle,
          bidData['participants'][winningUserId]['username']??'Winner');
    } catch (e) {
      print('Error ending bid: $e');
    }
  }

  String _findHighestBidder(Map<dynamic, dynamic> participants) {
    double highestBid = 0;
    String winningUserId = '';

    participants.forEach((userId, participantData) {
      double bidAmount = double.parse(participantData['bidAmount'].toString());
      if (bidAmount > highestBid) {
        highestBid = bidAmount;
        winningUserId = userId;
      }
    });

    return winningUserId;
  }
}