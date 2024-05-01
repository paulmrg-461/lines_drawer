import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Draw lines")),
        body: const LineDraw(),
      ),
    );
  }
}

class LineDraw extends StatefulWidget {
  const LineDraw({super.key});

  @override
  _LineDrawState createState() => _LineDrawState();
}

class _LineDrawState extends State<LineDraw> {
  List<Offset> points = []; // Lista para almacenar los puntos del polígono
  bool isPolygonClosed = false;

  void _addPoint(TapUpDetails details) {
    if (!isPolygonClosed) {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final Offset localPosition =
          renderBox.globalToLocal(details.globalPosition);
      setState(() {
        points.add(localPosition);
      });
    }
  }

  void _closePolygon() {
    if (points.length > 2 && !isPolygonClosed) {
      setState(() {
        isPolygonClosed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: _addPoint,
      onDoubleTap: _closePolygon,
      child: CustomPaint(
        painter: LinePainter(points, isPolygonClosed),
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(),
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final List<Offset> points;
  final bool isPolygonClosed;

  LinePainter(this.points, this.isPolygonClosed);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xff39FF14).withOpacity(0.5)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    Path path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      points.forEach((point) {
        path.lineTo(point.dx, point.dy);
      });

      if (isPolygonClosed && points.length > 2) {
        path.close(); // Cierra el polígono conectando el último punto con el primero
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
