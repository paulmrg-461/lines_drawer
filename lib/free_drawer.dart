import 'package:flutter/material.dart';

class FreeDrawer extends StatefulWidget {
  const FreeDrawer({super.key});

  @override
  _FreeDrawerState createState() => _FreeDrawerState();
}

class _FreeDrawerState extends State<FreeDrawer> {
  List<Offset?> points = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          points.add(renderBox.globalToLocal(details.globalPosition));
        });
      },
      onPanEnd: (details) {
        points.add(null);
      },
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
  final List<Offset?> points;

  LinePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
