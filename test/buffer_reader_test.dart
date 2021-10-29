import 'dart:math';
import 'dart:typed_data';

import 'package:dart_buffer/dart_buffer.dart';
import 'package:test/test.dart';

import 'common_helper.dart';

void testValue(BufferReader bufferReader, dynamic value, dynamic expectedValue,
    [int? expectedOffset]) {
  expectedOffset ??= expectedValue is List<int> ? expectedValue.length : 0;

  expect(bufferReader.offset, expectedOffset);

  if (expectedValue is List<int> && value is List<int>) {
    expect(
      value.sublist(
          0, value.length >= expectedOffset ? expectedOffset : value.length),
      expectedValue.sublist(
          0,
          expectedValue.length >= expectedOffset
              ? expectedOffset
              : expectedValue.length),
    );
  } else {
    expect(value as int, expectedValue);
  }
}

void main() {
  test('BufferReader.getInt8()', () {
    final values = [-128, -127, -1, 0, 1, 0x7d, 0x7f];
    final buffer = Int8List.fromList(values).buffer.asByteData();
    final bufferReader = BufferReader(buffer);
    for (var v in values) {
      final expectedOffset = bufferReader.offset + 1;
      final val = bufferReader.getInt8();
      testValue(bufferReader, val, v, expectedOffset);
    }
  });
  test('BufferReader.getUInt8()', () {
    final values = [0, 1, 0xfe, 0xff];
    final buffer = Uint8List.fromList(values).buffer.asByteData();
    final bufferReader = BufferReader(buffer);
    for (var v in values) {
      final expectedOffset = bufferReader.offset + 1;
      final val = bufferReader.getUInt8();
      testValue(bufferReader, val, v, expectedOffset);
    }
  });
  test('BufferReader.getInt16()', () {
    final values = [-32768, -32767, -1, 0, 1, 0x7ffd, 0x7fff];
    final buffer = Int16List.fromList(values).buffer.asByteData();
    final bufferReader = BufferReader(buffer);
    for (var v in values) {
      final expectedOffset = bufferReader.offset + 2;
      final val = bufferReader.getInt16();
      testValue(bufferReader, val, v, expectedOffset);
    }
  });
  test('BufferReader.getUInt16()', () {
    final values = [0, 1, 0x7ffd, 0x7fff];
    final buffer = Uint16List.fromList(values).buffer.asByteData();
    final bufferReader = BufferReader(buffer);
    for (var v in values) {
      final expectedOffset = bufferReader.offset + 2;
      final val = bufferReader.getUInt16();
      testValue(bufferReader, val, v, expectedOffset);
    }
  });
  test('BufferReader.getInt32()', () {
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
    final buffer = Int32List.fromList(values);
    final bufferReader = BufferReader.fromTypedData(buffer);
    for (var v in values) {
      final expectedOffset = bufferReader.offset + 4;
      final val = bufferReader.getInt32();
      testValue(bufferReader, val, v, expectedOffset);
    }
  });
  test('BufferReader.getUInt32()', () {
    final maxInt32 = 2147483647;
    final values = <int>[0, 1, maxInt32 ~/ 2, maxInt32];
    final buffer = Uint32List.fromList(values);
    final bufferReader = BufferReader.fromTypedData(buffer);
    for (var v in values) {
      final expectedOffset = bufferReader.offset + 4;
      final val = bufferReader.getUInt32();
      testValue(bufferReader, val, v, expectedOffset);
    }
  });
  test('BufferReader.getInt64()', () {
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
    final buffer = Int64List.fromList(values);
    final bufferReader = BufferReader.fromTypedData(buffer);
    for (var v in values) {
      final expectedOffset = bufferReader.offset + 8;
      final val = bufferReader.getInt64();
      testValue(bufferReader, val, v, expectedOffset);
    }
  });
  test('BufferReader.getUInt64()', () {
    final maxInt64 = 9223372036854775807;
    final values = <int>[0, 1, maxInt64 ~/ 2, maxInt64];
    final buffer = Uint64List.fromList(values);
    final bufferReader = BufferReader.fromTypedData(buffer);
    for (var v in values) {
      final expectedOffset = bufferReader.offset + 8;
      final val = bufferReader.getUInt64();
      testValue(bufferReader, val, v, expectedOffset);
    }
  });
  test('BufferReader.getVarInt()', () {
    final hexStr =
        '0001fcfdfd00fdfe00fdff00fd0001fdfefffdfffffe00000100fefefffffffeffffffffff0000000001000000ffffffffffffff1f00';
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
    final bufferReader = BufferReader.fromHex(hexStr);
    for (var v in values) {
      int expectedOffset = bufferReader.offset;
      final val = bufferReader.getVarInt();
      expectedOffset += encodingLength(val);
      testValue(bufferReader, val, v, expectedOffset);
    }
  });
  test('BufferReader.getSlice()', () {
    final hexStr = '0101020304feff';
    final values = [
      [1],
      [1, 2, 3, 4],
      [254, 255]
    ];
    final bufferReader = BufferReader.fromHex(hexStr);
    for (var v in values) {
      final expectedOffset = bufferReader.offset + v.length;
      final val = bufferReader.getSlice(v.length).buffer.asUint8List();
      testValue(bufferReader, val, v, expectedOffset);
    }
  });
  test('BufferReader.getVarSlice()', () {
    const hexStr =
        '0101fc020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202fdfd0003030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303';

    final values = [
      Uint8List.fromList(List.filled(1, 1)),
      Uint8List.fromList(List.filled(252, 2)),
      Uint8List.fromList(List.filled(253, 3))
    ];

    final bufferReader = BufferReader.fromHex(hexStr);
    for (var v in values) {
      final expectedOffset =
          bufferReader.offset + encodingLength(v.length) + v.length;
      final val = bufferReader.getVarSlice().buffer.asUint8List();
      testValue(bufferReader, val, v, expectedOffset);
    }
  });
}
