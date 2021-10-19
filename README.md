# dart-buffer

This package generated for Buffer Utils. Package have reader and writer classes.

## Installation
        dart pub add dart_buffer

## Example
```dart
import 'dart:typed_data';

import 'package:dart_buffer/dart_buffer.dart';

void main() {
  final buffer = ByteData(8);
  final writer = BufferWriter(buffer);
  final reader = BufferReader(buffer);

  writer.setInt32(50332161);

  print(reader.getUInt32());
}
```

## LICENSE [MIT](LICENSE)
