import 'package:features/_feature_core/ui.dart';
import 'package:features/core/core_ui.dart';
import 'package:features/search/presenation/time_period_model.dart';
import 'package:features/wallet/domain/model/spend_model.dart';
import 'package:flutter/material.dart';
import '../../wallet/presentation/wallet_screen.dart';
import '../domain/model/product_model.dart';
import 'axis_data_model.dart';
import 'controller.dart';
import 'factory.dart';

//@formatter:off
class SearchScreen extends StatelessWidget {
   final controller=PresentationFactory.createController();

   SearchScreen({super.key}){
     controller.read();
   }

  @override
  Widget build(BuildContext context) {
    const cornerRadius = 24.0;
    const background= Color(0xFF256C34);
   return Scaffold(
     backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          title: TextH1(text:"Search")),
      body:   Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          StreamBuilderStrategyWithSnackBar<TabModel?>(
              messageStream: controller.statusMessage,
              dataStream: controller.tabs,
              builder: (context, snapshot) {
                final data = snapshot.data;
                if (data == null) return EmptyContentScreen();
                return  CustomTabBar(
                    timePeriods: data.tabs,
                    selectedPeriod: data.selected,
                    onPeriodSelected: (period) {
                      controller.onSelected(period);
                    });
              }),
          SpacerVertical(16),
          StreamBuilderStrategyWithSnackBar<AxisData?>(
              messageStream: controller.statusMessage,
              dataStream: controller.axisData,
              builder: (context, snapshot) {
                final data = snapshot.data;
                if (data == null) return EmptyContentScreen();
                return  CustomPaint(
                    size: Size(280, 200),
                    painter: _LineChartPathPainter(xAxisData: data.xAxisData, yAxisData: data.yAxisData));
              }),
          Spacer(),
          Container(
            width: double.infinity,
             decoration:  BoxDecoration(
                  color:Color(0xFFA5D15B),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(cornerRadius),
                    topRight: Radius.circular(cornerRadius),
                  )
              ),
            child: StreamBuilderStrategyWithSnackBar<List<ProductModel>>(
                messageStream: controller.statusMessage,
                isLoadingStream: controller.isLoading,
                dataStream: controller.products,
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  if (data == null) return EmptyContentScreen();
                  return _SpendingNRecentProduct(products: data,controller: controller,);
                }),
          )
        ],
      ),
    );

  }
}


class _SpendingNRecentProduct extends StatelessWidget {
  final List<ProductModel> products;
  final Controller controller;
  const _SpendingNRecentProduct({super.key, required this.products, required this.controller});

