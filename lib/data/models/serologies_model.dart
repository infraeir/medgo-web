class SerologiesModel {
  final QuadroModel syphilis;
  final QuadroModel toxoplasmosis;
  final QuadroModel viralHepatitis;
  final QuadroModel zika;

  SerologiesModel({
    required this.syphilis,
    required this.toxoplasmosis,
    required this.viralHepatitis,
    required this.zika,
  });

  factory SerologiesModel.fromMap({required Map<String, dynamic> map}) {
    return SerologiesModel(
      syphilis: map['syphilis'] != null
          ? QuadroModel.fromMap(map: map['syphilis'])
          : QuadroModel(q1: null, q2: null, q3: null),
      toxoplasmosis: map['toxoplasmosis'] != null
          ? QuadroModel.fromMap(map: map['toxoplasmosis'])
          : QuadroModel(q1: null, q2: null, q3: null),
      viralHepatitis: map['viralHepatitis'] != null
          ? QuadroModel.fromMap(map: map['viralHepatitis'])
          : QuadroModel(q1: null, q2: null, q3: null),
      zika: map['zika'] != null
          ? QuadroModel.fromMap(map: map['zika'])
          : QuadroModel(q1: null, q2: null, q3: null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'syphilis': syphilis.toJson(),
      'toxoplasmosis': toxoplasmosis.toJson(),
      'viralHepatitis': viralHepatitis.toJson(),
      'zika': zika.toJson(),
    };
  }
}

class QuadroModel {
  final String? q1;
  final String? q2;
  final String? q3;

  QuadroModel({
    required this.q1,
    required this.q2,
    required this.q3,
  });

  factory QuadroModel.fromMap({required Map<String, dynamic> map}) {
    return QuadroModel(
      q1: map['q1'],
      q2: map['q2'],
      q3: map['q3'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'q1': q1,
      'q2': q2,
      'q3': q3,
    };
  }
}
