import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Check if bid requires additional fees
  Future<bool> checkBidFees(String bidId, String userId) async {
    try {
      DatabaseReference bidRef = _database.child('upcoming_bids').child(bidId);
      DataSnapshot snapshot = await bidRef.child('requiresAdditionalFees').get();

      bool requiresFees = snapshot.value as bool? ?? false;

      if (requiresFees) {
        return await _showPaymentPopup(bidId, userId);
      }

      return true;
    } catch (e) {
      print('Error checking bid fees: $e');
      return false;
    }
  }

  // Show payment popup for bid entry fees
  Future<bool> _showPaymentPopup(String bidId, String userId) async {
    try {
      return await showDialog<bool>(
        context: NavigatorKey.navigatorKey.currentContext!,
        builder: (context) {
          return FutureBuilder<double>(
            future: _getBidEntryFee(bidId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const AlertDialog(
                  title: Text('Bid Entry Fee'),
                  content: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasData) {
                double entryFee = snapshot.data!;
                return AlertDialog(
                  title: const Text('Bid Entry Fee'),
                  content: Text('This bid requires an entry fee of \$${entryFee.toStringAsFixed(2)}'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        bool paymentSuccess = await _processPayment(bidId, userId, entryFee);
                        Navigator.pop(context, paymentSuccess);
                      },
                      child: const Text('Pay Entry Fee'),
                    ),
                  ],
                );
              }

              return const AlertDialog(
                title: Text('Bid Entry Fee'),
                content: Text('Unable to fetch entry fee.'),
              );
            },
          );
        },
      ) ?? false;
    } catch (e) {
      print('Error showing payment popup: $e');
      return false;
    }
  }

  // Retrieve bid entry fee
  Future<double> _getBidEntryFee(String bidId) async {
    try {
      DatabaseReference bidRef = _database.child('upcoming_bids').child(bidId);
      DataSnapshot snapshot = await bidRef.child('additionalFees').get();

      return double.parse(snapshot.value?.toString() ?? '0.0');
    } catch (e) {
      debugPrint('Error retrieving bid entry fee: $e');
      return 0.0;
    }
  }

  // Process payment for bid entry
  Future<bool> _processPayment(String bidId, String userId, double amount) async {
    try {
      // Stripe payment integration
      PaymentMethod paymentMethod = await Stripe.instance.createPaymentMethod(
        PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );

      // Server should handle payment intents for better security
      // Replace with your backend API call
      final paymentIntent = await createPaymentIntentOnServer(
        amount: (amount * 100).toInt(),
        currency: 'usd',
        paymentMethodId: paymentMethod.id,
      );

      if (paymentIntent['status'] == 'succeeded') {
        await _database.child('bid_entries').child(bidId).child(userId).set({
          'paid': true,
          'entryFee': amount,
          'timestamp': DateTime.now().toIso8601String(),
        });

        return true;
      }

      return false;
    } catch (e) {
      print('Payment error: $e');
      return false;
    }
  }

  // Simulated server-side API call (replace with your actual implementation)
  Future<Map<String, dynamic>> createPaymentIntentOnServer({
    required int amount,
    required String currency,
    required String paymentMethodId,
  }) async {
    // TODO: Implement your backend API call to create a PaymentIntent
    // For now, simulate success
    return {
      'status': 'succeeded',
    };
  }
}

// Global navigator key for showing dialogs from service classes
class NavigatorKey {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
