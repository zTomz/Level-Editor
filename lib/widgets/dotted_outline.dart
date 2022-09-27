import 'package:flutter/material.dart';

class DottedOutline extends StatelessWidget {
  final Widget child;
  final double lineWidth;
  final double spaceBetween;
  final StrokeCap strokeCap;
  final double strokeThickness;
  const DottedOutline({
    super.key,
    required this.child,
    this.lineWidth = 20,
    this.spaceBetween = 20,
    this.strokeCap = StrokeCap.round,
    this.strokeThickness = 10,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedOutlinePainter(
        lineWidth: lineWidth,
        spaceBetween: spaceBetween,
        strokeCap: strokeCap,
        strokeThickness: strokeThickness,
      ),
      child: child,
    );
  }
}

class DottedOutlinePainter extends CustomPainter {
  final double lineWidth;
  final double spaceBetween;
  final StrokeCap strokeCap;
  final double strokeThickness;

  DottedOutlinePainter({
    required this.lineWidth,
    required this.spaceBetween,
    required this.strokeCap,
    required this.strokeThickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint outlinedPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = strokeThickness
      ..strokeCap = strokeCap;

    double currentPosition = 0;

    while (currentPosition <= size.width) {
      double posLineTo = currentPosition + lineWidth;

      canvas.drawLine(
          Offset(currentPosition, -1), Offset(posLineTo, -1), outlinedPaint);

      currentPosition = posLineTo;
      currentPosition += spaceBetween;
    }
    currentPosition = 0;

    while (currentPosition <= size.width) {
      double posLineTo = currentPosition + lineWidth;

      canvas.drawLine(Offset(currentPosition, size.height + 1),
          Offset(posLineTo, size.height + 1), outlinedPaint);

      currentPosition = posLineTo;
      currentPosition += spaceBetween;
    }
    currentPosition = 0;

    while (currentPosition <= size.height) {
      double posLineTo = currentPosition + lineWidth;

      canvas.drawLine(
          Offset(-1, currentPosition), Offset(-1, posLineTo), outlinedPaint);

      currentPosition = posLineTo;
      currentPosition += spaceBetween;
    }
    currentPosition = 0;

    while (currentPosition <= size.height) {
      double posLineTo = currentPosition + lineWidth;

      canvas.drawLine(Offset(size.width + 1, currentPosition),
          Offset(size.width + 1, posLineTo), outlinedPaint);

      currentPosition = posLineTo;
      currentPosition += spaceBetween;
    }
    currentPosition = 0;

    // Path outlinePath = getPathFromSize(size);

    // canvas.drawPath(outlinePath, outlinedPaint);
  }

  Path getPathFromSize(Size size) {
    return Path()
      ..addRect(Rect.fromLTRB(-1, 1, size.width + 1, size.height + 1))
      ..fillType;
  }

  @override
  bool shouldRepaint(DottedOutlinePainter oldDelegate) => false;
}
