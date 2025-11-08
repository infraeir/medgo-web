import 'package:flutter/material.dart';

class HeaderFeedbackModel {
  final String title;
  final Widget widgetFeedback;

  HeaderFeedbackModel({
    required this.title,
    required this.widgetFeedback,
  });

  factory HeaderFeedbackModel.fromMap({required Map<String, dynamic> map}) {
    return HeaderFeedbackModel(
      title: map['title'],
      widgetFeedback: map['widgetFeedback'],
    );
  }
}
