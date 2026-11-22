import 'package:flutter/material.dart';

class PassportStampBadge extends StatelessWidget {
  final String flagEmoji;
  final String countryNamePt;
  final Color stampColor;

  const PassportStampBadge({
    super.key,
    required this.flagEmoji,
    required this.countryNamePt,
    this.stampColor = Colors.indigo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      height: 105,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: stampColor.withValues(alpha: 0.08),
        shape: BoxShape.circle,
        border: Border.all(
          color: stampColor.withValues(alpha: 0.6),
          width: 2.5,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: stampColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(flagEmoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 2),
            Text(
              countryNamePt.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: stampColor,
              ),
            ),
            Text(
              'CPLP • VISTO',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w900,
                color: stampColor.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
