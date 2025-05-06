import 'dart:math';

import 'package:flutter/material.dart';

class ConfettiPainter extends CustomPainter {
  final double animationValue;
  final Random random = Random();
  
  ConfettiPainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final confettiCount = 50;
    
    for (int i = 0; i < confettiCount; i++) {
      final x = random.nextDouble() * size.width;
      final yBase = random.nextDouble() * size.height;
      final y = yBase + animationValue * 100; // Moving down with animation
      final confettiSize = 3.0 + random.nextDouble() * 5;
      
      // Create different colors for confetti
      final colors = [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.yellow,
        Colors.purple,
        Colors.orange,
      ];
      
      final color = colors[random.nextInt(colors.length)].withOpacity(
        0.7 - (animationValue * 0.5), // Fade out as it falls
      );
      
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      
      // Alternating shapes: circles and rectangles
      if (i % 2 == 0) {
        canvas.drawCircle(Offset(x, y), confettiSize, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(x, y),
            width: confettiSize * 2,
            height: confettiSize * 2,
          ),
          paint,
        );
      }
    }
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}