  @override
  Widget build(BuildContext context) {
    const cornerRadius = 24.0;
    return Column(
    //  crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: 32),
        StreamBuilderStrategyWithSnackBar<SpendModel?>(
            messageStream: controller.statusMessage,
            dataStream: controller.spendData,
            builder: (context, snapshot) {
              final data = snapshot.data;
              if (data == null) return EmptyContentScreen();
              return  Bars(period:data.period, typeOfCost: 'Spend Chart(This month)',
                  costs:data.spend.data.firstOrNull?.toCost()??[], currencyType:data.currency);
            }),
        SizedBox(height: 32),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color:Colors.white
              ,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(cornerRadius),
                topRight: Radius.circular(cornerRadius),
              )
          ),
          child: Column(
            children: [
              SpacerVertical(16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _SpendingSummary(
                    amountOfSpending: "\$450.00",
                    dueDateString: "10 OCT",
                    bgColor: Colors.white,
                    buttonColor: Colors.blue,
                    onPayEarlyPressed: () {}),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//@formatter:off
class _SpendingSummary extends StatelessWidget {
  final String amountOfSpending, dueDateString;
  final VoidCallback onPayEarlyPressed; final Color bgColor, buttonColor;

  _SpendingSummary({Key? key, required this.amountOfSpending, required this.dueDateString,
    required this.onPayEarlyPressed, required this.bgColor, required this.buttonColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = bgColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    final buttonTextColor = buttonColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return _SpendingLayoutStrategy(
      labelSpending: Text("Total Spending", style: TextStyle(fontSize: 16, color: textColor)),
      dueDate: (RowBuilder()
      + Text("Due Date: ", style: TextStyle(fontSize: 16, color: textColor))
      + Text(dueDateString, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: textColor))).build(),
      cost:  Text(amountOfSpending, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
      action: ElevatedButton(onPressed: onPayEarlyPressed,
        style: ElevatedButton.styleFrom(backgroundColor: buttonColor,textStyle: TextStyle(color: buttonTextColor)),
        child: Text("PAY EARLY", style: TextStyle(color: buttonTextColor))),
    );
  }
}

class _SpendingLayoutStrategy extends StatelessWidget {
final Widget labelSpending,dueDate,cost,action;
  const _SpendingLayoutStrategy({required this.labelSpending, required this.dueDate, required this.cost,
    required this.action});
  @override
  Widget build(BuildContext context) {
    return   (ColumnBuilder(arrangement: Arrangement.spaceBy(8))
        + (RowBuilder()+labelSpending.modifier(Modifier().weight(1))+dueDate).build()
        + (RowBuilder()+cost.modifier(Modifier().weight(1))+action).build())
        .build();
  }
}

class RecentProduct extends StatelessWidget {
  final List<ProductModel> products;

  const RecentProduct({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return LayoutBuilder(
      builder: (context, constraints) {
        // You can get the height of the parent widget from constraints.maxHeight
        double availableHeight = constraints.maxHeight;
        print("Height is:$availableHeight");
        return    Column(
          children: [
            Text("Recent Products", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                .modifier(Modifier().align(Alignment.centerLeft)),
            Expanded(
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: ProductWidget(product: products[index]),
                  );
                },
              ).modifier(Modifier()

              ),
            ),
          ],
        ) .modifier(Modifier().shadow(height:availableHeight,backgroundColor: Colors.grey[200]!,radius: 12));
      },
    );

    return NestedVerticalScroller(
      listModifier:Modifier()
          .shadow(height: 300,backgroundColor: Colors.grey[200]!,radius: 12),
      maxWidth:500,maxHeight: 300,
      children: products.map((product) => ProductWidget(product: product)).toList(),
      header: Text("Recent Products", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
          .modifier(Modifier().align(Alignment.centerLeft)),
      childGap: 16,// Sets the maximum height for the scroller
    );
  }
}


//@formatter:off
class ProductWidget extends StatelessWidget {
  final ProductModel product;
  const ProductWidget({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return  _ProductLayoutStrategy(
      image: AsyncImage().link(product.image).build().modifier(Modifier().size(50).roundedCornerShape(8.0)),
      title: Text(product.title,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500),maxLines: 2,
        overflow: TextOverflow.ellipsis),
      price:Text('\$${product.price.toStringAsFixed(2)}',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
      rating:   Text("Rating: ${product.rating.rate}(${product.rating.count})",
          style: const TextStyle(fontSize: 14)),
    );
  }
}
class _ProductLayoutStrategy extends StatelessWidget {
  final Widget title,price,image,rating;
  const _ProductLayoutStrategy({super.key, required this.title, required this.price,
    required this.image, required this.rating});

  @override
  Widget build(BuildContext context) {
    return (RowBuilder(
        arrangement: Arrangement.spaceBy(8),
      horizontalAlignment: MainAxisAlignment.start
    )
        +image.modifier(Modifier().align(Alignment.centerLeft))
        +(ColumnBuilder(horizontalAlignment: CrossAxisAlignment.start)
            +title
            +SpacerVertical(8)
            +rating
        ).build().modifier(Modifier().weight(1))
        +price
    ).build();
  }
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
        color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
    this.yAxisLabelStyle = const TextStyle(
        color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
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
      double scaleFactor, double height, double xSpacing) {
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
          points[i - 1].dx, points[i - 1].dy, midPoint.dx, midPoint.dy);
    }
    path.lineTo(points.last.dx, points.last.dy);
    canvas.drawPath(path, pathPaint);
  }

//TODO: Currently using exactly 5 levels for Y-axis labels. Consider enhancing this logic for dynamic levels when time permits
  //This is challenging without knowing   information about the source such as what the max value can be
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
      final textStyle =
      i == numLabels ? wrapperTextStyle : style.yAxisLabelStyle;

      textPainter.text = TextSpan(text: label, style: textStyle);
      textPainter.layout();

      // Draw wrapper box for the topmost label
      if (i == numLabels) {
        final rect = RRect.fromRectAndCorners(
          Rect.fromLTWH(size.width, yPosition - textPainter.height / 2, 60, textPainter.height),
          topLeft: style.wrapperBoxTopLeftRadius,
          bottomLeft: style.wrapperBoxBottomLeftRadius,
        );
        canvas.drawRRect(rect, Paint()..color = style.wrapperBoxColor);
      }

      textPainter.paint(canvas,
          Offset(size.width + trailingX, yPosition - textPainter.height / 2));
    }
  }

  void drawAxes(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = style.xAxisColor
      ..strokeWidth = style.axisLineWidth;
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, size.height),
        axisPaint); // Y-axis
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height),
        axisPaint); // X-axis
  }

  void drawGridLines(Canvas canvas, Size size,
      {required int numYLabels, required double xSpacing}) {
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
          Offset(0, y), Offset(size.width + trailingX - 5, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

