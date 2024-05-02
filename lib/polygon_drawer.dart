import 'package:flutter/material.dart';

class PolygonDrawer extends StatefulWidget {
  const PolygonDrawer({super.key});

  @override
  _PolygonDrawerState createState() => _PolygonDrawerState();
}

class _PolygonDrawerState extends State<PolygonDrawer> {
  List<Offset> points = []; // Lista para almacenar los puntos del polígono
  bool isPolygonClosed = false;

  void _addPoint(TapUpDetails details) {
    if (!isPolygonClosed) {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final Offset localPosition =
          renderBox.globalToLocal(details.globalPosition);
      print(localPosition);
      print(localPosition.dx);
      print(localPosition.dy);
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
    return Scaffold(
      appBar: AppBar(title: const Text("Draw lines")),
      body: Container(
          width: 1920,
          height: 1080,
          margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          decoration: const BoxDecoration(
              color: Colors.blue,
              // borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      'https://d2yoo3qu6vrk5d.cloudfront.net/images/20161025125101/parqueo-914x607.jpg'))),
          child: GestureDetector(
            onTapUp: _addPoint,
            onDoubleTap: _closePolygon,
            child: CustomPaint(
              painter: LinePainter(points, isPolygonClosed),
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(),
              ),
            ),
          )),
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
