import 'package:flutter/material.dart';
import '../models/challenge_model.dart';

class ChallengeCard extends StatelessWidget {
  final ChallengeModel challenge;
  final VoidCallback? onTap;

  const ChallengeCard({
    super.key,
    required this.challenge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: challenge.completed
              ? Colors.green.withOpacity(0.2)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: challenge.completed ? Colors.green : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // 🔹 Status Indicator
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    challenge.completed ? Colors.green : Colors.grey.shade300,
              ),
              child: Icon(
                challenge.completed ? Icons.check : Icons.star_border,
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 16),

            // 🔹 Challenge Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    challenge.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: challenge.completed
                          ? Colors.green.shade800
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    challenge.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: challenge.completed
                          ? Colors.green.shade700
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Optional Arrow
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: challenge.completed
                  ? Colors.green.shade800
                  : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
