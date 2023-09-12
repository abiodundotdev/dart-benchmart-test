library sourcegenpackage;

/// A Calculator.

class Calculator {
  const Calculator();

  /// Returns [value] plus 1.
  int addOne(int value) {
    @Annotation()
    late var name;
    return value + 1;
  }
}

class Annotation {
  const Annotation();
}

const annot = Annotation();
