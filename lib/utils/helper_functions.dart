import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 🔹 Show a simple snackbar
void showSnackBar(BuildContext context, String message,
    {Color backgroundColor = Colors.black87, int durationSeconds = 2}) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: Duration(seconds: durationSeconds),
    backgroundColor: backgroundColor,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

/// 🔹 Format Timestamp / Date
String formatDate(DateTime date, {String pattern = "MMM dd, yyyy"}) {
  final formatter = DateFormat(pattern);
  return formatter.format(date);
}

/// 🔹 Convert mood value (1-5) to Emoji
String moodValueToEmoji(double value) {
  if (value <= 1.5) return "😔";
  if (value <= 2.5) return "😐";
  if (value <= 3.5) return "🙂";
  if (value <= 4.5) return "😊";
  return "🤩";
}

/// 🔹 Check if string is valid email
bool isValidEmail(String email) {
  final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
  return emailRegex.hasMatch(email);
}

/// 🔹 Check if string is strong password
bool isValidPassword(String password) {
  // Minimum 8 chars, at least 1 uppercase, 1 lowercase, 1 number, 1 special char
  final passwordRegex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  return passwordRegex.hasMatch(password);
}

/// 🔹 Calculate streaks from list of mood entries
int calculateStreak(List<DateTime> dates) {
  if (dates.isEmpty) return 0;

  dates.sort((a, b) => b.compareTo(a)); // Descending
  int streak = 1;
  for (int i = 0; i < dates.length - 1; i++) {
    final diff = dates[i].difference(dates[i + 1]).inDays;
    if (diff == 1) {
      streak++;
    } else {
      break;
    }
  }
  return streak;
}

/// 🔹 Capitalize first letter
String capitalize(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1);
}
