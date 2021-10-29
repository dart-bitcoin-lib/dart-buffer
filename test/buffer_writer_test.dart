import 'dart:math';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:dart_buffer/dart_buffer.dart';
import 'package:test/test.dart';

import 'common_helper.dart';

void main() {
  test('BufferWriter.setInt8()', () {
    final values = [-128, -127, -1, 0, 1, 0x7e, 0x7d];
    final expectedBuffer = Int8List.fromList(values);
    final bufferWriter = BufferWriter(ByteData(expectedBuffer.lengthInBytes));
    for (var v in values) {
      final expectedOffset = bufferWriter.offset + 1;
      bufferWriter.setInt8(v);
      expect(bufferWriter.offset, equals(expectedOffset));
      expect(bufferWriter.buffer.getInt8(bufferWriter.offset - 1), equals(v));
    }
  });
  test('BufferWriter.setUInt8()', () {
    final values = [0, 1, 0xfe, 0xff];
    final expectedBuffer = Uint8List.fromList(values);
    final bufferWriter = BufferWriter(ByteData(expectedBuffer.lengthInBytes));
    for (var v in expectedBuffer) {
      final expectedOffset = bufferWriter.offset + 1;
      bufferWriter.setUInt8(v);
      expect(bufferWriter.offset, equals(expectedOffset));
      expect(bufferWriter.buffer.getUint8(bufferWriter.offset - 1), equals(v));
    }
  });
  test('BufferWriter.setInt16()', () {
    final values = [-32768, -32767, -1, 0, 1, 0x7ffd, 0x7fff];
    final expectedBuffer = Int16List.fromList(values);
    final bufferWriter = BufferWriter(ByteData(expectedBuffer.lengthInBytes));
    for (var v in expectedBuffer) {
      final expectedOffset = bufferWriter.offset + 2;
      bufferWriter.setInt16(v);
      expect(bufferWriter.offset, equals(expectedOffset));
      expect(
          bufferWriter.buffer.getInt16(bufferWriter.offset - 2, Endian.little),
          equals(v));
    }
  });
  test('BufferWriter.setUInt16()', () {
    final values = [0, 1, 0x7ffd, 0x7fff];
    final expectedBuffer = Uint16List.fromList(values);
    final bufferWriter = BufferWriter(ByteData(expectedBuffer.lengthInBytes));
    for (var v in expectedBuffer) {
      final expectedOffset = bufferWriter.offset + 2;
      bufferWriter.setUInt16(v);
      expect(bufferWriter.offset, equals(expectedOffset));
      expect(
          bufferWriter.buffer.getUint16(bufferWriter.offset - 2, Endian.little),
          equals(v));
    }
  });
  test('BufferWriter.setInt32()', () {
    final maxInt32 = 2147483647;
    final minInt32 = -2147483648;
    final values = <int>[
      minInt32,
      minInt32 ~/ 2,
      -1,
      0,
      1,
      maxInt32 ~/ 2,
      maxInt32
    ];
    final expectedBuffer = Int32List.fromList(values);
    final bufferWriter = BufferWriter(ByteData(expectedBuffer.lengthInBytes));
    for (var v in expectedBuffer) {
      final expectedOffset = bufferWriter.offset + 4;
      bufferWriter.setInt32(v);
      expect(bufferWriter.offset, equals(expectedOffset));
      expect(
          bufferWriter.buffer.getInt32(bufferWriter.offset - 4, Endian.little),
          equals(v));
    }
  });
  test('BufferWriter.setUInt32()', () {
    final maxInt32 = 2147483647;
    final values = <int>[0, 1, maxInt32 ~/ 2, maxInt32];
    final expectedBuffer = Uint32List.fromList(values);
    final bufferWriter = BufferWriter(ByteData(expectedBuffer.lengthInBytes));
    for (var v in expectedBuffer) {
      final expectedOffset = bufferWriter.offset + 4;
      bufferWriter.setUInt32(v);
      expect(bufferWriter.offset, equals(expectedOffset));
      expect(
          bufferWriter.buffer.getUint32(bufferWriter.offset - 4, Endian.little),
          equals(v));
    }
  });
  test('BufferWriter.setInt64()', () {
    final maxInt64 = 9223372036854775807;
    final minInt64 = -9223372036854775808;
    final values = <int>[
      minInt64,
      minInt64 ~/ 2,
      -1,
      0,
      1,
      maxInt64 ~/ 2,
      maxInt64
    ];
    final expectedBuffer = Int64List.fromList(values);
    final bufferWriter = BufferWriter(ByteData(expectedBuffer.lengthInBytes));
    for (var v in expectedBuffer) {
      final expectedOffset = bufferWriter.offset + 8;
      bufferWriter.setInt64(v);
      expect(bufferWriter.offset, equals(expectedOffset));
      expect(
          bufferWriter.buffer.getInt64(bufferWriter.offset - 8, Endian.little),
          equals(v));
    }
  });
  test('BufferWriter.setUInt64()', () {
    final maxInt64 = 9223372036854775807;
    final values = <int>[0, 1, maxInt64 ~/ 2, maxInt64];
    final expectedBuffer = Uint64List.fromList(values);
    final bufferWriter = BufferWriter(ByteData(expectedBuffer.lengthInBytes));
    for (var v in expectedBuffer) {
      final expectedOffset = bufferWriter.offset + 8;
      bufferWriter.setUInt64(v);
      expect(bufferWriter.offset, equals(expectedOffset));
      expect(
          bufferWriter.buffer.getUint64(bufferWriter.offset - 8, Endian.little),
          equals(v));
    }
  });
  test('BufferWriter.setVarInt()', () {
    final expectedBuffer = hex.decode(
        '0001fcfdfd00fdfe00fdff00fd0001fdfefffdfffffe00000100fefefffffffeffffffffff0000000001000000ffffffffffffff1f00');
    final values = [
      0,
      1,
      252,
      253,
      254,
      255,
      256,
      pow(2, 16).toInt() - 2,
      pow(2, 16).toInt() - 1,
      pow(2, 16).toInt(),
      pow(2, 32).toInt() - 2,
      pow(2, 32).toInt() - 1,
      pow(2, 32).toInt(),
      9007199254740991,
    ];
    final byteData = ByteData(expectedBuffer.length);
    final bufferWriter = BufferWriter(byteData);
    final bufferReader = BufferReader(byteData);
    for (var v in values) {
      int expectedOffset = bufferWriter.offset + encodingLength(v);
      bufferWriter.setVarInt(v);
      expect(bufferWriter.offset, equals(expectedOffset));
      expect(bufferReader.getVarInt(), equals(v));
    }
  });
  test('BufferWriter.setSlice()', () {
    final List<List<int>> values = [
      [],
      [1],
      [1, 2, 3, 4],
      [254, 255]
    ];
    final expectedBuffer = Uint8List.fromList([1, 1, 2, 3, 4, 254, 255]);
    final bufferWriter = BufferWriter(ByteData(expectedBuffer.length));
    for (var v in values) {
      final expectedOffset = bufferWriter.offset + v.length;
      bufferWriter.setSlice(Uint8List.fromList(v));
      expect(bufferWriter.offset, equals(expectedOffset));
      expect(bufferWriter.toUint8List().sublist(0, expectedOffset),
          expectedBuffer.sublist(0, expectedOffset));
    }
    expect(bufferWriter.offset, equals(expectedBuffer.lengthInBytes));
    expect(bufferWriter.toUint8List().sublist(0, expectedBuffer.length),
        expectedBuffer.sublist(0, expectedBuffer.lengthInBytes));
    try {
      bufferWriter.setSlice(Uint8List.fromList([0, 0]));
    } catch (e) {
      expect(e.toString(),
          matches(RegExp(r'^Exception: Cannot set slice out of bounds$')));
      return;
    }
    throw Exception('Should be throwable.');
  });
  test('BufferWriter.setVarSlice()', () {
    final values = [
      Uint8List.fromList(List.filled(1, 1)),
      Uint8List.fromList(List.filled(252, 2)),
      Uint8List.fromList(List.filled(253, 3))
    ];
    final expectedBuffer = Uint8List.fromList(Uint8List.fromList([0x01, 0x01]) +
        Uint8List.fromList([0xfc]) +
        Uint8List.fromList(List.filled(252, 0x02)) +
        Uint8List.fromList([0xfd, 0xfd, 0x00]) +
        Uint8List.fromList(List.filled(253, 0x03)));
    final bufferWriter = BufferWriter(ByteData(expectedBuffer.lengthInBytes));
    for (var value in values) {
      final expectedOffset =
          bufferWriter.offset + encodingLength(value.length) + value.length;
      bufferWriter.setVarSlice(Uint8List.fromList(value));
      expect(bufferWriter.offset, equals(expectedOffset));
      expect(bufferWriter.toUint8List().sublist(0, expectedOffset),
          expectedBuffer.sublist(0, expectedOffset));
    }
    expect(bufferWriter.offset, equals(expectedBuffer.lengthInBytes));
    expect(bufferWriter.toUint8List().sublist(0, expectedBuffer.length),
        expectedBuffer.sublist(0, expectedBuffer.lengthInBytes));
  });
}
