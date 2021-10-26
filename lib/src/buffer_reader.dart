import 'dart:typed_data';

import 'package:convert/convert.dart';

/// Buffer Reader
class BufferReader {
  ByteData buffer;
  int offset;

  get length => buffer.lengthInBytes;

  /// BufferReader from ByteData
  BufferReader(this.buffer, [this.offset = 0]);

  /// BufferReader from TypedData
  factory BufferReader.fromTypedData(TypedData buffer, [offset = 0]) {
    return BufferReader(buffer.buffer.asByteData(), offset);
  }

  /// BufferReader from hex string
  factory BufferReader.fromHex(String data, [offset = 0]) {
    return BufferReader.fromTypedData(
        Uint8List.fromList(hex.decode(data)), offset);
  }

  /// Set offset to zero
  reset() {
    offset = 0;
  }

  ///Reads byteLength number of bytes from buf at the current offset
  /// and interprets the result as an unsigned, [Endian] integer
  /// supporting up to 48 bits of accuracy.
  int getUInt([int byteLength = 0, Endian endian = Endian.little]) {
    if (offset + byteLength > length) {
      throw IndexError(byteLength, buffer, 'IndexError',
          'Cannot get UIntLE out of bounds', buffer.lengthInBytes);
    }
    if (endian != Endian.little) {
      var val = buffer.buffer.asUint8List()[offset];
      var mul = 1;
      var i = 0;
      while (++i < byteLength && (mul *= 0x100) != 0) {
        val += buffer.buffer.asUint8List()[offset + i] * mul;
      }
      return val;
    } else {
      var val = buffer.buffer.asUint8List()[offset + --byteLength];
      var mul = 1;
      while (byteLength > 0 && (mul *= 0x100) != 0) {
        val += buffer.buffer.asUint8List()[offset + --byteLength] * mul;
      }
      return val;
    }
  }

  /// Returns the (possibly negative) integer represented by the byte at
  /// current offset in buffer, in two's complement binary
  /// representation.
  ///
  /// The return value will be between -128 and 127, inclusive.
  int getInt8() {
    final result = buffer.getInt8(offset);
    offset++;
    return result;
  }

  /// Returns the positive integer represented by the byte.
  /// Increments the offset value by one.
  /// The return value will be between 0 and 255, inclusive.
  int getUInt8() {
    final result = buffer.getUint8(offset);
    offset++;
    return result;
  }

  /// Returns the (possibly negative) integer represented by the four bytes
  /// Increments the offset value by four
  /// The return value will be between -2<sup>15</sup> and 2<sup>15</sup> - 1,
  /// inclusive.
  int getInt16([Endian endian = Endian.little]) {
    final result = buffer.getInt16(offset, endian);
    offset += 2;
    return result;
  }

  /// Returns the positive integer represented by the four bytes
  /// Increments the offset value by four
  /// The return value will be between 0 and  2<sup>16</sup> - 1, inclusive.
  int getUInt16([Endian endian = Endian.little]) {
    final result = buffer.getUint16(offset, endian);
    offset += 2;
    return result;
  }

  /// Returns the (possibly negative) integer represented by the four bytes
  /// Increments the offset value by four
  /// The return value will be between -2<sup>15</sup> and 2<sup>15</sup> - 1,
  /// inclusive.
  int getInt32([Endian endian = Endian.little]) {
    final result = buffer.getInt32(offset, endian);
    offset += 4;
    return result;
  }

  /// Returns the positive integer represented by the four bytes
  /// Increments the offset value by four
  /// The return value will be between 0 and  2<sup>32</sup> - 1, inclusive.
  int getUInt32([Endian endian = Endian.little]) {
    final result = buffer.getUint32(offset, endian);
    offset += 4;
    return result;
  }

  /// Returns the positive integer represented by the eight bytes
  /// Increments the offset value by eight
  /// The return value will be between 0 and  2<sup>64</sup> - 1, inclusive.
  int getInt64([Endian endian = Endian.little]) {
    final result = buffer.getInt64(offset, endian);
    offset += 8;
    return result;
  }

  /// Returns the positive integer represented by the eight bytes
  /// Increments the offset value by eight
  /// The return value will be between 0 and  2<sup>64</sup> - 1, inclusive.
  int getUInt64([Endian endian = Endian.little]) {
    final result = buffer.getUint64(offset, endian);
    offset += 8;
    return result;
  }

  /// Returns the floating point number represented by the four bytes,
  /// in IEEE 754 single-precision binary floating-point format (binary32).
  double getFloat32([Endian endian = Endian.little]) {
    final result = buffer.getFloat32(offset, endian);
    offset += 8;
    return result;
  }

  /// Returns the floating point number represented by the eight bytes,
  /// in IEEE 754 double-precision binary floating-point format (binary64).
  double getFloat64([Endian endian = Endian.little]) {
    final result = buffer.getFloat64(offset, endian);
    offset += 8;
    return result;
  }

  /// Get next byte and return an int value based on the data length specified by this byte.
  /// The return value will between 0 and 2<sup>64</sup> - 1, inclusive.
  int getVarInt([Endian endian = Endian.little]) {
    ByteData bufferByteData = buffer.buffer.asByteData();
    int first = bufferByteData.getUint8(offset);
    int output;
    // 8 bit
    if (first < 0xfd) {
      output = first;
      offset += 1;
      // 16 bit
    } else if (first == 0xfd) {
      output = bufferByteData.getUint16(offset + 1, endian);
      offset += 3;

      // 32 bit
    } else if (first == 0xfe) {
      output = bufferByteData.getUint32(offset + 1, endian);
      offset += 5;

      // 64 bit
    } else {
      output = bufferByteData.getUint64(offset + 1, endian);
      offset += 9;
    }

    return output;
  }

  /// Get next n bytes
  /// The return value will be ByteData(n)
  ByteData getSlice(int n) {
    if (buffer.lengthInBytes < offset + n) {
      throw IndexError(n, buffer, 'IndexError',
          'Cannot get slice out of bounds', buffer.lengthInBytes);
    }
    final result = buffer.buffer
        .asUint8List()
        .sublist(offset, offset + n)
        .buffer
        .asByteData();
    offset += n;
    return result;
  }

  /// Get next byte and return an ByteData value based on the data length specified by this byte.
  /// The return value will be ByteData.
  ByteData getVarSlice([Endian endian = Endian.little]) {
    return getSlice(getVarInt(endian));
  }

  /// Get vector list
  /// The return value will be List<ByteData>.
  List<ByteData> getVector([Endian endian = Endian.little]) {
    final count = getVarInt();
    const List<ByteData> vector = [];
    for (int i = 0; i < count; i++) {
      vector.add(getVarSlice(endian));
    }
    return vector;
  }
}
