import 'dart:math';

import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({
    super.key,
    required this.tabController,
    required this.icons,
    required this.names,
  });

  final TabController tabController;
  final List<IconData> icons;
  final List<String> names;

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    const iconsRadius = ((bigRadius - smallRaidus) / 2) + smallRaidus;
    final iconsWidth = MediaQuery.of(context).size.width - 110;
    final iconAngleInDegrees = calculateAngle(iconsRadius, iconsWidth);

    final leftIconStep = iconsWidth / (widget.tabController.length - 1);
    final minIconAngle = 90 - iconAngleInDegrees / 2;
    final iconAngleStep = (iconAngleInDegrees / (widget.tabController.length - 1) / 2);

    const labelRadius = smallRaidus + 2;
    final labelMoveWidth = MediaQuery.of(context).size.width - 120;
    double lableAngleDegrees = calculateAngle(labelRadius, labelMoveWidth);

    final leftLabelMoveStep = labelMoveWidth / (widget.tabController.length - 1);
    final minLabelAngle = 90 - lableAngleDegrees / 2;
    final labelMoveAngleStep = (lableAngleDegrees / (widget.tabController.length - 1) / 2);

    return CustomPaint(
      painter: CustomBottomNavBarPainter(),
      child: Container(
        alignment: Alignment.center,
        height: 100,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ...widget.icons.map(
              (icon) {
                final index = widget.icons.indexOf(icon);

                return Positioned(
                  key: ValueKey(icon),
                  top: (bigRadius - smallRaidus) / 2 +
                      iconsRadius -
                      sin(radFromDeg(minIconAngle + iconAngleStep * index * 2)) * iconsRadius -
                      24,
                  left: 50 + leftIconStep * index - 24,
                  child: IconButton(
                    onPressed: () {
                      widget.tabController.animateTo(index);
                    },
                    icon: Icon(
                      icon,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: widget.tabController.animation!,
              builder: (BuildContext context, Widget? child) {
                final animatedIndex = widget.tabController.animation!.value;

                return Positioned(
                  top: bigRadius -
                      smallRaidus +
                      smallRaidus -
                      sin(radFromDeg(minLabelAngle + labelMoveAngleStep * animatedIndex * 2)) * labelRadius,
                  left: 55 + leftLabelMoveStep * animatedIndex,
                  child: FractionalTranslation(
                    translation: const Offset(-0.5, -0.5),
                    child: Transform.rotate(
                      angle: radFromDeg(minLabelAngle + labelMoveAngleStep * animatedIndex * 2 - 90),
                      child: child!,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: MyBorderShape(),
                  shadows: [
                    BoxShadow(
                      color: Color(0xff6DBEFF),
                      blurRadius: 20,
                      spreadRadius: 0.3,
                      offset: Offset(1, 1),
                    ),
                    BoxShadow(
                      color: Color(0xff6DBEFF),
                      blurRadius: 25,
                      spreadRadius: 0.5,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                height: 3,
              ),
            ),
            Positioned(
              bottom: 10,
              child: ValueListenableBuilder(
                valueListenable: widget.tabController.animation!,
                builder: (context, value, child) {
                  final animatedIndex = widget.tabController.animation!.value.toInt();
                  final selectedName = widget.names[animatedIndex];

                  return Text(
                    selectedName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  double calculateAngle(double radius, double chordLength) {
    double angleRadians = acos((2 * radius * radius - chordLength * chordLength) / (2 * radius * radius));

    double angleDegrees = angleRadians * 180 / pi;

    return angleDegrees;
  }
}

const extraBotomPadding = 50.0;

const bigRadius = 1305 / 2;
const smallRaidus = 1200 / 2;

double radFromDeg(double deg) {
  return deg * pi / 180;
}

class CustomBottomNavBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    drawRecWithArc(canvas, size, bigRadius, const Color(0xff1C1B1E));
    drawRecWithArc(canvas, size, smallRaidus, const Color(0xff151316));
  }

  void drawRecWithArc(Canvas canvas, Size size, double radius, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final chordHeight = getChordHeight(radius, size.width);
    final arc = radiusArc(chordHeight, size, radius);

    final path = Path()
      ..moveTo(0, chordHeight)
      ..addArc(arc.$1, arc.$3, arc.$2)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  (Rect, double, double) radiusArc(
    double height,
    Size size,
    double radius,
  ) {
    Offset center = Offset(size.width / 2, bigRadius);
    Rect rect = Rect.fromCircle(center: center, radius: radius);
    double theta = asin(size.width / (2 * radius));
    double startAngle = pi / 2 - theta - pi;
    double sweepAngle = 2 * theta;

    return (rect, sweepAngle, startAngle);
  }

  double getChordHeight(double radius, double chordLength) {
    return radius - sqrt(pow(radius, 2) - pow(chordLength / 2, 2));
  }
}

class MyBorderShape extends ShapeBorder {
  const MyBorderShape();

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  ShapeBorder scale(double t) => this;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _createPath(rect);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _createPath(rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  Path _createPath(Rect rect) {
    const chordWidth = 60;

    const topRadius = smallRaidus - 4;
    const bottomRadius = smallRaidus - 4;

    double topHeight = topRadius - sqrt(topRadius * topRadius - pow(chordWidth / 2, 2)) + 8;
    double bottomHeight = bottomRadius - sqrt(bottomRadius * bottomRadius - pow(chordWidth / 2, 2));

    Path path = Path();
    path.moveTo(rect.left + (rect.width - chordWidth) / 2, rect.top + topHeight);
    path.arcToPoint(
      Offset(rect.right - (rect.width - chordWidth) / 2, rect.top + topHeight),
      radius: const Radius.circular(topRadius),
      clockwise: true,
    );
    path.lineTo(rect.right - (rect.width - chordWidth) / 2, rect.bottom - bottomHeight);
    path.arcToPoint(
      Offset(rect.left + (rect.width - chordWidth) / 2, rect.bottom - bottomHeight),
      radius: const Radius.circular(bottomRadius),
      clockwise: false,
    );
    path.lineTo(rect.left + (rect.width - chordWidth) / 2, rect.top + topHeight);
    path.close();

    return path;
  }
}
