import 'dart:math';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:dart_buffer/dart_buffer.dart';
import 'package:test/test.dart';

void main() {
  final numbers = List.generate(16, (index) => Random().nextInt(10).abs());
  final numbersNegative = List.generate(16, (index) {
    int num = 0;
    do {
      num = Random().nextInt(10).abs() * -1;
    } while (num == 0);

    return num;
  });
  final buffPositive = Uint8List.fromList(numbers);
  final buffNegative = Int8List.fromList(numbersNegative);

  group('constructors', () {
    test('BufferReader.fromList(Uint8List)', () {
      BufferReader? bufferReader;
      try {
        bufferReader = BufferReader.fromTypedData(buffPositive);
      } catch (e) {
        expect(e, isNull);
      }

      expect(bufferReader, isA<BufferReader>());
    });
    test('BufferReader.fromList(Int8List)', () {
      BufferReader? bufferReader;
      try {
        bufferReader =
            BufferReader.fromTypedData(buffPositive.buffer.asInt8List());
      } catch (e) {
        expect(e, isNull);
      }

      expect(bufferReader, isA<BufferReader>());
    });
    test('BufferReader()', () {
      BufferReader? bufferReader;
      try {
        bufferReader = BufferReader(buffPositive.buffer.asByteData());
      } catch (e) {
        expect(e, isNull);
      }

      expect(bufferReader, isA<BufferReader>());
    });
  });
  group('BufferReader.getInt8()', () {
    test('should be work positive', () {
      final bufferReader = BufferReader.fromTypedData(buffPositive);
      final actual = bufferReader.getInt8();
      expect(actual, equals(buffPositive[0]));
    });
    test('should be work negative', () {
      final bufferReader = BufferReader.fromTypedData(buffNegative);
      final actual = bufferReader.getInt8();
      expect(actual, equals(buffNegative[0]));
    });
    test('should be throws error', () {
      final bufferReader = BufferReader.fromTypedData(buffPositive);
      bufferReader.offset = bufferReader.length;
      try {
        bufferReader.getInt8();
      } catch (e) {
        expect(e, isA<IndexError>());
        return;
      }
      throw Exception('Should be throws.');
    });
  });
  group('BufferReader.getUInt8()', () {
    test('should be work', () {
      final bufferReader = BufferReader.fromTypedData(buffPositive);
      final actual = bufferReader.getUInt8();
      expect(actual, equals(buffPositive[0]));
    });
    test('should be throws error', () {
      final bufferReader = BufferReader.fromTypedData(buffPositive);
      bufferReader.offset = bufferReader.length;
      try {
        bufferReader.getUInt8();
      } catch (e) {
        expect(e, isA<IndexError>());
        return;
      }
      throw Exception('Should be throws.');
    });
  });
  group('BufferReader.getInt16()', () {
    test('should be work positive', () {
      final bufferReader = BufferReader.fromTypedData(buffPositive);
      final actual = bufferReader.getInt16();
      expect(
          actual,
          equals(int.parse(
              hex.encode(buffPositive.sublist(0, 2).reversed.toList()),
              radix: 16)));
    });
    test('should be work negative', () {
      final bufferReader = BufferReader.fromTypedData(buffNegative);
      final expected =
          Int8List.fromList(buffNegative.sublist(0, 2).reversed.toList())
              .buffer
              .asByteData()
              .getInt16(bufferReader.offset);
      final actual = bufferReader.getInt16();
      expect(actual, equals(expected));
    });
    test('should be throws error', () {
      final bufferReader = BufferReader.fromTypedData(buffPositive);
      bufferReader.offset = bufferReader.length;
      try {
        bufferReader.getInt16();
      } catch (e) {
        expect(e, isA<RangeError>());
        return;
      }
      throw Exception('Should be throws.');
    });
  });
  group('BufferReader.getUInt16()', () {
    test('should be work', () {
      final bufferReader = BufferReader.fromTypedData(buffPositive);
      final actual = bufferReader.getUInt16();
      expect(
          actual,
          equals(int.parse(
              hex.encode(buffPositive.sublist(0, 2).reversed.toList()),
              radix: 16)));
    });
    test('should be throws error', () {
      final bufferReader = BufferReader.fromTypedData(buffPositive);
      bufferReader.offset = bufferReader.length;
      try {
        bufferReader.getUInt16();
      } catch (e) {
        expect(e, isA<RangeError>());
        return;
      }
      throw Exception('Should be throws.');
    });
  });
  group('BufferReader.getInt32()', () {
    test('should be work positive', () {
      final bufferReader = BufferReader.fromTypedData(buffPositive);
      final actual = bufferReader.getInt32();
      expect(
          actual,
          equals(int.parse(
              hex.encode(buffPositive.sublist(0, 4).reversed.toList()),
              radix: 16)));
    });
    test('should be work negative', () {
      final bufferReader = BufferReader.fromTypedData(buffNegative);
      final expected =
          Int8List.fromList(buffNegative.sublist(0, 4).reversed.toList())
              .buffer
              .asByteData()
              .getInt32(bufferReader.offset);
      final actual = bufferReader.getInt32();
      expect(actual, equals(expected));
    });
    test('should be throws error', () {
      final bufferReader = BufferReader.fromTypedData(buffPositive);
      bufferReader.offset = bufferReader.length;
      try {
        bufferReader.getInt32();
      } catch (e) {
        expect(e, isA<RangeError>());
        return;
      }
      throw Exception('Should be throws.');
    });
  });
  group('BufferReader.getUInt32()', () {
    test('should be work', () {
      final bufferReader = BufferReader.fromTypedData(buffPositive);
      final actual = bufferReader.getUInt32();
      expect(
          actual,
          equals(int.parse(
              hex.encode(buffPositive.sublist(0, 4).reversed.toList()),
              radix: 16)));
    });
    test('should be throws error', () {
      final bufferReader = BufferReader.fromTypedData(buffPositive);
      bufferReader.offset = bufferReader.length;
      try {
        bufferReader.getUInt32();
      } catch (e) {
        expect(e, isA<RangeError>());
        return;
      }
      throw Exception('Should be throws.');
    });
  });
  group('BufferReader.getInt64()', () {
    test('should be work positive', () {
      final bufferReader = BufferReader.fromTypedData(buffPositive);
      final actual = bufferReader.getInt64();
      expect(
          actual,
          equals(int.parse(
              hex.encode(buffPositive.sublist(0, 8).reversed.toList()),
              radix: 16)));
    });
    test('should be work negative', () {
      final bufferReader = BufferReader.fromTypedData(buffNegative);
      final expected =
          Int8List.fromList(buffNegative.sublist(0, 8).reversed.toList())
              .buffer
              .asByteData()
              .getInt64(bufferReader.offset);
      final actual = bufferReader.getInt64();
      expect(actual, equals(expected));
    });
    test('should be throws error', () {
      final bufferReader = BufferReader.fromTypedData(buffPositive);
      bufferReader.offset = bufferReader.length;
      try {
        bufferReader.getInt64();
      } catch (e) {
        expect(e, isA<RangeError>());
        return;
      }
      throw Exception('Should be throws.');
    });
  });
  group('BufferReader.getUInt64()', () {
    test('should be work', () {
      final bufferReader = BufferReader.fromTypedData(buffPositive);
      final actual = bufferReader.getUInt64();
      expect(
          actual,
          equals(int.parse(
              hex.encode(buffPositive.sublist(0, 8).reversed.toList()),
              radix: 16)));
    });
    test('should be throws error', () {
      final bufferReader = BufferReader.fromTypedData(buffPositive);
      bufferReader.offset = bufferReader.length;
      try {
        bufferReader.getUInt64();
      } catch (e) {
        expect(e, isA<RangeError>());
        return;
      }
      throw Exception('Should be throws.');
    });
  });
  group('BufferReader.getVarInt()', () {
    test('8bit should be work', () {
      final list = Uint8List.fromList([0xfc]);
      final bufferReader = BufferReader.fromTypedData(list);
      final actual = bufferReader.getVarInt();
      expect(actual, equals(list[0]));
    });
    test('16bit should be work', () {
      final list =
          Uint8List.fromList([0xfd] + List.generate(2, (index) => index));
      final bufferReader = BufferReader.fromTypedData(list);
      final actual = bufferReader.getVarInt();
      final value = int.parse(hex.encode(list.reversed.toList().sublist(0, 2)),
          radix: 16);
      expect(actual, equals(value));
    });
    test('32bit should be work', () {
      final list =
          Uint8List.fromList([0xfe] + List.generate(4, (index) => index));
      final bufferReader = BufferReader.fromTypedData(list);
      final actual = bufferReader.getVarInt();
      final value = int.parse(hex.encode(list.reversed.toList().sublist(0, 4)),
          radix: 16);
      expect(actual, equals(value));
    });
    test('64bit should be work', () {
      final list =
          Uint8List.fromList([0xff] + List.generate(8, (index) => index));
      final bufferReader = BufferReader.fromTypedData(list);
      final actual = bufferReader.getVarInt();
      final value = BigInt.parse(
          hex.encode(list.reversed.toList().sublist(0, 8)),
          radix: 16);
      expect(actual, equals(value.toInt()));
    });
  });
  group('BufferReader.getSlice()', () {
    test('should be return ByteData', () {
      final bufferReader = BufferReader.fromTypedData(buffPositive);
      final actual = bufferReader.getSlice(10).buffer.asUint8List();
      final expected = buffPositive.sublist(0, 10);
      expect(hex.encode(actual), equals(hex.encode(expected)));
    });
    test('should be throws error', () {
      final bufferReader = BufferReader.fromTypedData(buffPositive);
      bufferReader.offset = bufferReader.length;
      try {
        bufferReader.getSlice(10);
      } catch (e) {
        expect(e, isA<IndexError>());
        return;
      }
      throw Exception('Should be throws.');
    });
  });
  group('BufferReader.getVarSlice()', () {
    test('should be return ByteData', () {
      final bufferReader =
          BufferReader.fromTypedData(Uint8List.fromList([10, ...buffPositive]));
      final actual = bufferReader.getVarSlice().buffer.asUint8List();
      final expected = buffPositive.sublist(0, 10);
      expect(hex.encode(actual), equals(hex.encode(expected)));
    });
    test('should be throws error', () {
      final bufferReader = BufferReader.fromTypedData(buffPositive);
      bufferReader.offset = bufferReader.length;
      try {
        bufferReader.getVarSlice();
      } catch (e) {
        expect(e, isA<IndexError>());
        return;
      }
      throw Exception('Should be throws.');
    });
  });
}
