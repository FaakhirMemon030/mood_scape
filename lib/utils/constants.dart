import 'package:flutter/material.dart';

/// 🔹 App Name
const String APP_NAME = "MoodScope";

/// 🔹 Default Admin Credentials
const String ADMIN_EMAIL = "admin@moodscope.com";
const String ADMIN_PASSWORD = "moodscope12##";

/// 🔹 Firebase Collections
const String USERS_COLLECTION = "users";
const String MOODS_COLLECTION = "moods";
const String CHALLENGES_COLLECTION = "challenges";

/// 🔹 Default Assets
const String DEFAULT_AVATAR = "assets/images/default_avatar.png";
const String DEFAULT_BADGE = "assets/badges/default_badge.png";

/// 🔹 App Colors
const Color PRIMARY_COLOR = Color(0xFF6C63FF);
const Color SECONDARY_COLOR = Color(0xFF00C6FF);
const Color ACCENT_COLOR = Color(0xFFFFC107);
const Color BACKGROUND_COLOR = Color(0xFFF5F5F5);
const Color CARD_COLOR = Colors.white;

/// 🔹 Text Styles
const double TITLE_FONT_SIZE = 20.0;
const double SUBTITLE_FONT_SIZE = 16.0;
const double BODY_FONT_SIZE = 14.0;

/// 🔹 Mood Slider Labels
const List<String> MOOD_LABELS = [
  "😔 Sad",
  "😐 Neutral",
  "🙂 Good",
  "😊 Happy",
  "🤩 Excellent"
];

/// 🔹 Notifications
const String DAILY_CHALLENGE_CHANNEL_ID = "daily_challenge_channel";
const String DAILY_CHALLENGE_CHANNEL_NAME = "Daily Challenges";
const String DAILY_CHALLENGE_CHANNEL_DESC = "Daily challenge reminders";
