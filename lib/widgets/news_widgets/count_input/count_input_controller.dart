import 'package:flutter/material.dart';

class CountInputController extends ValueNotifier<int> {
  CountInputController(int value) : super(value);

  void reset() {
    value = 0;
  }

  void increment() => value++;
  void decrement() => value > 0 ? value-- : null;
}
