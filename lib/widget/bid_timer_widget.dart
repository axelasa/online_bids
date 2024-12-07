import 'package:flutter/material.dart';
import 'dart:async';

class BidTimer extends StatefulWidget {
  final DateTime endTime;
  final VoidCallback onTimerExpired;
  final int resetDuration;

  const BidTimer({
    Key? key,
    required this.endTime,
    required this.onTimerExpired,
    this.resetDuration = 60,
  }) : super(key: key);

  @override
  _BidTimerState createState() => _BidTimerState();
}

class _BidTimerState extends State<BidTimer> {
  late Timer _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  void _initializeTimer() {
    _remainingSeconds = widget.resetDuration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
        widget.onTimerExpired();
      }
    });
  }

  void resetTimer() {
    // Reset timer when a new bid is placed
    setState(() {
      _remainingSeconds = widget.resetDuration;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _remainingSeconds <= 10 ? Colors.red : Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'Time Remaining: $_remainingSeconds seconds',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}