import 'package:flutter/material.dart';

class BadgeWidget extends StatelessWidget {
  final String badgeName;
  final String badgeIconUrl; // Asset image or network
  final bool earned; // Is badge earned by user?

  const BadgeWidget({
    super.key,
    required this.badgeName,
    required this.badgeIconUrl,
    this.earned = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: earned ? Colors.deepPurple.withOpacity(0.2) : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        boxShadow: earned
            ? [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔹 Badge Icon
          SizedBox(
            height: 50,
            width: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                badgeIconUrl,
                fit: BoxFit.cover,
                color: earned ? null : Colors.grey,
                colorBlendMode: earned ? BlendMode.dst : BlendMode.saturation,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // 🔹 Badge Name
          Text(
            badgeName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: earned ? Colors.deepPurple : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
