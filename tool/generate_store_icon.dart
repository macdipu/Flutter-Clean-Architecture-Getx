// Dev tool, not a test: renders Habitly's 512x512 Play Store hi-res icon
// using the same Flutter rendering pipeline as tool/generate_app_icon.dart,
// so it always matches the launcher icon mark pixel-for-pixel at Play's
// required size. Rerun any time the mark in generate_app_icon.dart changes.
//
// Run with `flutter test tool/generate_store_icon.dart`.
// Writes: docs/store/icon_512.png (512x512, 32-bit PNG)
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

const _sage = Color(0xFF3E7A5A);

void main() {
  testWidgets('generate docs/store/icon_512.png', (tester) async {
    const size = 512.0;
    final key = GlobalKey();

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
            color: _sage,
            alignment: Alignment.center,
            child: SizedBox(
              width: size * 0.62,
              height: size * 0.62,
              child: CustomPaint(painter: _MarkPainter(color: Colors.white)),
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
      final file = File('docs/store/icon_512.png');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes);
      // ignore: avoid_print
      print('Wrote docs/store/icon_512.png (${bytes.length} bytes)');
    });
  });
}

/// Same checkmark-in-leaf-shape mark used by tool/generate_app_icon.dart and
/// docs/*.html, redrawn here (not shared code - this file is a standalone
/// `flutter test` entry point, same as its sibling tool).
class _MarkPainter extends CustomPainter {
  final Color color;

  _MarkPainter({required this.color});

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

    canvas.drawLine(Offset(34 * s, 71 * s), Offset(22 * s, 87 * s), stem);

    final leaf = Path()
      ..moveTo(34 * s, 71 * s)
      ..quadraticBezierTo(18 * s, 27 * s, 82 * s, 13 * s)
      ..quadraticBezierTo(70 * s, 55 * s, 34 * s, 71 * s)
      ..close();
    canvas.drawPath(leaf, fill);
  }

  @override
  bool shouldRepaint(covariant _MarkPainter oldDelegate) => false;
}
