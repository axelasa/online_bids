import 'package:flutter/material.dart';

class BidItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double startingPrice;
  final double currentPrice;
  final DateTime startTime;
  final DateTime endTime;
  final bool requiresAdditionalFees;
  final double additionalFees;
  final List<BidParticipant> participants;

  BidItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.startingPrice,
    this.currentPrice = 0.0,
    required this.startTime,
    required this.endTime,
    this.requiresAdditionalFees = false,
    this.additionalFees = 0.0,
    this.participants = const [],
  });
}

class BidParticipant {
  final String userId;
  final String username;
  final double bidAmount;
  final DateTime bidTime;

  BidParticipant({
    required this.userId,
    required this.username,
    required this.bidAmount,
    required this.bidTime,
  });
}