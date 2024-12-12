import 'package:flutter/material.dart';

/// Parses SVG path data string into a Flutter Path object
Path parseSvgPath(String svgPath) {
  final path = Path();
  final commands = svgPath.replaceAll(',', ' ').split(RegExp(r'(?=[MmLlHhVvCcSsQqTtAaZz])'));
  
  double currentX = 0;
  double currentY = 0;
  double? controlX;
  double? controlY;
  
  for (var cmd in commands) {
    if (cmd.isEmpty) continue;
    
    final command = cmd[0];
    final isRelative = command.toLowerCase() == command;
    final numbers = cmd.substring(1)
        .trim()
        .split(RegExp(r'[\s,]+'))
        .where((s) => s.isNotEmpty)
        .map(double.parse)
        .toList();
    
    var i = 0;
    switch (command.toLowerCase()) {
      case 'm': // moveTo
        while (i < numbers.length - 1) {
          final x = isRelative ? currentX + numbers[i] : numbers[i];
          final y = isRelative ? currentY + numbers[i + 1] : numbers[i + 1];
          if (path.isEmpty) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
          currentX = x;
          currentY = y;
          i += 2;
        }
        break;
        
      case 'l': // lineTo
        while (i < numbers.length - 1) {
          final x = isRelative ? currentX + numbers[i] : numbers[i];
          final y = isRelative ? currentY + numbers[i + 1] : numbers[i + 1];
          path.lineTo(x, y);
          currentX = x;
          currentY = y;
          i += 2;
        }
        break;
        
      case 'h': // horizontal lineTo
        while (i < numbers.length) {
          final x = isRelative ? currentX + numbers[i] : numbers[i];
          path.lineTo(x, currentY);
          currentX = x;
          i += 1;
        }
        break;
        
      case 'v': // vertical lineTo
        while (i < numbers.length) {
          final y = isRelative ? currentY + numbers[i] : numbers[i];
          path.lineTo(currentX, y);
          currentY = y;
          i += 1;
        }
        break;
        
      case 'c': // cubicTo
        while (i < numbers.length - 5) {
          final x1 = isRelative ? currentX + numbers[i] : numbers[i];
          final y1 = isRelative ? currentY + numbers[i + 1] : numbers[i + 1];
          final x2 = isRelative ? currentX + numbers[i + 2] : numbers[i + 2];
          final y2 = isRelative ? currentY + numbers[i + 3] : numbers[i + 3];
          final x = isRelative ? currentX + numbers[i + 4] : numbers[i + 4];
          final y = isRelative ? currentY + numbers[i + 5] : numbers[i + 5];
          
          path.cubicTo(x1, y1, x2, y2, x, y);
          
          controlX = x2;
          controlY = y2;
          currentX = x;
          currentY = y;
          i += 6;
        }
        break;
        
      case 'z':
        path.close();
        break;
    }
  }
  
  return path;
}
