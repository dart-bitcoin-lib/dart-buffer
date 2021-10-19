import 'dart:typed_data';

import 'package:dart_buffer/dart_buffer.dart';

void main() {
  final buffer = ByteData(8);
  final writer = BufferWriter(buffer);
  final reader = BufferReader(buffer);

  writer.setInt32(50332161);

  print(reader.getUInt32());
}
