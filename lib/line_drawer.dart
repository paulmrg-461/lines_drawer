import 'package:flutter/material.dart';

class LineDrawer extends StatefulWidget {
  const LineDrawer({super.key});

  @override
  _LineDrawerState createState() => _LineDrawerState();
}

class _LineDrawerState extends State<LineDrawer> {
  List<Offset> points =
      []; // Eliminamos los null, ya que ahora cada par de puntos será una línea

  void _addPoint(TapUpDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localPosition =
        renderBox.globalToLocal(details.globalPosition);
    setState(() {
      points.add(localPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: _addPoint,
      child: CustomPaint(
        painter: LinePainter(points),
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final List<Offset> points;

  LinePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i += 2) {
      // Incrementa de dos en dos
      if (i + 1 < points.length) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
