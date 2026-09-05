// Dev tool, not a test: renders Habitly's launcher icon source PNGs via
// Flutter's own rendering pipeline (RepaintBoundary -> PNG bytes), since no
// SVG rasterizer/ImageMagick was available in this environment. A Material
// Icon glyph doesn't render correctly under `flutter test` (no font loaded
// -> renders as a hollow "tofu" box), so the leaf is hand-drawn as a
// CustomPainter path instead — no font dependency. Run with
// `flutter test tool/generate_app_icon.dart`, then delete/ignore — it isn't
// part of the regular suite and asserts nothing.
//
// Writes:
//   assets/icon/icon.png            — flat 1024x1024, sage bg + white leaf
//                                      (iOS / older Android / web / fallback)
//   assets/icon/icon_foreground.png — 1024x1024, transparent bg + white leaf,
//                                      sized for Android's adaptive icon
//                                      safe zone (foreground layer)
//
// Then regenerate platform assets with:
//   dart run flutter_launcher_icons
//   dart run flutter_native_splash:create
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

const _sage = Color(0xFF3E7A5A);

void main() {
  testWidgets('generate icon.png (flat, sage background)', (tester) async {
    await _renderIcon(
      tester,
      path: 'assets/icon/icon.png',
      background: _sage,
      leafScale: 0.62,
    );
  });

  testWidgets('generate icon_foreground.png (transparent, adaptive-safe)', (tester) async {
    await _renderIcon(
      tester,
      path: 'assets/icon/icon_foreground.png',
      background: Colors.transparent,
      leafScale: 0.48,
    );
  });

  testWidgets('generate icon_splash_light.png (sage leaf, transparent)', (tester) async {
    await _renderIcon(
      tester,
      path: 'assets/icon/icon_splash_light.png',
      background: Colors.transparent,
      leafScale: 0.4,
      leafColor: _sage,
    );
  });
}

Future<void> _renderIcon(
  WidgetTester tester, {
  required String path,
  required Color background,
  required double leafScale,
  Color leafColor = Colors.white,
}) async {
  const size = 1024.0;
  final key = GlobalKey();

  // The default test surface is 800x600 — RepaintBoundary.toImage() only
  // rasterizes what's actually laid out within it, so without this the
  // 1024x1024 request above gets silently clipped to a non-square 800x600
  // output. Match the test view to the requested icon size instead.
  tester.view.physicalSize = const Size(size, size);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: RepaintBoundary(
        key: key,
        child: Container(
          width: size,
          height: size,
          color: background,
          alignment: Alignment.center,
          child: SizedBox(
            width: size * leafScale,
            height: size * leafScale,
            child: CustomPaint(painter: _LeafPainter(color: leafColor)),
          ),
        ),
      ),
    ),
  );
  await tester.pump();

  await tester.runAsync(() async {
    final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();
    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes);
    // ignore: avoid_print
    print('Wrote $path (${bytes.length} bytes)');
  });
}

/// A single bold leaf silhouette + short stem, drawn in a 100x100 box so it
/// scales cleanly to any icon size. Two quadratic arcs meeting at the stem
/// base and the leaf tip form the almond-shaped leaf; the stem is a thick
/// rounded-cap stroke so it stays visible even at small launcher sizes.
class _LeafPainter extends CustomPainter {
  final Color color;

  _LeafPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final stem = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9 * s
      ..strokeCap = StrokeCap.round;

    // Coordinates below are pre-shifted (-7 on y) so the shape's own
    // bounding box — leaf tip at y=13 to stem end at y=87 — sits centered
    // at y=50 in this 100x100 local space, matching the box the caller
    // already centers on the canvas.

    // Stem: from the leaf's base down to the bottom-left.
    canvas.drawLine(Offset(34 * s, 71 * s), Offset(22 * s, 87 * s), stem);

    // Leaf: almond shape from base (34,71) to tip (82,13), bulging wide on
    // the upper-left edge and tighter on the lower-right edge — reads as a
    // single growing leaf, not a generic ellipse.
    final leaf = Path()
      ..moveTo(34 * s, 71 * s)
      ..quadraticBezierTo(18 * s, 27 * s, 82 * s, 13 * s)
      ..quadraticBezierTo(70 * s, 55 * s, 34 * s, 71 * s)
      ..close();
    canvas.drawPath(leaf, fill);
  }

  @override
  bool shouldRepaint(covariant _LeafPainter oldDelegate) => false;
}
