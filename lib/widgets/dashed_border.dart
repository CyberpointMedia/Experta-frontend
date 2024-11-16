import 'package:flutter/material.dart';

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double? topGap;
  final double? bottomGap;
  final bool isCircular;
  final double radius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.topGap,
    this.bottomGap,
    this.isCircular = false,
    this.radius = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();

    if (isCircular) {
      // Draw rounded rectangle path
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      );

      path.addRRect(rect);

      // Get path metrics
      var metrics = path.computeMetrics();
      var metric = metrics.first;
      var totalLength = metric.length;

      double distance = 0.0;
      final dashPath = Path();

      while (distance < totalLength) {
        // Extract a segment of the path
        double start = distance;
        double end = distance + dashWidth;
        if (end > totalLength) end = totalLength;

        var extractPath = metric.extractPath(start, end);
        dashPath.addPath(extractPath, Offset.zero);

        // Move forward by dash width + space
        distance += dashWidth + dashSpace;
      }

      canvas.drawPath(dashPath, paint);
    } else {
      // Original rectangular border code
      double startX = 0;
      while (startX < size.width) {
        path.moveTo(startX, 0);
        path.lineTo(startX + dashWidth, 0);
        startX += dashWidth + dashSpace;
      }

      double startY = 0;
      while (startY < size.height) {
        path.moveTo(size.width, startY);
        path.lineTo(size.width, startY + dashWidth);
        startY += dashWidth + dashSpace;
      }

      startX = size.width;
      while (startX > 0) {
        path.moveTo(startX, size.height);
        path.lineTo(startX - dashWidth, size.height);
        startX -= dashWidth + dashSpace;
      }

      startY = size.height;
      while (startY > 0) {
        path.moveTo(0, startY);
        path.lineTo(0, startY - dashWidth);
        startY -= dashWidth + dashSpace;
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DashedDividerPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  DashedDividerPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startX = 0;
    final path = Path();

    // Only draw horizontal dashes
    while (startX < size.width) {
      path.moveTo(startX, 0);
      path.lineTo(startX + dashWidth, 0);
      startX += dashWidth + dashSpace;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
