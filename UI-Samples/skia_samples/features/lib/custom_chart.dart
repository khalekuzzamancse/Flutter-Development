import 'dart:convert';

import 'package:flutter/material.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
   final data = Controller().data!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 32),
          CustomPaint(
            size: Size(280, 200),
            painter: _LineChartPathPainter(
              xAxisData: data.xAxisData,
              yAxisData: data.yAxisData,
            ),
          ),
        ],
      ),
    );
  }
}

class Controller {
   AxisData? data;

  Controller() {
    Map<String, AxisData> axisDataMap = {};
    final jsonData = '''{
    "data": {
      "1W": {"xAxisData": ["MON", "TUE", "WED", "THU", "FRI", "SAT"], "yAxisData": [1000, 1200, 1500, 2200, 3500, 5000]},
      "1M": {"xAxisData": ["Week 1", "Week 2", "Week 3", "Week 4"], "yAxisData": [15000, 20000, 25000, 30000]},
      "3M": {"xAxisData": ["Jan", "Feb", "Mar"], "yAxisData": [45000, 50000, 60000]},
      "6M": {"xAxisData": ["Oct", "Nov", "Dec", "Jan", "Feb", "Mar"], "yAxisData": [70000, 75000, 80000, 85000, 90000, 95000]},
      "1Y": {"xAxisData": ["Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "Jan", "Feb", "Mar"], "yAxisData": [100000, 105000, 110000, 120000, 130000, 140000, 150000, 155000, 160000, 165000, 170000, 175000]},
      "ALL": {"xAxisData": ["2020", "2021", "2022", "2023"], "yAxisData": [300000, 350000, 400000, 450000]}
    },
    "timePeriods": ["1W", "1M", "3M", "6M", "1Y", "ALL"],
    "selectedTimePeriod": "1W"
  }''';
    final Map<String, dynamic> decodedData = jsonDecode(jsonData);
    decodedData['data'].forEach((key, value) {
      List<String> xAxisData = List<String>.from(value['xAxisData']);
      List<int> yAxisData = List<int>.from(value['yAxisData']);
      axisDataMap[key] = AxisData(xAxisData, yAxisData);
      data = axisDataMap['1W']!;
    });
  }
}

class AxisData {
  final List<String> xAxisData;
  final List<int> yAxisData;

  AxisData(this.xAxisData, this.yAxisData);
}

class _LineChartStyle {
  final Color curveLineColor,
      gridColor,
      pointColor,
      xAxisColor,
      yAxisColor,
      wrapperBoxColor;
  final double curveLineWidth, gridLineWidth, pointSize, axisLineWidth;
  final TextStyle xAxisLabelStyle, yAxisLabelStyle;
  final Radius wrapperBoxTopLeftRadius, wrapperBoxBottomLeftRadius;

  const _LineChartStyle({
    this.curveLineColor = Colors.blue,
    this.gridColor = Colors.grey,
    this.pointColor = Colors.blue,
    this.xAxisColor = Colors.grey,
    this.yAxisColor = Colors.grey,
    this.wrapperBoxColor = Colors.black,
    this.curveLineWidth = 2.0,
    this.gridLineWidth = 1.0,
    this.pointSize = 4.0,
    this.axisLineWidth = 1.0,
    this.xAxisLabelStyle = const TextStyle(
      color: Colors.black,
      fontSize: 10,
      fontWeight: FontWeight.bold,
    ),
    this.yAxisLabelStyle = const TextStyle(
      color: Colors.black,
      fontSize: 10,
      fontWeight: FontWeight.bold,
    ),
    this.wrapperBoxTopLeftRadius = const Radius.circular(12),
    this.wrapperBoxBottomLeftRadius = const Radius.circular(12),
  });

  _LineChartStyle copyWith({
    Color? curveLineColor,
    double? curveLineWidth,
    Color? gridColor,
    double? gridLineWidth,
    Color? pointColor,
    double? pointSize,
    Color? xAxisColor,
    Color? yAxisColor,
    double? axisLineWidth,
    TextStyle? xAxisLabelStyle,
    TextStyle? yAxisLabelStyle,
    Color? wrapperBoxColor,
    Radius? wrapperBoxTopLeftRadius,
    Radius? wrapperBoxBottomLeftRadius,
  }) {
    return _LineChartStyle(
      curveLineColor: curveLineColor ?? this.curveLineColor,
      curveLineWidth: curveLineWidth ?? this.curveLineWidth,
      gridColor: gridColor ?? this.gridColor,
      gridLineWidth: gridLineWidth ?? this.gridLineWidth,
      pointColor: pointColor ?? this.pointColor,
      pointSize: pointSize ?? this.pointSize,
      xAxisColor: xAxisColor ?? this.xAxisColor,
      yAxisColor: yAxisColor ?? this.yAxisColor,
      axisLineWidth: axisLineWidth ?? this.axisLineWidth,
      xAxisLabelStyle: xAxisLabelStyle ?? this.xAxisLabelStyle,
      yAxisLabelStyle: yAxisLabelStyle ?? this.yAxisLabelStyle,
      wrapperBoxColor: wrapperBoxColor ?? this.wrapperBoxColor,
      wrapperBoxTopLeftRadius:
          wrapperBoxTopLeftRadius ?? this.wrapperBoxTopLeftRadius,
      wrapperBoxBottomLeftRadius:
          wrapperBoxBottomLeftRadius ?? this.wrapperBoxBottomLeftRadius,
    );
  }
}

