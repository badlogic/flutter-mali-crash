import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart' as painting;

void main() {
  runApp(const MyApp());
}

class MaliCrash extends FlameGame {
  late ui.Image _texture;
  late Paint _paint;
  late ui.Vertices _vertices;
  late List<Vector2> _positions = [];

  Future<void> _loadPaint() async {
    final imageData = (await rootBundle.load("assets/spineboy.png")).buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(imageData);
    final frameInfo = await codec.getNextFrame();
    _texture = frameInfo.image;
    _paint = Paint()
      ..shader = ImageShader(_texture, TileMode.clamp, TileMode.clamp, Matrix4.identity().storage, filterQuality: FilterQuality.high)
      ..isAntiAlias = true;
  }

  Future<void> _loadVertices() async {
    final lines = LineSplitter().convert(await rootBundle.loadString("assets/spineboy.mesh"));
    final numVertices = int.parse(lines[0]);
    final numIndices = int.parse(lines[1]);
    final positions = Float32List(numVertices * 2);
    final uvs = Float32List(numVertices * 2);
    final colors = Int32List(numVertices);
    final indices = Uint16List(numIndices);
    int idx = 2;
    for (int i = 0; i < numVertices * 2; i++) {
      positions[i] = double.parse(lines[idx++]) * 0.2;
    }
    for (int i = 0; i < numVertices * 2; i++) {
      uvs[i] = double.parse(lines[idx++]) * (i % 2 == 0 ? _texture.width : _texture.height);
    }
    for (int i = 0; i < numVertices; i++) {
      colors[i] = int.parse(lines[idx++]);
    }
    for (int i = 0; i < numIndices; i++) {
      indices[i] = int.parse(lines[idx++]);
    }

    _vertices = ui.Vertices.raw(VertexMode.triangles, positions, textureCoordinates: uvs, colors: colors, indices: indices);
  }

  @override
  Future<void> onLoad() async {
    await _loadPaint();
    await _loadVertices();
    final rng = Random();
    for (int i = 0; i < 12; i++) {
      _positions.add(Vector2(rng.nextDouble() * size.x, rng.nextDouble() * size.y));
    }
  }

  @override
  void render(Canvas canvas) {
    for (var position in _positions) {
      canvas.save();
      canvas.translate(position.x, position.y);
      canvas.drawVertices(_vertices, painting.BlendMode.modulate, _paint);
      canvas.restore();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mali Crash',
      home: GameWidget(game: MaliCrash())
    );
  }
}
