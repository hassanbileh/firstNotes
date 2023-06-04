import 'package:flutter/material.dart';

String greeting() {
    const String goodMorning = 'Good Morning';
    const String goodAfter = 'Good Afternoon';
    const String goodEven = 'Good Evening';
    final hour = TimeOfDay.now().hour;
    if (hour <= 12) {
      return goodMorning;
    } else if (hour <= 18) {
      return goodAfter;
    } else {
      return goodEven;
    }
  }