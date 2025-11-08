import 'package:medgo/data/models/serologies_model.dart';
import 'package:medgo/data/models/vaccines_model.dart';

class PrenatalModel {
  final String? firstConsultationQuarter;
  final int? numberOfConsultations;
  final bool? ironSupplementationDone;
  final VacinnesModel vaccines;
  final SerologiesModel serologies;

  PrenatalModel({
    required this.firstConsultationQuarter,
    required this.numberOfConsultations,
    required this.ironSupplementationDone,
    required this.vaccines,
    required this.serologies,
  });

  factory PrenatalModel.fromMap({required Map<String, dynamic> map}) {
    return PrenatalModel(
      firstConsultationQuarter: map['firstConsultationQuarter'],
      numberOfConsultations: map['numberOfConsultations'],
      ironSupplementationDone: map['ironSupplementationDone'],
      vaccines: map['vaccines'] == null
          ? VacinnesModel(
              dPta: null, influenza: null, hepatitisB: null, covid19: null)
          : VacinnesModel.fromMap(map: map['vaccines']),
      serologies: map['serologies'] == null
          ? SerologiesModel(
              syphilis: QuadroModel(q1: null, q2: null, q3: null),
              toxoplasmosis: QuadroModel(q1: null, q2: null, q3: null),
              viralHepatitis: QuadroModel(q1: null, q2: null, q3: null),
              zika: QuadroModel(q1: null, q2: null, q3: null))
          : SerologiesModel.fromMap(map: map['serologies']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstConsultationQuarter': firstConsultationQuarter,
      'numberOfConsultations': numberOfConsultations,
      'ironSupplementationDone': ironSupplementationDone,
      'vaccines': vaccines.toJson(),
      'serologies': serologies.toJson(),
    };
  }
}
