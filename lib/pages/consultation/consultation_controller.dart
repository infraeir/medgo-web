import 'package:flutter/foundation.dart';
import 'package:medgo/data/models/consultation_model.dart';

class ConsultationController extends ValueNotifier<ConsultationModel> {
  ConsultationController(ConsultationModel value) : super(value);

  void updateValue(ConsultationModel newValue) {
    value = newValue;
  }
}
