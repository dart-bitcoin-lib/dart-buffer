int encodingLength(int number) {
  if (number < 0) {
    throw ArgumentError.value(
        number, 'number', 'Value should be unsigned integer.');
  }

  return (number < 0xfd
      ? 1
      : number <= 0xffff
          ? 3
          : number <= 0xffffffff
              ? 5
              : 9);
}
