import 'package:flutter/material.dart';

class CustomWaveShape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Adjust height as needed
      child: CustomPaint(
        painter: _WavePainter(),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 145, 149, 246)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
        size.width * 0.25, size.height * 0.6, size.width * 0.5, size.height * 0.5);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.4, size.width * 1.0, size.height * 0.5);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