class _LineChartPathPainter extends CustomPainter {
  final List<String> xAxisData;
  final List<int> yAxisData;
  final _LineChartStyle style;
  static const double trailingX = 20.0;

  _LineChartPathPainter({
    required this.xAxisData,
    required this.yAxisData,
    this.style = const _LineChartStyle(),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxY = yAxisData.reduce((a, b) => a > b ? a : b);
    final scaleFactor = size.height / maxY;
    final xSpacing = size.width / (xAxisData.length - 1);

    // Draw each element
    final points = generatePoints(scaleFactor, size.height, xSpacing);
    // drawPoints(canvas, points);
    drawXLabels(canvas, size);
    drawPath(canvas, points);
    drawAxes(canvas, size);
    drawYLabels(canvas, size, maxY);
    drawGridLines(canvas, size, numYLabels: 5, xSpacing: xSpacing);
  }

  List<Offset> generatePoints(
    double scaleFactor,
    double height,
    double xSpacing,
  ) {
    return List.generate(
      yAxisData.length,
      (i) => Offset(i * xSpacing, height - (yAxisData[i] * scaleFactor)),
    );
  }

  void drawPoints(Canvas canvas, List<Offset> points) {
    final pointPaint = Paint()
      ..color = style.pointColor
      ..style = PaintingStyle.fill;
    for (var point in points) {
      canvas.drawCircle(point, style.pointSize, pointPaint);
    }
  }

  void drawXLabels(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    final labelSpacing = size.width / (xAxisData.length - 1);

    for (int index = 0; index < xAxisData.length; index++) {
      final label = xAxisData[index];
      final x = index * labelSpacing;
      textPainter.text = TextSpan(text: label, style: style.xAxisLabelStyle);
      textPainter.layout();
      textPainter.paint(canvas, Offset(x, size.height));
    }
  }

  void drawPath(Canvas canvas, List<Offset> points) {
    if (points.length < 2) return;

    final pathPaint = Paint()
      ..color = style.curveLineColor
      ..strokeWidth = style.curveLineWidth
      ..style = PaintingStyle.stroke;
    final path = Path()..moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      final midPoint = Offset(
        (points[i - 1].dx + points[i].dx) / 2,
        (points[i - 1].dy + points[i].dy) / 2,
      );
      path.quadraticBezierTo(
        points[i - 1].dx,
        points[i - 1].dy,
        midPoint.dx,
        midPoint.dy,
      );
    }
    path.lineTo(points.last.dx, points.last.dy);
    canvas.drawPath(path, pathPaint);
  }

  //TODO: Currently using exactly 5 levels for Y-axis labels. Consider enhancing this logic for dynamic levels when time permits
  //This is challenging without knowing   information about the data such as what the max value can be
  //what the max size can be the `yAxisData`
  void drawYLabels(Canvas canvas, Size size, int maxY) {
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Determine at least 5 levels for labels
    final numLabels = 5;
    final yLabelInterval = (maxY / numLabels).ceil(); // Calculate interval

    // Determine text color based on wrapper box color luminance
    final isLightBox = style.wrapperBoxColor.computeLuminance() > 0.5;
    final wrapperTextStyle = style.yAxisLabelStyle.copyWith(
      color: isLightBox ? Colors.black : Colors.white,
    );

    // Draw labels starting from interval, leaving space for "0" but not rendering it
    for (int i = 1; i <= numLabels; i++) {
      final yValue = i * yLabelInterval; // Start from interval (skip 0)
      final yPosition = size.height - (i * (size.height / numLabels));

      final label = '${(yValue / 1000).floor()}k';
      final textStyle = i == numLabels
          ? wrapperTextStyle
          : style.yAxisLabelStyle;

      textPainter.text = TextSpan(text: label, style: textStyle);
      textPainter.layout();

      // Draw wrapper box for the topmost label
      if (i == numLabels) {
        final rect = RRect.fromRectAndCorners(
          Rect.fromLTWH(
            size.width,
            yPosition - textPainter.height / 2,
            60,
            textPainter.height,
          ),
          topLeft: style.wrapperBoxTopLeftRadius,
          bottomLeft: style.wrapperBoxBottomLeftRadius,
        );
        canvas.drawRRect(rect, Paint()..color = style.wrapperBoxColor);
      }

      textPainter.paint(
        canvas,
        Offset(size.width + trailingX, yPosition - textPainter.height / 2),
      );
    }
  }

  void drawAxes(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = style.xAxisColor
      ..strokeWidth = style.axisLineWidth;
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, size.height),
      axisPaint,
    ); // Y-axis
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      axisPaint,
    ); // X-axis
  }

  void drawGridLines(
    Canvas canvas,
    Size size, {
    required int numYLabels,
    required double xSpacing,
  }) {
    final gridPaint = Paint()
      ..color = style.gridColor.withOpacity(0.3)
      ..strokeWidth = style.gridLineWidth;

    for (int i = 1; i < xAxisData.length; i++) {
      final x = i * xSpacing;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (int i = 0; i <= numYLabels; i++) {
      final y = size.height - (i * (size.height / numYLabels));
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width + trailingX - 5, y),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
